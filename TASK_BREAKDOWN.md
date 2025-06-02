# Task Breakdown - GitHub Issues by Layer

This document provides a comprehensive list of GitHub issues organized by the 6-layer system architecture. Each issue includes title, description, labels, priority, and dependencies.

## 📊 Summary

- **Total Issues**: ~85 tasks across 6 layers
- **Estimated Timeline**: 8 months across 4 phases
- **Priority Distribution**: 25 High, 35 Medium, 25 Low
- **Layer Distribution**: L0(15), L1(8), L2(18), L3(10), L4(12), L5(15), General(7)

---

## 🏗️ General Project Tasks

### 1. Project Foundation

**Title**: `[PROJECT] Define Official Project Name and Repository Structure`
**Labels**: `Type:Chore`, `Prio:Critical`, `Comp:Infra`
**Milestone**: Phase 1: Foundation
**Description**: 
Establish the official project name, set up initial GitHub repository structure including main branches, comprehensive README, .gitignore, and contribution guidelines. Define coding standards and development workflow.

**Acceptance Criteria**:
- [ ] Repository structure defined and documented
- [ ] README with project overview and setup instructions
- [ ] Contributing guidelines and code of conduct
- [ ] Branch protection rules configured
- [ ] .gitignore for all relevant technologies

---

**Title**: `[PROJECT] Initial CI/CD Pipeline Setup`
**Labels**: `Type:Chore`, `Prio:High`, `Comp:Infra`
**Milestone**: Phase 1: Foundation
**Description**: 
Implement basic CI/CD pipeline using GitHub Actions for automated builds, linting, testing, and deployment across all layers.

**Acceptance Criteria**:
- [ ] GitHub Actions workflows for build/test
- [ ] Automated linting and code quality checks
- [ ] Docker image builds and registry pushes
- [ ] Deployment automation to dev/test environments

---

**Title**: `[PROJECT] Overall System Architecture Documentation`
**Labels**: `Type:Documentation`, `Prio:High`
**Milestone**: Phase 1: Foundation
**Description**: 
Create and maintain comprehensive documentation for the overall system architecture, including the provided specification, diagrams, and key decision logs.

**Acceptance Criteria**:
- [ ] Complete architecture specification document
- [ ] Mermaid diagrams for data flow and RL loops
- [ ] API documentation structure
- [ ] Decision log template and initial entries

---

## 🔄 L0: Signal Ingestion & Knowledge-Graph Pipeline

### L0.1 Axis Crawlers

**Title**: `[L0] Develop Axis Crawler - Reddit (R)`
**Labels**: `L0:Ingestion`, `Type:Feature`, `Comp:Crawler`, `Prio:High`
**Milestone**: Phase 1: Foundation
**Description**: 
Develop and deploy the Axis Crawler for Reddit (Cultural Pulse) using PRAW + Pushshift APIs. Crawls niche subreddits and writes raw JSON events to Kafka topic `raw_events.R`.

**Technical Approach**:
- Use PRAW for Reddit API access
- Implement Pushshift for historical data
- Deploy as AWS Fargate ECS task with 30s-5min scheduling
- Handle rate limiting and authentication

**Acceptance Criteria**:
- [ ] PRAW integration with Reddit API
- [ ] Pushshift integration for historical data
- [ ] Kafka producer for `raw_events.R` topic
- [ ] Error handling and retry logic
- [ ] Monitoring and alerting integration

---

**Title**: `[L0] Develop Axis Crawler - TikTok (T)`
**Labels**: `L0:Ingestion`, `Type:Feature`, `Comp:Crawler`, `Prio:High`
**Milestone**: Phase 1: Foundation
**Description**: 
Develop and deploy the Axis Crawler for TikTok (Social Media) using unofficial API or Selenium wrappers. Writes to Kafka topic `raw_events.T`.

**Technical Approach**:
- Research and implement TikTok unofficial API
- Fallback to Selenium-based scraping
- Handle anti-bot measures and rate limiting

**Acceptance Criteria**:
- [ ] TikTok trending data extraction
- [ ] Kafka producer for `raw_events.T` topic
- [ ] Robust error handling for API changes
- [ ] Selenium fallback implementation

---

**Title**: `[L0] Develop Axis Crawler - GitHub (G)`
**Labels**: `L0:Ingestion`, `Type:Feature`, `Comp:Crawler`, `Prio:High`
**Milestone**: Phase 1: Foundation
**Description**: 
Develop and deploy the Axis Crawler for GitHub (Tech Dev) using Trending RSS feeds and GitHub REST API v3. Writes to Kafka topic `raw_events.G`.

**Technical Approach**:
- GitHub REST API v3 integration
- RSS feed parsing for trending repositories
- Repository metadata extraction

**Acceptance Criteria**:
- [ ] GitHub REST API v3 integration
- [ ] Trending RSS feed parsing
- [ ] Repository metadata extraction
- [ ] Kafka producer for `raw_events.G` topic

---

**Title**: `[L0] Develop Axis Crawler - arXiv (A)`
**Labels**: `L0:Ingestion`, `Type:Feature`, `Comp:Crawler`, `Prio:High`
**Milestone**: Phase 1: Foundation
**Description**: 
Develop and deploy the Axis Crawler for arXiv (Academic) using RSS feeds and OAI-PMH protocol. Writes to Kafka topic `raw_events.A`.

**Technical Approach**:
- OAI-PMH protocol implementation
- arXiv RSS feed parsing
- Academic paper metadata extraction

**Acceptance Criteria**:
- [ ] OAI-PMH protocol integration
- [ ] arXiv RSS feed parsing
- [ ] Paper metadata extraction and normalization
- [ ] Kafka producer for `raw_events.A` topic

---

**Title**: `[L0] Develop Axis Crawler - Patents (P)`
**Labels**: `L0:Ingestion`, `Type:Feature`, `Comp:Crawler`, `Prio:Medium`
**Milestone**: Phase 1: Foundation
**Description**: 
Develop and deploy the Axis Crawler for Patents using Lens open data or PatentsView API. Writes to Kafka topic `raw_events.P`.

**Technical Approach**:
- Lens.org API integration
- PatentsView API as fallback
- Patent metadata extraction and classification

**Acceptance Criteria**:
- [ ] Lens.org API integration
- [ ] Patent data extraction and normalization
- [ ] Classification and tagging logic
- [ ] Kafka producer for `raw_events.P` topic

