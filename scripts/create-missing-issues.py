#!/usr/bin/env python3
"""
Create Missing Issues Script
Creates all remaining issues that weren't covered in previous scripts
"""

import subprocess
import sys
from typing import List

# Configuration
REPO = "ughvvv/Idea_Foundry_Kanban"
PROJECT_ID = "2"

def run_gh_command(cmd: List[str]) -> str:
    """Run a GitHub CLI command and return output"""
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, check=True)
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        print(f"Error running command {' '.join(cmd)}: {e}")
        return ""

def create_issue_and_add(title: str, body: str, labels: str, milestone: str) -> bool:
    """Create an issue and add it to the project"""
    print(f"Creating: {title}")
    
    # Create issue
    cmd = [
        "gh", "issue", "create",
        "--title", title,
        "--body", body,
        "--label", labels,
        "--milestone", milestone,
        "--repo", REPO
    ]
    
    issue_url = run_gh_command(cmd)
    if not issue_url:
        print(f"Failed to create: {title}")
        return False
    
    # Add to project
    cmd = [
        "gh", "project", "item-add", PROJECT_ID,
        "--owner", "ughvvv",
        "--url", issue_url
    ]
    
    result = run_gh_command(cmd)
    print(f"✓ Created: {title}")
    return True

def main():
    """Create all missing issues from the task breakdown"""
    print("🚀 Creating Missing Issues from Task Breakdown")
    print("=" * 50)
    
    issues_created = 0
    
    # Missing L0 tasks
    missing_l0 = [
        {
            "title": "[L0] Set up Embedding Workers (Ray on EKS)",
            "labels": "L0:Ingestion,Type:Feature,Comp:Embedding,Comp:Infra,Prio:High",
            "milestone": "Phase 2: Core Intelligence",
            "body": """## 🎯 Task Objective
Deploy Ray cluster on EKS for embedding workers. Configure OpenAI text-embedding-3-small or open-source fallback. Implement batch processing and Aurora-Postgres integration.

## 📋 Technical Requirements
- Ray cluster deployment on EKS
- OpenAI API integration with fallback
- Batch processing optimization (N=32)
- Aurora-Postgres connection pooling

## 🎯 Acceptance Criteria
- [ ] Ray cluster on EKS deployment
- [ ] OpenAI embedding API integration
- [ ] Open-source embedding fallback (SBERT)
- [ ] Batch processing implementation
- [ ] Aurora-Postgres integration
- [ ] Prometheus metrics exposure

## 📊 Success Metrics
- Embedding rate: >1000 embeddings/min
- API error rate: <1%
- Batch efficiency: >90%"""
        },
        {
            "title": "[L0] Develop Nightly Graph-Build Job - HDBSCAN Clustering",
            "labels": "L0:Ingestion,Type:Feature,Comp:ML,Prio:Medium",
            "milestone": "Phase 2: Core Intelligence",
            "body": """## 🎯 Task Objective
Implement HDBSCAN clustering on recent data (30 days) from events_vector table. Assign cluster_id to each event with configurable parameters.

## 📋 Technical Requirements
- HDBSCAN library integration
- Parameter tuning (min_cluster_size=30, min_samples=15)
- Cluster assignment and validation
- Performance optimization for large datasets

## 🎯 Acceptance Criteria
- [ ] HDBSCAN clustering implementation
- [ ] Parameter configuration system
- [ ] Cluster assignment to events_vector
- [ ] Performance monitoring and optimization
- [ ] Cluster quality metrics

## 📊 Success Metrics
- Clustering quality: >0.7 silhouette score
- Processing time: <2 hours for 30-day data
- Cluster count: 50-200 meaningful clusters"""
        },
        {
            "title": "[L0] Develop Nightly Graph-Build Job - R-GAT Embedding",
            "labels": "L0:Ingestion,Type:Feature,Comp:ML,Prio:Medium",
            "milestone": "Phase 2: Core Intelligence",
            "body": """## 🎯 Task Objective
Implement R-GAT training (2-layer Graph Attention Network) running Mon/Thu. Construct graph with kNN edges and store vec_rgat embeddings.

## 📋 Technical Requirements
- Graph construction with kNN=30 within clusters
- kINTER=5 nearest across clusters
- 2-layer GAT implementation (256 dims)
- PyTorch/DGL implementation

## 🎯 Acceptance Criteria
- [ ] Graph construction algorithm
- [ ] 2-layer GAT implementation
- [ ] Training pipeline (Mon/Thu schedule)
- [ ] vec_rgat storage in events_vector
- [ ] Training metrics and monitoring

## 📊 Success Metrics
- Training convergence: <3 hours
- Embedding quality: >0.8 downstream task performance
- Graph connectivity: >95% nodes connected"""
        },
        {
            "title": "[L0] Develop Nightly Graph-Build Job - Trend Clusters Management",
            "labels": "L0:Ingestion,Type:Feature,Comp:Database,Prio:Medium",
            "milestone": "Phase 2: Core Intelligence",
            "body": """## 🎯 Task Objective
Define trend_clusters table schema and implement upsert logic for cluster data including axis_mix, centroid_vec, size, and entropy calculations.

## 📋 Technical Requirements
- trend_clusters table design
- Centroid calculation from cluster members
- Entropy computation (1 - size/total_events)
- Axis mix analysis and JSON storage

## 🎯 Acceptance Criteria
- [ ] trend_clusters table schema
- [ ] Centroid vector calculation
- [ ] Entropy computation logic
- [ ] Axis mix analysis
- [ ] Upsert logic implementation
- [ ] S3 export for dashboards

## 📊 Success Metrics
- Cluster update latency: <30 minutes
- Entropy calculation accuracy: >99%
- Dashboard export success: 100%"""
        },
        {
            "title": "[L0] Set up Monitoring & Alerts",
            "labels": "L0:Ingestion,Type:Chore,Comp:Monitoring,Prio:Medium",
            "milestone": "Phase 1: Foundation",
            "body": """## 🎯 Task Objective
Implement Prometheus metrics and alerts for Kafka lag, embedding errors, clustering job durations, and R-GAT training performance.

## 📋 Technical Requirements
- Prometheus metrics exposition
- Grafana dashboard creation
- AlertManager rule configuration
- PagerDuty integration

## 🎯 Acceptance Criteria
- [ ] Kafka lag monitoring
- [ ] Embedding error rate tracking
- [ ] Job duration metrics
- [ ] Alert rules configuration
- [ ] Grafana dashboards

## 📊 Success Metrics
- Alert response time: <5 minutes
- Dashboard load time: <3 seconds
- Monitoring coverage: 100% of components"""
        }
    ]
    
    # Missing L1 tasks
    missing_l1 = [
        {
            "title": "[L1] Define Data Interfaces and Contracts",
            "labels": "L1:Allocation,Type:Documentation,Type:Chore,Prio:Medium",
            "milestone": "Phase 2: Core Intelligence",
            "body": """## 🎯 Task Objective
Document and implement data contracts for L1 interactions: reads trend_clusters (L0), elite_grid (L3); Orchestrator calls SelectClusters; trainers update stats/policies.

## 📋 Technical Requirements
- Data contract documentation
- Interface specifications
- API schema definitions
- Integration test suite

## 🎯 Acceptance Criteria
- [ ] Data contract documentation
- [ ] Interface specifications
- [ ] API schema definitions
- [ ] Integration test suite

## 📊 Success Metrics
- Documentation coverage: 100% of interfaces
- Integration test coverage: >90%
- API schema validation: 100%"""
        },
        {
            "title": "[L1] Set up Monitoring & Alerts",
            "labels": "L1:Allocation,Type:Chore,Comp:Monitoring,Prio:Medium",
            "milestone": "Phase 2: Core Intelligence",
            "body": """## 🎯 Task Objective
Implement Prometheus metrics for UCB scores, budget shares, selection counts, and alerts for lagged rewards or policy update failures.

## 📋 Technical Requirements
- UCB score metrics
- Budget allocation tracking
- Selection count monitoring
- Policy update alerts
- Reward lag detection

## 🎯 Acceptance Criteria
- [ ] UCB score metrics
- [ ] Budget allocation tracking
- [ ] Selection count monitoring
- [ ] Policy update alerts
- [ ] Reward lag detection

## 📊 Success Metrics
- Metric collection: 99.9% uptime
- Alert response: <5min for critical issues
- Dashboard load time: <3s"""
        }
    ]
    
    # Missing L2 tasks
    missing_l2 = [
        {
            "title": "[L2] Define Data Stores & Schemas",
            "labels": "L2:DialoguePod,Type:Chore,Comp:Database,Prio:High",
            "milestone": "Phase 2: Core Intelligence",
            "body": """## 🎯 Task Objective
Set up Postgres tables: pod_transcript, pod_metrics, population, elo_ratings. Implement TTL/archival for pod_transcript with 30-day S3 export.

## 📋 Technical Requirements
- Postgres schema design
- JSONB for flexible transcript storage
- TTL policies and archival automation
- Indexing strategy for performance

## 🎯 Acceptance Criteria
- [ ] pod_transcript table with JSONB
- [ ] pod_metrics table design
- [ ] population table schema
- [ ] elo_ratings table
- [ ] 30-day TTL implementation
- [ ] S3 archival automation

## 📊 Success Metrics
- Query performance: <100ms for common queries
- Storage efficiency: <10GB for 30-day retention
- Archival success: 100%"""
        },
        {
            "title": "[L2] Implement Scaling & Cost Control Mechanisms",
            "labels": "L2:DialoguePod,Type:Feature,Comp:Orchestrator,Prio:Medium",
            "milestone": "Phase 3: Evolution & Learning",
            "body": """## 🎯 Task Objective
Implement configurable pods_per_stage, debate gate (confidence > 0.8), token caps per agent, and autoscaler logic based on cost and entropy thresholds.

## 📋 Technical Requirements
- Configuration-driven scaling
- Cost-based autoscaling
- Entropy-based pod skipping
- Token limit enforcement

## 🎯 Acceptance Criteria
- [ ] Configurable pods_per_stage
- [ ] Debate gate implementation
- [ ] Token caps per agent type
- [ ] Cost-based autoscaler
- [ ] Entropy-based skipping logic
- [ ] Budget monitoring integration

## 📊 Success Metrics
- Cost control: Budget adherence 100%
- Scaling efficiency: >90%
- Performance impact: <5%"""
        },
        {
            "title": "[L2] Define Interfaces with Adjacent Layers",
            "labels": "L2:DialoguePod,Type:Documentation,Type:Chore,Prio:Medium",
            "milestone": "Phase 2: Core Intelligence",
            "body": """## 🎯 Task Objective
Document and implement data contracts: L1 cluster_ids input, L3 population writes, L0 memory integration, L4 reward queue outputs.

## 📋 Technical Requirements
- L1 interface documentation
- L3 data contract specification
- L0 memory integration spec
- L4 reward queue schema
- Integration test coverage

## 🎯 Acceptance Criteria
- [ ] L1 interface documentation
- [ ] L3 data contract specification
- [ ] L0 memory integration spec
- [ ] L4 reward queue schema
- [ ] Integration test coverage

## 📊 Success Metrics
- Documentation coverage: 100% of interfaces
- Integration test coverage: >90%
- API schema validation: 100%"""
        },
        {
            "title": "[L2] Set up Monitoring & Alerts",
            "labels": "L2:DialoguePod,Type:Chore,Comp:Monitoring,Prio:Medium",
            "milestone": "Phase 2: Core Intelligence",
            "body": """## 🎯 Task Objective
Implement Prometheus metrics for pod cost/latency, skip rates, Elo drift, and alerts for high costs or unexpected behavior patterns.

## 📋 Technical Requirements
- Pod cost tracking
- Latency monitoring
- Skip rate metrics
- Elo drift detection
- Cost overrun alerts
- Behavior anomaly detection

## 🎯 Acceptance Criteria
- [ ] Pod cost tracking
- [ ] Latency monitoring
- [ ] Skip rate metrics
- [ ] Elo drift detection
- [ ] Cost overrun alerts
- [ ] Behavior anomaly detection

## 📊 Success Metrics
- Metric collection: 99.9% uptime
- Alert response: <5min for critical issues
- Dashboard load time: <3s"""
        }
    ]
    
    # Missing L3 tasks
    missing_l3 = [
        {
            "title": "[L3] Implement Offspring Enqueue Mechanism",
            "labels": "L3:MetaReview,Type:Feature,Comp:Evolution,Prio:Medium",
            "milestone": "Phase 3: Evolution & Learning",
            "body": """## 🎯 Task Objective
Enqueue final child ideas into L2 BN-queue via Orchestrator. Persist lineage in population table and handle cluster assignment (parent cluster or jump-to logic).

## 📋 Technical Requirements
- BN-queue integration
- Lineage tracking system
- Cluster assignment logic
- Generation management

## 🎯 Acceptance Criteria
- [ ] BN-queue enqueue logic
- [ ] Lineage persistence
- [ ] Cluster assignment algorithm
- [ ] Generation tracking
- [ ] Orchestrator integration

## 📊 Success Metrics
- Enqueue success rate: 100%
- Lineage tracking accuracy: 100%
- Processing latency: <30s"""
        },
        {
            "title": "[L3] Define Data Stores & Schemas",
            "labels": "L3:MetaReview,Type:Chore,Comp:Database,Prio:High",
            "milestone": "Phase 3: Evolution & Learning",
            "body": """## 🎯 Task Objective
Set up Postgres tables: elite_grid, parent_map (optional), generation_metadata. Ensure population table integration and proper indexing.

## 📋 Technical Requirements
- Elite grid schema design
- Parent mapping system
- Generation metadata tracking
- Performance optimization

## 🎯 Acceptance Criteria
- [ ] elite_grid table schema
- [ ] parent_map table design
- [ ] generation_metadata structure
- [ ] Population table integration
- [ ] Index optimization
- [ ] Foreign key constraints

## 📊 Success Metrics
- Query performance: <100ms for grid operations
- Storage efficiency: <1GB for grid data
- Integrity: 100% referential integrity"""
        },
        {
            "title": "[L3] Set up Monitoring & Alerts",
            "labels": "L3:MetaReview,Type:Chore,Comp:Monitoring,Prio:Medium",
            "milestone": "Phase 3: Evolution & Learning",
            "body": """## 🎯 Task Objective
Implement Prometheus metrics for grid fill rate, child generation count, and alerts for grid stagnation or low novelty across generations.

## 📋 Technical Requirements
- Grid fill rate monitoring
- Generation novelty tracking
- Stagnation detection algorithms
- Novelty threshold alerting

## 🎯 Acceptance Criteria
- [ ] Grid fill rate metrics
- [ ] Child generation count tracking
- [ ] Stagnation detection (>3 gens)
- [ ] Low novelty alerts (<0.1)
- [ ] Exploration stagnation warnings

## 📊 Success Metrics
- Metric collection: 99.9% uptime
- Alert response: <5min for critical issues
- Dashboard load time: <3s"""
        }
    ]
    
    # Missing L4 tasks
    missing_l4 = [
        {
            "title": "[L4] Set up rl_reward_queue (SQS)",
            "labels": "L4:RL-FineTuning,Type:Chore,Comp:Infra,Prio:High",
            "milestone": "Phase 3: Evolution & Learning",
            "body": """## 🎯 Task Objective
Configure SQS queue for reward messages with defined schema { axis, cluster_id, idea_id, reward, timestamp } and appropriate visibility timeout for retry handling.

## 📋 Technical Requirements
- SQS queue configuration
- Message schema definition
- Visibility timeout optimization
- Dead letter queue setup

## 🎯 Acceptance Criteria
- [ ] SQS queue deployment
- [ ] Message schema validation
- [ ] 5-minute visibility timeout
- [ ] Dead letter queue configuration
- [ ] Consumer group setup

## 📊 Success Metrics
- Message throughput: >1000 msgs/sec
- Processing latency: <100ms
- Error rate: <0.1%"""
        },
        {
            "title": "[L4] Define Interfaces with Adjacent Layers",
            "labels": "L4:RL-FineTuning,Type:Documentation,Type:Chore,Prio:Medium",
            "milestone": "Phase 3: Evolution & Learning",
            "body": """## 🎯 Task Objective
Document how L2/L3 push rewards, and how L4 trainers update bandit_stats (L1), policy_versions (L1/L2), LoRA weights (L2), and DPO checkpoints (L2).

## 📋 Technical Requirements
- Reward flow documentation
- Trainer update specifications
- Checkpoint management docs
- Integration test coverage

## 🎯 Acceptance Criteria
- [ ] Reward flow documentation
- [ ] Trainer update specifications
- [ ] Checkpoint management docs
- [ ] Integration test coverage

## 📊 Success Metrics
- Documentation coverage: 100% of interfaces
- Integration test coverage: >90%
- API schema validation: 100%"""
        },
        {
            "title": "[L4] Implement Scaling & Cost Controls for Trainers",
            "labels": "L4:RL-FineTuning,Type:Chore,Comp:Infra,Prio:Medium",
            "milestone": "Phase 3: Evolution & Learning",
            "body": """## 🎯 Task Objective
Configure batch processing for trainers, define compute budgets and resource allocation for AZ-LoRA (A100/80GB, 4-6h), GRPO (2×A10G, 2h), and DPO (A100, 8h).

## 📋 Technical Requirements
- GPU resource allocation
- Spot instance bidding
- Batch processing optimization
- Cost monitoring integration

## 🎯 Acceptance Criteria
- [ ] GPU resource allocation
- [ ] Spot instance configuration
- [ ] Batch processing (1k messages)
- [ ] Compute budget limits
- [ ] Cost monitoring integration

## 📊 Success Metrics
- Cost efficiency: >80% spot instance usage
- Resource utilization: >90%
- Budget adherence: 100%"""
        },
        {
            "title": "[L4] Set up Monitoring & Alerts for Trainers",
            "labels": "L4:RL-FineTuning,Type:Chore,Comp:Monitoring,Prio:Medium",
            "milestone": "Phase 3: Evolution & Learning",
            "body": """## 🎯 Task Objective
Implement Prometheus metrics for trainer loss, policy upload time, reward throughput, and alerts for policy update failures or poor training performance.

## 📋 Technical Requirements
- Training metrics exposition
- Loss tracking and alerting
- Upload time monitoring
- Performance threshold alerts

## 🎯 Acceptance Criteria
- [ ] Trainer loss metrics
- [ ] Policy upload time tracking
- [ ] Reward throughput monitoring
- [ ] Policy update failure alerts
- [ ] Training performance thresholds

## 📊 Success Metrics
- Metric collection: 99.9% uptime
- Alert response: <5min for critical issues
- Dashboard load time: <3s"""
        }
    ]
    
    # Missing L5 tasks
    missing_l5 = [
        {
            "title": "[L5] Implement Security - Data Scrubbing",
            "labels": "L5:Observability,Type:Chore,Comp:Security,Prio:Medium",
            "milestone": "Phase 1: Foundation",
            "body": """## 🎯 Task Objective
Ensure ETL Lambda and relevant components strip PII from raw texts (usernames, emails, phone numbers) before processing and storage.

## 📋 Technical Requirements
- PII detection algorithms
- Text sanitization pipelines
- Regex-based filtering
- Compliance validation

## 🎯 Acceptance Criteria
- [ ] PII detection implementation
- [ ] Username/email stripping
- [ ] Phone number removal
- [ ] ETL Lambda integration
- [ ] Compliance validation

## 📊 Success Metrics
- PII detection accuracy: >99%
- Processing latency impact: <10%
- Compliance score: 100%"""
        },
        {
            "title": "[L5] Implement Security - Compliance Filter in VERD-POD",
            "labels": "L5:Observability,Type:Feature,Comp:Security,Prio:Medium",
            "milestone": "Phase 3: Evolution & Learning",
            "body": """## 🎯 Task Objective
Integrate brand-safety/compliance check (profanity, legal terms, regulatory content) into VERD-POD using regex-based filter or third-party library.

## 📋 Technical Requirements
- Brand safety rule engine
- Regulatory term detection
- Third-party library integration
- Compliance scoring system

## 🎯 Acceptance Criteria
- [ ] Brand safety filter
- [ ] Profanity detection
- [ ] Legal term flagging
- [ ] Regulatory compliance check
- [ ] VERD-POD integration

## 📊 Success Metrics
- Filter accuracy: >95%
- Processing latency: <500ms
- Compliance coverage: 100%"""
        },
        {
            "title": "[L5] Create Operational Runbooks",
            "labels": "L5:Observability,Type:Documentation,Comp:Ops,Prio:Medium",
            "milestone": "Phase 4: Production & Optimization",
            "body": """## 🎯 Task Objective
Develop runbooks for key operational procedures: L0 deployment DAG verification, Orchestrator fault handling, Trainer monitoring and validation.

## 📋 Technical Requirements
- Step-by-step procedures
- Troubleshooting guides
- Escalation procedures
- Validation checklists

## 🎯 Acceptance Criteria
- [ ] L0 deployment DAG runbook
- [ ] Orchestrator fault handling guide
- [ ] Trainer monitoring procedures
- [ ] Troubleshooting documentation
- [ ] Escalation procedures

## 📊 Success Metrics
- Runbook coverage: 100% of critical procedures
- Mean time to resolution: <30 minutes
- Escalation accuracy: >95%"""
        }
    ]
    
    # Create all missing issues
    all_missing = missing_l0 + missing_l1 + missing_l2 + missing_l3 + missing_l4 + missing_l5
    
    print(f"\n🔍 Found {len(all_missing)} missing issues to create...")
    
    for issue in all_missing:
        if create_issue_and_add(issue["title"], issue["body"], issue["labels"], issue["milestone"]):
            issues_created += 1
    
    print(f"\n🎉 Successfully created {issues_created} missing issues!")
    print(f"🔗 View your project: https://github.com/users/ughvvv/projects/2")
    print(f"\n📊 Total issues should now be: 54 (existing) + {issues_created} (new) = {54 + issues_created}")

if __name__ == "__main__":
    main()
