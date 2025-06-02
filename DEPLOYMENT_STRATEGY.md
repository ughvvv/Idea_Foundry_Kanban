# Deployment Strategy - Environment Setup & Scaling

This document outlines the deployment strategy for the 6-layer AI system architecture, covering environment setup, scaling profiles, and operational procedures.

## 📋 Table of Contents

1. [Environment Layout](#environment-layout)
2. [Infrastructure Components](#infrastructure-components)
3. [Auto-Scaling Strategy](#auto-scaling-strategy)
4. [Deployment Pipelines](#deployment-pipelines)
5. [Monitoring & Observability](#monitoring--observability)
6. [Security & Compliance](#security--compliance)
7. [Cost Management](#cost-management)
8. [Operational Procedures](#operational-procedures)

## 🏗️ Environment Layout

### Development Environment
**Purpose**: Local development and unit testing
**Infrastructure**:
- **Kubernetes**: minikube (local cluster)
- **Database**: PostgreSQL 15 (local instance)
- **Message Queue**: Apache Kafka (local, single broker)
- **Storage**: Local filesystem
- **Monitoring**: Basic logging to console

**Setup Commands**:
```bash
# Start minikube
minikube start --memory=8192 --cpus=4

# Install PostgreSQL locally
brew install postgresql@15
brew services start postgresql@15

# Install Kafka locally
brew install kafka
brew services start kafka
```

**Resource Allocation**:
- CPU: 4 cores
- Memory: 8GB RAM
- Storage: 50GB local disk

---

### Test Environment
**Purpose**: Integration testing, staging, and pre-production validation
**Infrastructure**:
- **Kubernetes**: EKS dev cluster (2 × t3.medium nodes)
- **Database**: Aurora PostgreSQL (db.t3.medium)
- **Message Queue**: Amazon MSK (kafka.t3.small, 2 brokers)
- **Storage**: EBS gp3 volumes
- **Monitoring**: CloudWatch + basic Grafana

**Resource Allocation**:
- **EKS Nodes**: 2 × t3.medium (2 vCPU, 4GB RAM each)
- **Aurora**: db.t3.medium (2 vCPU, 4GB RAM)
- **MSK**: 2 × kafka.t3.small (2 vCPU, 4GB RAM each)
- **Storage**: 100GB EBS gp3

**Cost Estimate**: ~$300-400/month

---

### Production Environment
**Purpose**: Live system serving production workloads
**Infrastructure**:
- **Kubernetes**: EKS prod cluster (2 × m5.large + 4 × p3.2xlarge)
- **Database**: Aurora PostgreSQL GlobalCluster (writer + 2 readers)
- **Message Queue**: Amazon MSK Standard (3 × kafka.m5.large brokers)
- **ML Compute**: Ray cluster on EKS (GPU nodes)
- **Storage**: EBS gp3 + S3 for archival
- **Monitoring**: Full Prometheus/Grafana + CloudWatch

**Resource Allocation**:
- **EKS General**: 2 × m5.large (2 vCPU, 8GB RAM each)
- **EKS GPU**: 4 × p3.2xlarge (8 vCPU, 61GB RAM, 1 × V100 each)
- **Aurora Writer**: db.r5.xlarge (4 vCPU, 32GB RAM)
- **Aurora Readers**: 2 × db.r5.large (2 vCPU, 16GB RAM each)
- **MSK**: 3 × kafka.m5.large (2 vCPU, 8GB RAM each)
- **Storage**: 500GB EBS gp3 + unlimited S3

**Cost Estimate**: ~$3,000-4,000/month

## 🔧 Infrastructure Components

### Kubernetes Configuration

#### EKS Cluster Setup
```yaml
# eks-cluster.yaml
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: ideation-engine-prod
  region: us-west-2
  version: "1.28"

nodeGroups:
  - name: general-nodes
    instanceType: m5.large
    minSize: 2
    maxSize: 10
    desiredCapacity: 2
    volumeSize: 100
    volumeType: gp3
    labels:
      node-type: general
    
  - name: gpu-nodes
    instanceType: p3.2xlarge
    minSize: 1
    maxSize: 8
    desiredCapacity: 4
    volumeSize: 200
    volumeType: gp3
    labels:
      node-type: gpu
    taints:
      - key: nvidia.com/gpu
        value: "true"
        effect: NoSchedule

managedNodeGroups:
  - name: system-nodes
    instanceType: t3.medium
    minSize: 2
    maxSize: 4
    desiredCapacity: 2
    labels:
      node-type: system
```

#### Namespace Organization
```yaml
# namespaces.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: l0-ingestion
  labels:
    layer: "L0"
---
apiVersion: v1
kind: Namespace
metadata:
  name: l1-allocation
  labels:
    layer: "L1"
---
apiVersion: v1
kind: Namespace
metadata:
  name: l2-dialogue
  labels:
    layer: "L2"
---
apiVersion: v1
kind: Namespace
metadata:
  name: l3-evolution
  labels:
    layer: "L3"
---
apiVersion: v1
kind: Namespace
metadata:
  name: l4-training
  labels:
    layer: "L4"
---
apiVersion: v1
kind: Namespace
metadata:
  name: l5-observability
  labels:
    layer: "L5"
---
apiVersion: v1
kind: Namespace
metadata:
  name: monitoring
  labels:
    purpose: "monitoring"
```

### Database Configuration

#### Aurora PostgreSQL Setup
```sql
-- Primary cluster configuration
CREATE CLUSTER ideation-engine-prod
  ENGINE aurora-postgresql
  ENGINE_VERSION 15.4
  MASTER_USERNAME postgres
  MANAGE_MASTER_USER_PASSWORD
  DATABASE_NAME ideation_engine
  BACKUP_RETENTION_PERIOD 7
  PREFERRED_BACKUP_WINDOW "03:00-04:00"
  PREFERRED_MAINTENANCE_WINDOW "sun:04:00-sun:05:00"
  STORAGE_ENCRYPTED true
  DELETION_PROTECTION true;

-- Read replicas
CREATE DB_INSTANCE ideation-engine-reader-1
  DB_INSTANCE_CLASS db.r5.large
  ENGINE aurora-postgresql
  DB_CLUSTER_IDENTIFIER ideation-engine-prod;

CREATE DB_INSTANCE ideation-engine-reader-2
  DB_INSTANCE_CLASS db.r5.large
  ENGINE aurora-postgresql
  DB_CLUSTER_IDENTIFIER ideation-engine-prod;
```

#### Database Schema Initialization
```sql
-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS vector;
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- Core tables (see TASK_BREAKDOWN.md for complete schemas)
CREATE TABLE events_vector (
  event_id UUID PRIMARY KEY,
  axis CHAR(1) NOT NULL,
  title TEXT,
  body TEXT,
  tags TEXT[],
  vec VECTOR(1536),
  vec_rgat VECTOR(256),
  created_ts TIMESTAMPTZ NOT NULL DEFAULT now(),
  cluster_id BIGINT,
  updated_ts TIMESTAMPTZ
);

-- Indexes for performance
CREATE INDEX idx_ev_axis_created ON events_vector(axis, created_ts);
CREATE INDEX idx_ev_cluster ON events_vector(cluster_id);
CREATE INDEX idx_ev_vec_hnsw ON events_vector USING hnsw (vec vector_cosine_ops);
```

### Message Queue Configuration

#### Amazon MSK Setup
```json
{
  "ClusterName": "ideation-engine-kafka",
  "KafkaVersion": "2.8.1",
  "NumberOfBrokerNodes": 3,
  "BrokerNodeGroupInfo": {
    "InstanceType": "kafka.m5.large",
    "ClientSubnets": [
      "subnet-12345678",
      "subnet-87654321",
      "subnet-11223344"
    ],
    "SecurityGroups": ["sg-kafka-cluster"],
    "StorageInfo": {
      "EBSStorageInfo": {
        "VolumeSize": 100
      }
    }
  },
  "EncryptionInfo": {
    "EncryptionAtRest": {
      "DataVolumeKMSKeyId": "arn:aws:kms:us-west-2:123456789012:key/12345678-1234-1234-1234-123456789012"
    },
    "EncryptionInTransit": {
      "ClientBroker": "TLS",
      "InCluster": true
    }
  },
  "ConfigurationInfo": {
    "Arn": "arn:aws:kafka:us-west-2:123456789012:configuration/ideation-engine-config/12345678-1234-1234-1234-123456789012-1",
    "Revision": 1
  }
}
```

#### Kafka Topic Configuration
```bash
# Raw events topics (9 axes)
for axis in R T G A P C M S D; do
  kafka-topics.sh --create \
    --topic "raw_events.$axis" \
    --partitions 6 \
    --replication-factor 3 \
    --config retention.ms=604800000 \
    --config compression.type=lz4
done

# Parsed events topics (9 axes)
for axis in R T G A P C M S D; do
  kafka-topics.sh --create \
    --topic "parsed_events.$axis" \
    --partitions 6 \
    --replication-factor 3 \
    --config retention.ms=2592000000 \
    --config compression.type=lz4
done

# Control topics
kafka-topics.sh --create \
  --topic "rl_rewards" \
  --partitions 3 \
  --replication-factor 3 \
  --config retention.ms=86400000
```

## 📈 Auto-Scaling Strategy

### Horizontal Pod Autoscaler (HPA)

#### L0 Crawlers
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: crawler-hpa
  namespace: l0-ingestion
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: axis-crawlers
  minReplicas: 9  # One per axis
  maxReplicas: 27  # Up to 3 per axis
  metrics:
  - type: External
    external:
      metric:
        name: kafka_consumer_lag
      target:
        type: AverageValue
        averageValue: "1000"
  behavior:
    scaleUp:
      stabilizationWindowSeconds: 300
      policies:
      - type: Percent
        value: 100
        periodSeconds: 60
    scaleDown:
      stabilizationWindowSeconds: 600
      policies:
      - type: Percent
        value: 50
        periodSeconds: 60
```

#### L2 Dialogue Pods
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: dialogue-pods-hpa
  namespace: l2-dialogue
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: orchestrator
  minReplicas: 3
  maxReplicas: 50
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
  - type: External
    external:
      metric:
        name: queue_depth
      target:
        type: AverageValue
        averageValue: "10"
```

### Vertical Pod Autoscaler (VPA)

#### Ray Embedding Workers
```yaml
apiVersion: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler
metadata:
  name: ray-workers-vpa
  namespace: l0-ingestion
spec:
  targetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: ray-workers
  updatePolicy:
    updateMode: "Auto"
  resourcePolicy:
    containerPolicies:
    - containerName: ray-worker
      minAllowed:
        cpu: 1000m
        memory: 4Gi
      maxAllowed:
        cpu: 8000m
        memory: 32Gi
      controlledResources: ["cpu", "memory"]
```

### Cluster Autoscaler

#### Node Group Scaling
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: cluster-autoscaler-status
  namespace: kube-system
data:
  nodes.max: "20"
  nodes.min: "4"
  scale-down-delay-after-add: "10m"
  scale-down-unneeded-time: "10m"
  scale-down-utilization-threshold: "0.5"
  skip-nodes-with-local-storage: "false"
  skip-nodes-with-system-pods: "false"
```

### Cost-Based Scaling Rules

#### Daily Budget Controls
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: cost-controls
  namespace: l5-observability
data:
  daily_llm_budget: "200"  # USD
  cost_per_idea_limit: "0.10"  # USD
  entropy_threshold: "0.02"
  scaling_policies: |
    - condition: daily_spend > daily_llm_budget
      action: reduce_pods_per_stage
      value: 0.8
    - condition: cost_per_idea > cost_per_idea_limit
      action: alert_pagerduty
    - condition: cluster_entropy < entropy_threshold
      action: stop_bn_pods
      duration: 3_generations
```

## 🚀 Deployment Pipelines

### GitHub Actions Workflow

#### Main Deployment Pipeline
```yaml
# .github/workflows/deploy.yml
name: Deploy to Environment

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

env:
  AWS_REGION: us-west-2
  EKS_CLUSTER_NAME: ideation-engine-prod

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'
          
      - name: Install dependencies
        run: |
          pip install -r requirements.txt
          pip install pytest pytest-cov
          
      - name: Run tests
        run: |
          pytest tests/ --cov=src/ --cov-report=xml
          
      - name: Upload coverage
        uses: codecov/codecov-action@v3

  build:
    needs: test
    runs-on: ubuntu-latest
    outputs:
      image-tag: ${{ steps.meta.outputs.tags }}
    steps:
      - uses: actions/checkout@v3
      
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ env.AWS_REGION }}
          
      - name: Login to Amazon ECR
        id: login-ecr
        uses: aws-actions/amazon-ecr-login@v1
        
      - name: Extract metadata
        id: meta
        uses: docker/metadata-action@v4
        with:
          images: ${{ steps.login-ecr.outputs.registry }}/ideation-engine
          tags: |
            type=ref,event=branch
            type=ref,event=pr
            type=sha,prefix={{branch}}-
            
      - name: Build and push Docker image
        uses: docker/build-push-action@v4
        with:
          context: .
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}

  deploy-dev:
    if: github.ref == 'refs/heads/develop'
    needs: build
    runs-on: ubuntu-latest
    environment: development
    steps:
      - uses: actions/checkout@v3
      
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ env.AWS_REGION }}
          
      - name: Update kubeconfig
        run: |
          aws eks update-kubeconfig --region ${{ env.AWS_REGION }} --name ideation-engine-dev
          
      - name: Deploy to dev
        run: |
          helm upgrade --install ideation-engine ./helm/ideation-engine \
            --namespace default \
            --set image.tag=${{ needs.build.outputs.image-tag }} \
            --set environment=development \
            --values ./helm/values-dev.yaml

  deploy-prod:
    if: github.ref == 'refs/heads/main'
    needs: build
    runs-on: ubuntu-latest
    environment: production
    steps:
      - uses: actions/checkout@v3
      
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ env.AWS_REGION }}
          
      - name: Update kubeconfig
        run: |
          aws eks update-kubeconfig --region ${{ env.AWS_REGION }} --name ${{ env.EKS_CLUSTER_NAME }}
          
      - name: Deploy to production
        run: |
          helm upgrade --install ideation-engine ./helm/ideation-engine \
            --namespace default \
            --set image.tag=${{ needs.build.outputs.image-tag }} \
            --set environment=production \
            --values ./helm/values-prod.yaml \
            --wait --timeout=10m
```

### Helm Charts Structure

#### Main Chart Values
```yaml
# helm/values-prod.yaml
global:
  environment: production
  region: us-west-2
  
image:
  repository: 123456789012.dkr.ecr.us-west-2.amazonaws.com/ideation-engine
  tag: latest
  pullPolicy: IfNotPresent

# Layer-specific configurations
l0:
  crawlers:
    replicas: 9
    resources:
      requests:
        cpu: 500m
        memory: 1Gi
      limits:
        cpu: 2000m
        memory: 4Gi
  
  etl:
    replicas: 3
    resources:
      requests:
        cpu: 1000m
        memory: 2Gi
      limits:
        cpu: 4000m
        memory: 8Gi

l2:
  orchestrator:
    replicas: 3
    resources:
      requests:
        cpu: 2000m
        memory: 4Gi
      limits:
        cpu: 8000m
        memory: 16Gi
  
  agents:
    replicas: 10
    resources:
      requests:
        cpu: 1000m
        memory: 2Gi
      limits:
        cpu: 4000m
        memory: 8Gi

# Database configuration
database:
  host: ideation-engine-prod.cluster-xyz.us-west-2.rds.amazonaws.com
  port: 5432
  name: ideation_engine
  ssl: require

# Kafka configuration
kafka:
  brokers:
    - b-1.ideation-engine-kafka.xyz.c2.kafka.us-west-2.amazonaws.com:9092
    - b-2.ideation-engine-kafka.xyz.c2.kafka.us-west-2.amazonaws.com:9092
    - b-3.ideation-engine-kafka.xyz.c2.kafka.us-west-2.amazonaws.com:9092

# Monitoring
monitoring:
  prometheus:
    enabled: true
    retention: 30d
  grafana:
    enabled: true
    adminPassword: ${GRAFANA_ADMIN_PASSWORD}
  
# Security
security:
  networkPolicies:
    enabled: true
  podSecurityStandards:
    enabled: true
    profile: restricted
```

## 📊 Monitoring & Observability

### Prometheus Configuration

#### Scrape Configs
```yaml
# prometheus.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

rule_files:
  - "rules/*.yml"

scrape_configs:
  - job_name: 'kubernetes-pods'
    kubernetes_sd_configs:
      - role: pod
    relabel_configs:
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
        action: keep
        regex: true
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
        action: replace
        target_label: __metrics_path__
        regex: (.+)

  - job_name: 'l0-crawlers'
    kubernetes_sd_configs:
      - role: pod
        namespaces:
          names: ['l0-ingestion']
    relabel_configs:
      - source_labels: [__meta_kubernetes_pod_label_component]
        action: keep
        regex: crawler

  - job_name: 'l2-agents'
    kubernetes_sd_configs:
      - role: pod
        namespaces:
          names: ['l2-dialogue']
    relabel_configs:
      - source_labels: [__meta_kubernetes_pod_label_component]
        action: keep
        regex: agent

alerting:
  alertmanagers:
    - static_configs:
        - targets:
          - alertmanager:9093
```

#### Alert Rules
```yaml
# rules/ideation-engine.yml
groups:
  - name: ideation-engine
    rules:
      - alert: HighKafkaLag
        expr: kafka_consumer_lag_sum > 10000
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High Kafka consumer lag detected"
          description: "Kafka consumer lag is {{ $value }} for topic {{ $labels.topic }}"

      - alert: HighLLMCost
        expr: daily_llm_spend > 200
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "Daily LLM spend exceeded budget"
          description: "Daily LLM spend is ${{ $value }}, exceeding budget of $200"

      - alert: LowClusterEntropy
        expr: cluster_entropy < 0.02
        for: 15m
        labels:
          severity: warning
        annotations:
          summary: "Cluster entropy below threshold"
          description: "Cluster {{ $labels.cluster_id }} entropy is {{ $value }}"

      - alert: PodCrashLooping
        expr: rate(kube_pod_container_status_restarts_total[15m]) > 0
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "Pod is crash looping"
          description: "Pod {{ $labels.pod }} in namespace {{ $labels.namespace }} is crash looping"
```

### Grafana Dashboards

#### System Overview Dashboard
```json
{
  "dashboard": {
    "title": "Ideation Engine - System Overview",
    "panels": [
      {
        "title": "Daily Token Spend by Model",
        "type": "stat",
        "targets": [
          {
            "expr": "sum(daily_token_spend) by (model)",
            "legendFormat": "{{ model }}"
          }
        ]
      },
      {
        "title": "Cluster Entropy Distribution",
        "type": "histogram",
        "targets": [
          {
            "expr": "histogram_quantile(0.95, cluster_entropy_bucket)",
            "legendFormat": "95th percentile"
          }
        ]
      },
      {
        "title": "Elo Drift Over Time",
        "type": "graph",
        "targets": [
          {
            "expr": "rate(elo_rating_changes[1h])",
            "legendFormat": "Elo changes/hour"
          }
        ]
      }
    ]
  }
}
```

## 🔒 Security & Compliance

### Network Security

#### Network Policies
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: l0-ingestion-policy
  namespace: l0-ingestion
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          name: l1-allocation
    - namespaceSelector:
        matchLabels:
          name: monitoring
  egress:
  - to:
    - namespaceSelector:
        matchLabels:
          name: l1-allocation
  - to: []
    ports:
    - protocol: TCP
      port: 443  # HTTPS
    - protocol: TCP
      port: 9092  # Kafka
    - protocol: TCP
      port: 5432  # PostgreSQL
```

### Pod Security Standards

#### Security Context
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secure-pod
spec:
  securityContext:
    runAsNonRoot: true
    runAsUser: 1000
    runAsGroup: 1000
    fsGroup: 1000
    seccompProfile:
      type: RuntimeDefault
  containers:
  - name: app
    image: ideation-engine:latest
    securityContext:
      allowPrivilegeEscalation: false
      readOnlyRootFilesystem: true
      capabilities:
        drop:
        - ALL
    resources:
      limits:
        cpu: 1000m
        memory: 2Gi
      requests:
        cpu: 500m
        memory: 1Gi
```

### Secrets Management

#### AWS Secrets Manager Integration
```yaml
apiVersion: external-secrets.io/v1beta1
kind: SecretStore
metadata:
  name: aws-secrets-manager
  namespace: default
spec:
  provider:
    aws:
      service: SecretsManager
      region: us-west-2
      auth:
        secretRef:
          accessKeyID:
            name: aws-credentials
            key: access-key-id
          secretAccessKey:
            name: aws-credentials
            key: secret-access-key
---
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: api-keys
  namespace: default
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: aws-secrets-manager
    kind: SecretStore
  target:
    name: api-keys
    creationPolicy: Owner
  data:
  - secretKey: openai-api-key
    remoteRef:
      key: ideation-engine/openai
      property: api-key
  - secretKey: anthropic-api-key
    remoteRef:
      key: ideation-engine/anthropic
      property: api-key
```

## 💰 Cost Management

### Resource Optimization

#### Spot Instance Configuration
```yaml
# spot-instances.yaml
apiVersion: karpenter.sh/v1alpha5
kind: Provisioner
metadata:
  name: spot-provisioner
spec:
  requirements:
    - key: karpenter.sh/capacity-type
      operator: In
      values: ["spot"]
    - key: kubernetes.io/arch
      operator: In
      values: ["amd64"]
  limits:
    resources:
      cpu: 1000
      memory: 1000Gi
  providerRef:
    name: spot-nodepool
  ttlSecondsAfterEmpty: 30
  ttlSecondsUntilExpired: 2592000  # 30 days
```

#### Cost Monitoring
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: cost-monitoring
data:
  cost_allocation_tags: |
    - layer
    - component
    - environment
  budget_alerts:
    - threshold: 80
      type: percentage
      action: email
    - threshold: 100
      type: percentage
      action: pagerduty
  optimization_rules:
    - condition: cpu_utilization < 20%
      duration: 1h
      action: downscale
    - condition: memory_utilization < 30%
      duration: 1h
      action: downscale
```

## 🔧 Operational Procedures

### Deployment Checklist

#### Pre-Deployment
- [ ] All tests passing in CI/CD
- [ ] Security scan completed
- [ ] Database migrations tested
- [ ] Rollback plan prepared
- [ ] Monitoring alerts configured
- [ ] Stakeholder notification sent

#### During Deployment
- [ ] Monitor deployment progress
- [ ] Verify health checks
- [ ] Check application logs
- [ ] Validate key metrics
- [ ] Test critical user flows

#### Post-Deployment
- [ ] Verify all services healthy
- [ ] Check performance metrics
- [ ] Validate data integrity
- [ ] Update documentation
- [ ] Send completion notification

### Incident Response

#### Severity Levels
- **P0 (Critical)**: System down, data loss, security breach
- **P1 (High)**: Major feature broken, significant performance degradation
- **P2 (Medium)**: Minor feature issues, moderate performance impact
- **P3 (Low)**: Cosmetic issues, minor performance impact

#### Response Procedures
```yaml
incident_response:
  p0:
    response_time: 15_minutes
    escalation: immediate
    communication: every_30_minutes
  p1:
    response_time: 1_hour
    escalation: 2_hours
    communication: every_2_hours
  p2:
    response_time: 4_hours
    escalation: next_business_day
    communication: daily
  p3:
    response_time: next_business_day
    escalation: weekly
    communication: weekly
```

### Backup & Recovery

#### Database Backup Strategy
```bash
# Automated daily backups
aws rds create-db-cluster-snapshot \
  --db-cluster-identifier ideation-engine-prod \
  --db-cluster-snapshot-identifier "ideation-engine-$(date +%Y%m%d)"

# Point-in-time recovery testing
aws rds restore-db-cluster-to-point-in-time \
  --source-db-cluster-identifier ideation-engine-prod \
  --db-cluster-identifier ideation-engine-recovery-test \
  --restore-to-time "2024-01-01T12:00:00.000Z"
```

#### Disaster Recovery Plan
1. **RTO (Recovery Time Objective)**: 4 hours
2. **RPO (Recovery Point Objective)**: 1 hour
3. **Backup Frequency**: Every 6 hours + continuous WAL
4. **Cross-Region Replication**: Enabled to us-east-1
5. **Recovery Testing**: Monthly automated tests

---

*This deployment strategy provides a comprehensive foundation for deploying and operating the 6-layer AI system architecture with proper scaling, monitoring, security, an