---

**Title**: `[L0] Develop Axis Crawler - Crunchbase/CB Insights (C)`
**Labels**: `L0:Ingestion`, `Type:Feature`, `Comp:Crawler`, `Prio:Medium`
**Milestone**: Phase 1: Foundation
**Description**: 
Develop and deploy the Axis Crawler for Crunchbase/CB Insights using daily CSV exports or REST APIs. Writes to Kafka topic `raw_events.C`.

**Technical Approach**:
- Crunchbase API integration
- CSV file processing for bulk data
- Company and funding data extraction

**Acceptance Criteria**:
- [ ] Crunchbase API integration
- [ ] CSV processing pipeline
- [ ] Company and funding data normalization
- [ ] Kafka producer for `raw_events.C` topic

---

**Title**: `[L0] Develop Axis Crawler - Marketplace Economics (M)`
**Labels**: `L0:Ingestion`, `Type:Feature`, `Comp:Crawler`, `Prio:Medium`
**Milestone**: Phase 1: Foundation
**Description**: 
Develop and deploy the Axis Crawler for SEC EDGAR (8-K/10-K filings) scrapers. Writes to Kafka topic `raw_events.M`.

**Technical Approach**:
- SEC EDGAR API integration
- 8-K and 10-K filing parsing
- Financial data extraction and normalization

**Acceptance Criteria**:
- [ ] SEC EDGAR API integration
- [ ] 8-K and 10-K filing parsing
- [ ] Financial data extraction
- [ ] Kafka producer for `raw_events.M` topic

---

**Title**: `[L0] Develop Axis Crawler - Spiritual/Wellness (S)`
**Labels**: `L0:Ingestion`, `Type:Feature`, `Comp:Crawler`, `Prio:Low`
**Milestone**: Phase 1: Foundation
**Description**: 
Develop and deploy the Axis Crawler for InsightTimer forum and r/Meditation. Writes to Kafka topic `raw_events.S`.

**Technical Approach**:
- InsightTimer forum scraping
- Reddit r/Meditation integration via PRAW
- Wellness content classification

**Acceptance Criteria**:
- [ ] InsightTimer forum integration
- [ ] r/Meditation data extraction
- [ ] Content classification and tagging
- [ ] Kafka producer for `raw_events.S` topic

---

**Title**: `[L0] Develop Axis Crawler - Creative & Design (D)`
**Labels**: `L0:Ingestion`, `Type:Feature`, `Comp:Crawler`, `Prio:Low`
**Milestone**: Phase 1: Foundation
**Description**: 
Develop and deploy the Axis Crawler for Dribbble, Behance RSS, and Midjourney public feeds. Writes to Kafka topic `raw_events.D`.

**Technical Approach**:
- Dribbble API integration
- Behance RSS feed parsing
- Midjourney public feed scraping

**Acceptance Criteria**:
- [ ] Dribbble API integration
- [ ] Behance RSS feed parsing
- [ ] Midjourney feed extraction
- [ ] Kafka producer for `raw_events.D` topic

---

### L0.2 Infrastructure & Processing

**Title**: `[L0] Implement Kafka Setup for Raw Events`
**Labels**: `L0:Ingestion`, `Type:Chore`, `Comp:Infra`, `Prio:Critical`
**Milestone**: Phase 1: Foundation
**Description**: 
Configure Kafka topics `raw_events.<axis>` for all 9 axes with appropriate partitioning, replication, and retention policies.

**Technical Approach**:
- AWS MSK or self-managed Kafka cluster
- Topic configuration for each axis
- Monitoring and alerting setup

**Acceptance Criteria**:
- [ ] Kafka cluster deployment
- [ ] 9 raw_events topics configured
- [ ] Partitioning and replication strategy
- [ ] Monitoring and alerting integration

---

**Title**: `[L0] Implement ETL Parser`
**Labels**: `L0:Ingestion`, `Type:Feature`, `Comp:ETL`, `Prio:High`
**Milestone**: Phase 1: Foundation
**Description**: 
Develop ETL Parser as Kafka Consumer for deduplication, normalization, and field extraction into ParsedEvent schema. Publishes Avro to `parsed_events.<axis>`.

**Technical Approach**:
- Kafka Consumer Group implementation
- Redis Bloom filter for deduplication
- Language detection and normalization
- Avro schema definition and serialization

**Acceptance Criteria**:
- [ ] Kafka consumer group setup
- [ ] Redis deduplication logic
- [ ] ParsedEvent schema definition
- [ ] Avro serialization implementation
- [ ] Language detection and filtering

---

**Title**: `[L0] Set up Embedding Workers (Ray on EKS)`
**Labels**: `L0:Ingestion`, `Type:Feature`, `Comp:Embedding`, `Comp:Infra`, `Prio:High`
**Milestone**: Phase 2: Core Intelligence
**Description**: 
Deploy Ray cluster on EKS for embedding workers. Configure OpenAI text-embedding-3-small or open-source fallback. Implement batch processing and Aurora-Postgres integration.

**Technical Approach**:
- Ray cluster deployment on EKS
- OpenAI API integration with fallback
- Batch processing optimization (N=32)
- Aurora-Postgres connection pooling

**Acceptance Criteria**:
- [ ] Ray cluster on EKS deployment
- [ ] OpenAI embedding API integration
- [ ] Open-source embedding fallback (SBERT)
- [ ] Batch processing implementation
- [ ] Aurora-Postgres integration
- [ ] Prometheus metrics exposure

---

**Title**: `[L0] Configure Aurora-Postgres + pgvector`
**Labels**: `L0:Ingestion`, `Type:Chore`, `Comp:Database`, `Prio:High`
**Milestone**: Phase 1: Foundation
**Description**: 
Set up Aurora-Postgres instance with pgvector extension. Define events_vector table schema, HNSW indexes, and implement retention/archival policy with nightly S3 exports.

**Technical Approach**:
- Aurora-Postgres cluster setup
- pgvector extension installation
- HNSW index optimization
- S3 archival automation

**Acceptance Criteria**:
- [ ] Aurora-Postgres cluster deployment
- [ ] pgvector extension configured
- [ ] events_vector table schema
- [ ] HNSW indexes for vector similarity
- [ ] 90-day retention policy
- [ ] Nightly S3 archival process

---

### L0.3 Graph Building & Clustering

**Title**: `[L0] Develop Nightly Graph-Build Job - HDBSCAN Clustering`
**Labels**: `L0:Ingestion`, `Type:Feature`, `Comp:ML`, `Prio:Medium`
**Milestone**: Phase 2: Core Intelligence
**Description**: 
Implement HDBSCAN clustering on recent data (30 days) from events_vector table. Assign cluster_id to each event with configurable parameters.

**Technical Approach**:
- HDBSCAN library integration
- Parameter tuning (min_cluster_size=30, min_samples=15)
- Cluster assignment and validation
- Performance optimization for large datasets

**Acceptance Criteria**:
- [ ] HDBSCAN clustering implementation
- [ ] Parameter configuration system
- [ ] Cluster assignment to events_vector
- [ ] Performance monitoring and optimization
- [ ] Cluster quality metrics

---

**Title**: `[L0] Develop Nightly Graph-Build Job - R-GAT Embedding`
**Labels**: `L0:Ingestion`, `Type:Feature`, `Comp:ML`, `Prio:Medium`
**Milestone**: Phase 2: Core Intelligence
**Description**: 
Implement R-GAT training (2-layer Graph Attention Network) running Mon/Thu. Construct graph with kNN edges and store vec_rgat embeddings.

**Technical Approach**:
- Graph construction with kNN=30 within clusters
- kINTER=5 nearest across clusters
- 2-layer GAT implementation (256 dims)
- PyTorch/DGL implementation

**Acceptance Criteria**:
- [ ] Graph construction algorithm
- [ ] 2-layer GAT implementation
- [ ] Training pipeline (Mon/Thu schedule)
- [ ] vec_rgat storage in events_vector
- [ ] Training metrics and monitoring

---

**Title**: `[L0] Develop Nightly Graph-Build Job - Trend Clusters Management`
**Labels**: `L0:Ingestion`, `Type:Feature`, `Comp:Database`, `Prio:Medium`
**Milestone**: Phase 2: Core Intelligence
**Description**: 
Define trend_clusters table schema and implement upsert logic for cluster data including axis_mix, centroid_vec, size, and entropy calculations.

**Technical Approach**:
- trend_clusters table design
- Centroid calculation from cluster members
- Entropy computation (1 - size/total_events)
- Axis mix analysis and JSON storage

**Acceptance Criteria**:
- [ ] trend_clusters table schema
- [ ] Centroid vector calculation
- [ ] Entropy computation logic
- [ ] Axis mix analysis
- [ ] Upsert logic implementation
- [ ] S3 export for dashboards

---

**Title**: `[L0] Set up Monitoring & Alerts`
**Labels**: `L0:Ingestion`, `Type:Chore`, `Comp:Monitoring`, `Prio:Medium`
**Milestone**: Phase 1: Foundation
**Description**: 
Implement Prometheus metrics and alerts for Kafka lag, embedding errors, clustering job durations, and R-GAT training performance.

**Technical Approach**:
- Prometheus metrics exposition
- Grafana dashboard creation
- AlertManager rule configuration
- PagerDuty integration

**Acceptance Criteria**:
- [ ] Kafka lag monitoring
- [ ] Embedding error rate tracking
- [ ] Job duration metrics
- [ ] Alert rules configuration
- [ ] Grafana dashboards

---

## ⚖️ L1: Macro-Allocation Layer

**Title**: `[L1] Implement Sliding-UCB Bandit (Axis-Level)`
**Labels**: `L1:Allocation`, `Type:Feature`, `Comp:ML`, `Prio:High`
**Milestone**: Phase 2: Core Intelligence
**Description**: 
Develop Sliding-UCB Bandit for crawl budget allocation across 9 axes. Define bandit_stats table, implement hourly algorithm with decay factor γ=0.9, and SQS reward consumption.

**Technical Approach**:
- UCB algorithm with sliding window
- Decay factor implementation (γ=0.9)
- SQS reward queue consumption
- Softmax budget allocation

**Acceptance Criteria**:
- [ ] bandit_stats table schema
- [ ] UCB algorithm implementation
- [ ] Sliding window with decay
- [ ] SQS reward consumption
- [ ] Hourly cron job setup
- [ ] Budget allocation to crawlers

---

**Title**: `[L1] Implement GRPO Cluster-Selector (Cluster-Level)`
**Labels**: `L1:Allocation`, `Type:Feature`, `Comp:ML`, `Prio:High`
**Milestone**: Phase 2: Core Intelligence
**Description**: 
Develop GRPO Cluster-Selector for dynamic cluster selection. Read trend_clusters, elite_grid, policy_versions. Implement selection algorithm with novelty weighting and expose gRPC endpoint.

**Technical Approach**:
- Policy gradient implementation
- Novelty scoring with entropy weighting
- ε-greedy exploration with decay
- gRPC service implementation

**Acceptance Criteria**:
- [ ] GRPO selection algorithm
- [ ] Policy weight management
- [ ] Novelty and density calculations
- [ ] gRPC SelectClusters endpoint
- [ ] ε and β decay mechanisms

---

**Title**: `[L1] Define Data Interfaces and Contracts`
**Labels**: `L1:Allocation`, `Type:Documentation`, `Type:Chore`, `Prio:Medium`
**Milestone**: Phase 2: Core Intelligence
**Description**: 
Document and implement data contracts for L1 interactions: reads trend_clusters (L0), elite_grid (L3); Orchestrator calls SelectClusters; trainers update stats/policies.

**Acceptance Criteria**:
- [ ] Data contract documentation
- [ ] Interface specifications
- [ ] API schema definitions
- [ ] Integration test suite

---

**Title**: `[L1] Set up Monitoring & Alerts`
**Labels**: `L1:Allocation`, `Type:Chore`, `Comp:Monitoring`, `Prio:Medium`
**Milestone**: Phase 2: Core Intelligence
**Description**: 
Implement Prometheus metrics for UCB scores, budget shares, selection counts, and alerts for lagged rewards or policy update failures.

**Acceptance Criteria**:
- [ ] UCB score metrics
- [ ] Budget allocation tracking
- [ ] Selection count monitoring
- [ ] Policy update alerts
- [ ] Reward lag detection

---

## 🤖 L2: Dialogue-Pod Runtime

### L2.1 Core Orchestration

**Title**: `[L2] Develop Orchestrator Service (FastAPI + gRPC)`
**Labels**: `L2:DialoguePod`, `Type:Feature`, `Comp:Orchestrator`, `Prio:High`
**Milestone**: Phase 2: Core Intelligence
**Description**: 
Implement Orchestrator with task queue management, pod chain spawning logic, LLM/LoRA checkpoint loading, trace_id propagation, and config-driven behavior.

**Technical Approach**:
- FastAPI for REST endpoints
- gRPC for internal communication
- Task queue with Redis/SQS
- Dynamic checkpoint loading

**Acceptance Criteria**:
- [ ] FastAPI service implementation
- [ ] gRPC server setup
- [ ] Task queue management
- [ ] Pod chain orchestration
- [ ] Checkpoint loading system
- [ ] Trace ID propagation
- [ ] Configuration management

---

**Title**: `[L2] Define Data Stores & Schemas`
**Labels**: `L2:DialoguePod`, `Type:Chore`, `Comp:Database`, `Prio:High`
**Milestone**: Phase 2: Core Intelligence
**Description**: 
Set up Postgres tables: pod_transcript, pod_metrics, population, elo_ratings. Implement TTL/archival for pod_transcript with 30-day S3 export.

**Technical Approach**:
- Postgres schema design
- JSONB for flexible transcript storage
- TTL policies and archival automation
- Indexing strategy for performance

**Acceptance Criteria**:
- [ ] pod_transcript table with JSONB
- [ ] pod_metrics table design
- [ ] population table schema
- [ ] elo_ratings table
- [ ] 30-day TTL implementation
- [ ] S3 archival automation

---

### L2.2 Agent Implementation

**Title**: `[L2] Develop Creator Agent (BN-POD)`
**Labels**: `L2:DialoguePod`, `Type:Feature`, `Comp:Agent-Creator`, `Prio:High`
**Milestone**: Phase 2: Core Intelligence
**Description**: 
Implement BN-POD with GPT-4o-mini at T=0.9/1.1 for diversity. Include memory retrieval, LLM call logic, transcript/metrics writing, and RF-POD triggering.

**Technical Approach**:
- OpenAI API integration
- Temperature variation for diversity
- Memory context retrieval
- Transcript logging system

**Acceptance Criteria**:
- [ ] GPT-4o-mini integration
- [ ] Temperature variation (0.9/1.1)
- [ ] Memory context retrieval (2k tokens)
- [ ] Seed idea generation (2 per call)
- [ ] Transcript and metrics logging
- [ ] RF-POD triggering logic

---

**Title**: `[L2] Develop Critic Agent (RF-POD)`
**Labels**: `L2:DialoguePod`, `Type:Feature`, `Comp:Agent-Critic`, `Prio:High`
**Milestone**: Phase 2: Core Intelligence
**Description**: 
Implement RF-POD with Phi-3-mini LoRA at T=0.7. Include memory context, tool calls, two-turn critique, TSvc invocation for uncertainty, and reflection scoring.

**Technical Approach**:
- Phi-3-mini LoRA integration
- Two-turn critique system
- Tool call implementation
- Uncertainty detection and TSvc calls

**Acceptance Criteria**:
- [ ] Phi-3-mini LoRA integration
- [ ] Memory context integration
- [ ] Tool call system (vector_search)
- [ ] Two-turn critique implementation
- [ ] TSvc invocation logic
- [ ] Reflection score calculation
- [ ] Transcript and metrics logging

---

**Title**: `[L2] Develop Judge Ensemble (DB-POD)`
**Labels**: `L2:DialoguePod`, `Type:Feature`, `Comp:Agent-Judge`, `Prio:High`
**Milestone**: Phase 2: Core Intelligence
**Description**: 
Implement DB-POD with 3-judge ensemble: Cohere Command-R+, DeepSeek-R2-32B, and metric-based judge. Include CoT reasoning, majority voting, Elo updates, and confidence-based skipping.

**Technical Approach**:
- Multi-model integration
- Chain-of-thought prompting
- Majority voting system
- Elo rating calculations

**Acceptance Criteria**:
- [ ] Cohere Command-R+ integration
- [ ] DeepSeek-R2-32B integration
- [ ] Metric-based judge implementation
- [ ] CoT reasoning capture
- [ ] Majority voting logic
- [ ] Elo rating updates
- [ ] Confidence-based skipping (>0.8)
- [ ] Judge CoT logging

---

**Title**: `[L2] Develop Financial & Compliance Verdict (VERD-POD)`
**Labels**: `L2:DialoguePod`, `Type:Feature`, `Comp:Agent-Aux`, `Prio:Medium`
**Milestone**: Phase 3: Evolution & Learning
**Description**: 
Implement VERD-POD with Finance-Sim (Monte Carlo 1k runs) and Compliance Filter. Include NPV/IRR/Payback simulation, brand safety checks, and reward signaling.

**Technical Approach**:
- Monte Carlo simulation (1k runs)
- Industry priors database
- Compliance filtering system
- Reward signal generation

**Acceptance Criteria**:
- [ ] Monte Carlo simulation engine
- [ ] Industry priors integration
- [ ] NPV/IRR/Payback calculations
- [ ] Compliance filter implementation
- [ ] Brand safety checks
- [ ] Reward signal generation
- [ ] Fatal flaw detection logic

---

**Title**: `[L2] Develop Selective Tree-Search Service (TSvc)`
**Labels**: `L2:DialoguePod`, `Type:Feature`, `Comp:Agent-Aux`, `Prio:Medium`
**Milestone**: Phase 3: Evolution & Learning
**Description**: 
Implement TSvc as gRPC micro-service for deep search when agents are uncertain. Include tree initialization, selective expansion, MCTS/PGTS navigation, and cost capping.

**Technical Approach**:
- gRPC service implementation
- Tree search algorithms (MCTS/PGTS)
- Perplexity-based expansion
- Cost and depth limiting

**Acceptance Criteria**:
- [ ] gRPC ExploreTree service
- [ ] Tree initialization logic
- [ ] Selective expansion (perplexity > τ)
- [ ] MCTS/PGTS implementation
- [ ] Node scoring and merging
- [ ] Cost cap enforcement (2k tokens, 3 levels)

---

### L2.3 Integration & Optimization

**Title**: `[L2] Implement Scaling & Cost Control Mechanisms`
**Labels**: `L2:DialoguePod`, `Type:Feature`, `Comp:Orchestrator`, `Prio:Medium`
**Milestone**: Phase 3: Evolution & Learning
**Description**: 
Implement configurable pods_per_stage, debate gate (confidence > 0.8), token caps per agent, and autoscaler logic based on cost and entropy thresholds.

**Technical Approach**:
- Configuration-driven scaling
- Cost-based autoscaling
- Entropy-based pod skipping
- Token limit enforcement

**Acceptance Criteria**:
- [ ] Configurable pods_per_stage
- [ ] Debate gate implementation
- [ ] Token caps per agent type
- [ ] Cost-based autoscaler
- [ ] Entropy-based skipping logic
- [ ] Budget monitoring integration

---

**Title**: `[L2] Define Interfaces with Adjacent Layers`
**Labels**: `L2:DialoguePod`, `Type:Documentation`, `Type:Chore`, `Prio:Medium`
**Milestone**: Phase 2: Core Intelligence
**Description**: 
Document and implement data contracts: L1 cluster_ids input, L3 population writes, L0 memory integration, L4 reward queue outputs.

**Acceptance Criteria**:
- [ ] L1 interface documentation
- [ ] L3 data contract specification
- [ ] L0 memory integration spec
- [ ] L4 reward queue schema
- [ ] Integration test coverage

---

**Title**: `[L2] Set up Monitoring & Alerts`
**Labels**: `L2:DialoguePod`, `Type:Chore`, `Comp:Monitoring`, `Prio:Medium`
**Milestone**: Phase 2: Core Intelligence
**Description**: 
Implement Prometheus metrics for pod cost/latency, skip rates, Elo drift, and alerts for high costs or unexpected behavior patterns.

**Acceptance Criteria**:
- [ ] Pod cost tracking
- [ ] Latency monitoring
- [ ] Skip rate metrics
- [ ] Elo drift detection
- [ ] Cost overrun alerts
- [ ] Behavior anomaly detection

---

## 🧬 L3: Meta-Review & Evolution Loop

**Title**: `[L3] Develop Meta-Review Controller`
**Labels**: `L3:MetaReview`, `Type:Feature`, `Comp:Evolution`, `Prio:High`
**Milestone**: Phase 3: Evolution & Learning
**Description**: 
Implement controller to run after L2 pods complete. Populate/refresh elite_grid (10x10 MAP-Elites), compute selection probabilities, and rank top M elite ideas per cell.

**Technical Approach**:
- MAP-Elites grid implementation
- Novelty × feasibility projection
- Selection probability computation
- Elite ranking system

**Acceptance Criteria**:
- [ ] Meta-Review trigger system
- [ ] elite_grid table management
- [ ] 10x10 grid cell projection
- [ ] Composite scoring (elo × (tam+1))
- [ ] Selection probability calculation
- [ ] Elite ranking per cell

---

**Title**: `[L3] Develop Genetic Crossover Module`
**Labels**: `L3:MetaReview`, `Type:Feature`, `Comp:Evolution`, `Comp:ML`, `Prio:Medium`
**Milestone**: Phase 3: Evolution & Learning
**Description**: 
Implement genetic crossover using Creator LLM with ε-greedy parent selection from elite_grid. Include diversity filter (cosSim ∈ [0.3, 0.85]) and child draft generation.

**Technical Approach**:
- ε-greedy parent selection
- Cosine similarity diversity filtering
- LLM-based crossover prompting
- Child draft generation

**Acceptance Criteria**:
- [ ] ε-greedy selection algorithm
- [ ] Diversity filter implementation
- [ ] Crossover prompt engineering
- [ ] Child draft generation
- [ ] Parent lineage tracking
- [ ] Population table integration

---

**Title**: `[L3] Develop AZ Mutation (Prompt-Mutator)`
**Labels**: `L3:MetaReview`, `Type:Feature`, `Comp:Evolution`, `Comp:ML`, `Prio:Medium`
**Milestone**: Phase 3: Evolution & Learning
**Description**: 
Implement AZ Mutation using Phi-3-mini LoRA to apply targeted edits based on feedback rules. Parse diffs and apply mutations to generate child_final_text.

**Technical Approach**:
- Phi-3-mini LoRA integration
- Feedback-guided mutation prompts
- Diff parsing and application
- Text mutation algorithms

**Acceptance Criteria**:
- [ ] Phi-3-mini LoRA integration
- [ ] Feedback rule system
- [ ] Mutation prompt templates
- [ ] Diff parsing logic
- [ ] Text application system
- [ ] Final child generation

---

**Title**: `[L3] Implement Offspring Enqueue Mechanism`
**Labels**: `L3:MetaReview`, `Type:Feature`, `Comp:Evolution`, `Prio:Medium`
**Milestone**: Phase 3: Evolution & Learning
**Description**: 
Enqueue final child ideas into L2 BN-queue via Orchestrator. Persist lineage in population table and handle cluster assignment (parent cluster or jump-to logic).

**Technical Approach**:
- BN-queue integration
- Lineage tracking system
- Cluster assignment logic
- Generation management

**Acceptance Criteria**:
- [ ] BN-queue enqueue logic
- [ ] Lineage persistence
- [ ] Cluster assignment algorithm
- [ ] Generation tracking
- [ ] Orchestrator integration

---

**Title**: `[L3] Define Data Stores & Schemas`
**Labels**: `L3:MetaReview`, `Type:Chore`, `Comp:Database`, `Prio:High`
**Milestone**: Phase 3: Evolution & Learning
**Description**: 
Set up Postgres tables: elite_grid, parent_map (optional), generation_metadata. Ensure population table integration and proper indexing.

**Technical Approach**:
- Elite grid schema design
- Parent mapping system
- Generation metadata tracking
- Performance optimization

**Acceptance Criteria**:
- [ ] elite_grid table schema
- [ ] parent_map table design
- [ ] generation_metadata structure
- [ ] Population table integration
- [ ] Index optimization
- [ ] Foreign key constraints

---

**Title**: `[L3] Set up Monitoring & Alerts`
**Labels**: `L3:MetaReview`, `Type:Chore`, `Comp:Monitoring`, `Prio:Medium`
**Milestone**: Phase 3: Evolution & Learning
**Description**: 
Implement Prometheus metrics for grid fill rate, child generation count, and alerts for grid stagnation or low novelty across generations.

**Technical Approach**:
- Grid fill rate monitoring
- Generation novelty tracking
- Stagnation detection algorithms
- Novelty threshold alerting

**Acceptance Criteria**:
- [ ] Grid fill rate metrics
- [ ] Child generation count tracking
- [ ] Stagnation detection (>3 gens)
- [ ] Low novelty alerts (<0.1)
- [ ] Exploration stagnation warnings

---

## 🎓 L4: Reinforcement & Fine-Tuning

**Title**: `[L4] Set up rl_reward_queue (SQS)`
**Labels**: `L4:RL-FineTuning`, `Type:Chore`, `Comp:Infra`, `Prio:High`
**Milestone**: Phase 3: Evolution & Learning
**Description**: 
Configure SQS queue for reward messages with defined schema { axis, cluster_id, idea_id, reward, timestamp } and appropriate visibility timeout for retry handling.

**Technical Approach**:
- SQS queue configuration
- Message schema definition
- Visibility timeout optimization
- Dead letter queue setup

**Acceptance Criteria**:
- [ ] SQS queue deployment
- [ ] Message schema validation
- [ ] 5-minute visibility timeout
- [ ] Dead letter queue configuration
- [ ] Consumer group setup

---

**Title**: `[L4] Develop Bandit-Trainer (Axis-Level)`
**Labels**: `L4:RL-FineTuning`, `Type:Feature`, `Comp:Trainer`, `Comp:ML`, `Prio:High`
**Milestone**: Phase 3: Evolution & Learning
**Description**: 
Implement Bandit-Trainer to continuously poll SQS at 10 msgs/sec, apply sliding UCB updates to bandit_stats, and influence crawler budget allocation.

**Technical Approach**:
- SQS polling implementation
- Sliding UCB update algorithm
- Database transaction handling
- Error handling and retries

**Acceptance Criteria**:
- [ ] SQS polling at 10 msgs/sec
- [ ] Sliding UCB implementation
- [ ] bandit_stats updates
- [ ] Error handling and retries
- [ ] Metrics exposition

---

**Title**: `[L4] Develop GRPO-Trainer (Cluster-Level)`
**Labels**: `L4:RL-FineTuning`, `Type:Feature`, `Comp:Trainer`, `Comp:ML`, `Prio:High`
**Milestone**: Phase 3: Evolution & Learning
**Description**: 
Implement GRPO-Trainer with nightly cron (00:15 UTC) to aggregate 24h SQS messages, run policy gradient step, and save new checkpoint to policy_versions.

**Technical Approach**:
- Nightly cron job setup
- Policy gradient/PPO implementation
- PyTorch Lightning trainer
- S3 checkpoint management

**Acceptance Criteria**:
- [ ] Nightly cron scheduling
- [ ] 24h message aggregation
- [ ] Policy gradient implementation
- [ ] PyTorch Lightning integration
- [ ] S3 checkpoint storage
- [ ] policy_versions updates

---

**Title**: `[L4] Develop AZ-LoRA Trainer (Mutation Agent)`
**Labels**: `L4:RL-FineTuning`, `Type:Feature`, `Comp:Trainer`, `Comp:ML`, `Prio:Medium`
**Milestone**: Phase 3: Evolution & Learning
**Description**: 
Implement AZ-LoRA Trainer with nightly cron (02:00 UTC) to fine-tune Phi-3-mini LoRA on parent-child preference pairs labeled by Elo outcomes.

**Technical Approach**:
- Parent-child pair collection
- Preference dataset creation
- LoRA fine-tuning pipeline
- Binary classification objective

**Acceptance Criteria**:
- [ ] Parent-child pair harvesting
- [ ] Preference dataset creation
- [ ] Phi-3-mini LoRA fine-tuning
- [ ] Binary classification training
- [ ] S3 LoRA weight storage
- [ ] policy_versions integration

---

**Title**: `[L4] Develop DPO Fine-Tune Process (Creator & Critic Models)`
**Labels**: `L4:RL-FineTuning`, `Type:Feature`, `Comp:Trainer`, `Comp:ML`, `Prio:Medium`
**Milestone**: Phase 3: Evolution & Learning
**Description**: 
Implement DPO Fine-Tune process with weekly cron (Sunday 04:00 UTC) to harvest dialogues, create preference dataset, run DPO algorithm, and update model checkpoints.

**Technical Approach**:
- Weekly dialogue harvesting
- Preference dataset construction
- DPO algorithm implementation
- Model checkpoint management

**Acceptance Criteria**:
- [ ] Weekly dialogue harvesting
- [ ] Success/failure transcript pairing
- [ ] Preference dataset creation
- [ ] DPO algorithm implementation
- [ ] Creator/Critic checkpoint updates
- [ ] S3 checkpoint storage

---

**Title**: `[L4] Define Interfaces with Adjacent Layers`
**Labels**: `L4:RL-FineTuning`, `Type:Documentation`, `Type:Chore`, `Prio:Medium`
**Milestone**: Phase 3: Evolution & Learning
**Description**: 
Document how L2/L3 push rewards, and how L4 trainers update bandit_stats (L1), policy_versions (L1/L2), LoRA weights (L2), and DPO checkpoints (L2).

**Acceptance Criteria**:
- [ ] Reward flow documentation
- [ ] Trainer update specifications
- [ ] Checkpoint management docs
- [ ] Integration test coverage

---

**Title**: `[L4] Implement Scaling & Cost Controls for Trainers`
**Labels**: `L4:RL-FineTuning`, `Type:Chore`, `Comp:Infra`, `Prio:Medium`
**Milestone**: Phase 3: Evolution & Learning
**Description**: 
Configure batch processing for trainers, define compute budgets and resource allocation for AZ-LoRA (A100/80GB, 4-6h), GRPO (2×A10G, 2h), and DPO (A100, 8h).

**Technical Approach**:
- GPU resource allocation
- Spot instance bidding
- Batch processing optimization
- Cost monitoring integration

**Acceptance Criteria**:
- [ ] GPU resource allocation
- [ ] Spot instance configuration
- [ ] Batch processing (1k messages)
- [ ] Compute budget limits
- [ ] Cost monitoring integration

---

**Title**: `[L4] Set up Monitoring & Alerts for Trainers`
**Labels**: `L4:RL-FineTuning`, `Type:Chore`, `Comp:Monitoring`, `Prio:Medium`
**Milestone**: Phase 3: Evolution & Learning
**Description**: 
Implement Prometheus metrics for trainer loss, policy upload time, reward throughput, and alerts for policy update failures or poor training performance.

**Technical Approach**:
- Training metrics exposition
- Loss tracking and alerting
- Upload time monitoring
- Performance threshold alerts

**Acceptance Criteria**:
- [ ] Trainer loss metrics
- [ ] Policy upload time tracking
- [ ] Reward throughput monitoring
- [ ] Policy update failure alerts
- [ ] Training performance thresholds

---

## 🔍 L5: Observability, Security & Governance

**Title**: `[L5] Set up Centralized Monitoring & Logging (Prometheus + Grafana)`
**Labels**: `L5:Observability`, `Type:Chore`, `Comp:Monitoring`, `Prio:High`
**Milestone**: Phase 3: Evolution & Learning
**Description**: 
Configure Prometheus to scrape metrics from all layers. Set up Grafana dashboards for key metrics: token spend, cluster entropy, Elo drift, autoscaler actions.

**Technical Approach**:
- Prometheus server deployment
- Multi-layer metrics scraping
- Grafana dashboard creation
- Alert rule configuration

**Acceptance Criteria**:
- [ ] Prometheus server setup
- [ ] All-layer metrics scraping
- [ ] "Daily Token Spend by Model" dashboard
- [ ] "Cluster Entropy Distribution" dashboard
- [ ] "Elo Drift Over Time" dashboard
- [ ] "Autoscaler Actions" dashboard

---

**Title**: `[L5] Implement Cost Guard & Autoscaler Rules`
**Labels**: `L5:Observability`, `Type:Feature`, `Comp:Autoscaler`, `Prio:Medium`
**Milestone**: Phase 3: Evolution & Learning
**Description**: 
Develop cost guard rules (daily LLM spend >$200, token/idea >$0.10) and autoscaler logic (reduce pods_per_stage, stop BN-PODs on low entropy). Integrate with AlertManager.

**Technical Approach**:
- Cost threshold monitoring
- Autoscaler rule engine
- AlertManager integration
- Configuration patching automation

**Acceptance Criteria**:
- [ ] Daily spend monitoring ($200 limit)
- [ ] Per-idea cost tracking ($0.10 limit)
- [ ] Entropy-based pod stopping (<0.02)
- [ ] pods_per_stage reduction (20%)
- [ ] PagerDuty alert integration
- [ ] Orchestrator config patching

---

**Title**: `[L5] Implement Security - Secrets Management`
**Labels**: `L5:Observability`, `Type:Chore`, `Comp:Security`, `Prio:High`
**Milestone**: Phase 1: Foundation
**Description**: 
Ensure all API keys (OpenAI, Anthropic, Cohere) and sensitive credentials are stored and accessed via AWS Secrets Manager. No plaintext secrets in configurations.

**Technical Approach**:
- AWS Secrets Manager integration
- Secret rotation policies
- Application secret retrieval
- Configuration sanitization

**Acceptance Criteria**:
- [ ] AWS Secrets Manager setup
- [ ] All API keys migrated
- [ ] Secret rotation policies
- [ ] Application integration
- [ ] Configuration audit (no plaintext)

---

**Title**: `[L5] Implement Security - IAM Roles & Policies`
**Labels**: `L5:Observability`, `Type:Chore`, `Comp:Security`, `Prio:High`
**Milestone**: Phase 1: Foundation
**Description**: 
Define and apply least-privilege IAM roles and policies for all components: Crawlers (kafka:Consume, s3:PutObject), Ray Jobs (dynamodb:GetItem, s3:GetObject), etc.

**Technical Approach**:
- Least-privilege principle
- Component-specific roles
- Policy validation and testing
- Regular access reviews

**Acceptance Criteria**:
- [ ] Crawler IAM roles (Kafka, S3)
- [ ] Ray Job roles (DynamoDB, S3)
- [ ] Lambda execution roles
- [ ] EKS service account roles
- [ ] Policy validation testing

---

**Title**: `[L5] Implement Security - Data Scrubbing`
**Labels**: `L5:Observability`, `Type:Chore`, `Comp:Security`, `Prio:Medium`
**Milestone**: Phase 1: Foundation
**Description**: 
Ensure ETL Lambda and relevant components strip PII from raw texts (usernames, emails, phone numbers) before processing and storage.

**Technical Approach**:
- PII detection algorithms
- Text sanitization pipelines
- Regex-based filtering
- Compliance validation

**Acceptance Criteria**:
- [ ] PII detection implementation
- [ ] Username/email stripping
- [ ] Phone number removal
- [ ] ETL Lambda integration
- [ ] Compliance validation

---

**Title**: `[L5] Implement Security - Compliance Filter in VERD-POD`
**Labels**: `L5:Observability`, `Type:Feature`, `Comp:Security`, `Prio:Medium`
**Milestone**: Phase 3: Evolution & Learning
**Description**: 
Integrate brand-safety/compliance check (profanity, legal terms, regulatory content) into VERD-POD using regex-based filter or third-party library.

**Technical Approach**:
- Brand safety rule engine
- Regulatory term detection
- Third-party library integration
- Compliance scoring system

**Acceptance Criteria**:
- [ ] Brand safety filter
- [ ] Profanity detection
- [ ] Legal term flagging
- [ ] Regulatory compliance check
- [ ] VERD-POD integration

---

**Title**: `[L5] Develop Human Jury Gate - Backend & Table`
**Labels**: `L5:Observability`, `Type:Feature`, `Comp:Governance`, `Prio:Medium`
**Milestone**: Phase 4: Production & Optimization
**Description**: 
Create jury_session table and implement backend logic for jurors to submit scores/status and for the system to process feedback (push rewards to SQS).

**Technical Approach**:
- jury_session table design
- Scoring API endpoints
- Reward signal generation
- Status workflow management

**Acceptance Criteria**:
- [ ] jury_session table schema
- [ ] Juror scoring API
- [ ] Status workflow (PENDING/APPROVED/REJECTED)
- [ ] Reward signal generation
- [ ] SQS integration

---

**Title**: `[L5] Develop Human Jury Gate - UI`
**Labels**: `L5:Observability`, `Type:Feature`, `Comp:Governance`, `Comp:UI`, `Prio:Medium`
**Milestone**: Phase 4: Production & Optimization
**Description**: 
Develop lightweight React web app (hosted on Amplify) for human jurors to review top-K ideas, score them (0-10), and approve/reject with feedback.

**Technical Approach**:
- React web application
- AWS Amplify hosting
- Idea review interface
- Scoring and feedback system

**Acceptance Criteria**:
- [ ] React app development
- [ ] Amplify deployment
- [ ] Idea review interface
- [ ] 0-10 scoring system
- [ ] Approve/reject workflow
- [ ] Feedback collection

---

**Title**: `[L5] Create Operational Runbooks`
**Labels**: `L5:Observability`, `Type:Documentation`, `Comp:Ops`, `Prio:Medium`
**Milestone**: Phase 4: Production & Optimization
**Description**: 
Develop runbooks for key operational procedures: L0 deployment DAG verification, Orchestrator fault handling, Trainer monitoring and validation.

**Technical Approach**:
- Step-by-step procedures
- Troubleshooting guides
- Escalation procedures
- Validation checklists

**Acceptance Criteria**:
- [ ] L0 deployment DAG runbook
- [ ] Orchestrator fault handling guide
- [ ] Trainer monitoring procedures
- [ ] Troubleshooting documentation
- [ ] Escalation procedures

---

## 🚀 Deployment & Scaling Strategy Tasks

**Title**: `[DEPLOY] Set up Dev Environment`
**Labels**: `Type:Chore`, `Comp:Infra`, `Prio:High`
**Milestone**: Phase 1: Foundation
**Description**: 
Configure local development environment with minikube, local Postgres, and Kafka for development and testing.

**Technical Approach**:
- minikube cluster setup
- Local Postgres installation
- Local Kafka configuration
- Development tooling

**Acceptance Criteria**:
- [ ] minikube cluster running
- [ ] Local Postgres setup
- [ ] Local Kafka configuration
- [ ] Development environment documentation
- [ ] Quick start guide

---

**Title**: `[DEPLOY] Set up Test Environment`
**Labels**: `Type:Chore`, `Comp:Infra`, `Prio:High`
**Milestone**: Phase 1: Foundation
**Description**: 
Configure EKS dev cluster, dev Aurora instance, and MSK tier-1 for integration testing and staging.

**Technical Approach**:
- EKS dev cluster deployment
- Aurora dev instance setup
- MSK tier-1 configuration
- CI/CD integration

**Acceptance Criteria**:
- [ ] EKS dev cluster deployment
- [ ] Aurora dev instance
- [ ] MSK tier-1 setup
- [ ] CI/CD pipeline integration
- [ ] Environment isolation

---

**Title**: `[DEPLOY] Set up Prod Environment`
**Labels**: `Type:Chore`, `Comp:Infra`, `Prio:High`
**Milestone**: Phase 4: Production & Optimization
**Description**: 
Configure EKS prod cluster (2×m5.large + 4×p3.2xlarge), Aurora GlobalCluster, MSK Standard, and Ray cluster for production workloads.

**Technical Approach**:
- EKS prod cluster sizing
- Aurora GlobalCluster setup
- MSK Standard configuration
- Ray cluster deployment

**Acceptance Criteria**:
- [ ] EKS prod cluster (specified sizing)
- [ ] Aurora GlobalCluster (writer + 2 readers)
- [ ] MSK Standard (3 brokers)
- [ ] Ray cluster on EKS
- [ ] Production monitoring

---

**Title**: `[DEPLOY] Configure Auto-Scaling Profiles`
**Labels**: `Type:Chore`, `Comp:Infra`, `Comp:Autoscaler`, `Prio:Medium`
**Milestone**: Phase 4: Production & Optimization
**Description**: 
Implement and test auto-scaling for Crawlers (Kafka lag), Ray Embedding (backlog), Pods (Kubernetes HPA), and Trainers (spot bidding).

**Technical Approach**:
- Kafka lag-based scaling
- Ray cluster autoscaling
- Kubernetes HPA configuration
- Spot instance bidding

**Acceptance Criteria**:
- [ ] Crawler scaling (Kafka lag metrics)
- [ ] Ray embedding scaling (1→4 A10G)
- [ ] Pod HPA (CPU/memory)
- [ ] Trainer spot bidding
- [ ] Scaling policy testing

---

## 📋 Implementation Priority Matrix

### Phase 1: Foundation (Months 1-2)
**Critical Path**:
1. Repository setup and CI/CD
2. Kafka infrastructure and raw event topics
3. Aurora-Postgres + pgvector setup
4. Core crawler development (R, T, G, A)
5. ETL parser implementation
6. Basic monitoring setup

### Phase 2: Core Intelligence (Months 3-4)
**Critical Path**:
1. Embedding workers (Ray on EKS)
2. L2 Orchestrator and data schemas
3. Creator and Critic agents (BN-POD, RF-POD)
4. Judge ensemble (DB-POD)
5. L1 UCB Bandit and GRPO selector
6. HDBSCAN clustering pipeline

### Phase 3: Evolution & Learning (Months 5-6)
**Critical Path**:
1. L3 Meta-Review controller and elite grid
2. Genetic crossover and AZ mutation
3. L4 reward queue and trainers
4. VERD-POD and TSvc implementation
5. Cost controls and autoscaling
6. Security implementation

### Phase 4: Production & Optimization (Months 7-8)
**Critical Path**:
1. Production environment deployment
2. Human jury gate implementation
3. Performance optimization
4. Operational runbooks
5. Full monitoring and alerting
6. Load testing and validation

---

## 🎯 Getting Started

1. **Create GitHub Repository**: Initialize with this structure
2. **Set up GitHub Projects**: Follow [KANBAN_SETUP.md](./KANBAN_SETUP.md)
3. **Create Issues**: Use this task breakdown to create GitHub issues
4. **Configure Labels**: Apply the label system from the setup guide
5. **Set Milestones**: Create the 4 phase milestones
6. **Start Development**: Begin with Phase 1 critical path items

---

*This comprehensive task breakdown provides a roadmap for implementing the entire 6-layer AI system architecture with clear priorities, dependencies, and acceptance criteria.*
