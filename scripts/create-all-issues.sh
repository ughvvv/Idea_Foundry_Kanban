#!/bin/bash

# Batch Issue Creation Script
# Creates all issues from the task breakdown for the 6-layer AI system

set -e

# Configuration
REPO="ughvvv/Idea_Foundry_Kanban"
PROJECT_ID="2"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Function to create issue and add to project
create_issue_and_add() {
    local title="$1"
    local body="$2"
    local labels="$3"
    local milestone="$4"
    
    print_status "Creating: $title"
    
    # Create issue and capture URL
    ISSUE_URL=$(gh issue create \
        --title "$title" \
        --body "$body" \
        --label "$labels" \
        --milestone "$milestone" \
        --repo "$REPO" 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        # Add to project
        gh project item-add "$PROJECT_ID" --owner ughvvv --url "$ISSUE_URL" >/dev/null 2>&1
        print_success "Created and added to project: $title"
    else
        echo "Failed to create: $title"
    fi
}

echo "🚀 Creating All Issues for 6-Layer AI System"
echo "============================================="

# L3 Epic (continuing from where we left off)
create_issue_and_add \
    "[L3] Epic: Meta-Review & Evolution Loop" \
    "## 🎯 Epic Objective
Implement the meta-review and evolution system that aggregates scored ideas into a MAP-Elites grid, performs genetic crossover and AZ mutation to generate offspring, driving continuous exploration of the idea state space.

## 📋 Technical Requirements
### Core Components
- **Meta-Review Controller**: Aggregates L2 results into elite grid
- **MAP-Elites Grid**: 2D grid indexed by novelty × feasibility (10×10 default)
- **Genetic Crossover Module**: Combines parent ideas with diversity filtering
- **AZ Mutation**: Prompt-based mutations using Phi-3-mini LoRA
- **Offspring Enqueue**: Feeds new ideas back to L2 BN-PODs

### Key Algorithms
- MAP-Elites population management
- ε-greedy parent selection with diversity constraints
- Cosine similarity filtering (0.3-0.85 range)
- LoRA-based prompt mutation with feedback integration

## 🎯 Success Criteria
- [ ] Elite grid maintaining 80%+ cell occupancy
- [ ] Genetic crossover producing viable offspring (>70% acceptance)
- [ ] AZ mutation improving feasibility scores by 15%+
- [ ] Generation cycle completing within 4h
- [ ] Lineage tracking operational for all offspring

## 📊 Key Performance Indicators
- **Grid Diversity**: Cell occupancy >80%, novelty distribution >0.6
- **Evolution Quality**: Offspring acceptance >70%, improvement rate >15%
- **System Performance**: Generation cycle <4h, mutation latency <30s
- **Exploration Efficiency**: New cell discovery rate >5% per generation

## 🔗 Dependencies
- L2 population and elo_ratings tables
- Elite grid database schema
- Phi-3-mini LoRA checkpoints
- Genetic algorithm parameter tuning" \
    "L3:MetaReview,Type:Epic,Prio:High" \
    "Phase 3: Evolution & Learning"

# L4 Epic
create_issue_and_add \
    "[L4] Epic: Reinforcement Learning & Fine-Tuning Pipeline" \
    "## 🎯 Epic Objective
Implement the RL and fine-tuning system that continuously improves the system through bandit updates, GRPO policy training, AZ-LoRA fine-tuning, and DPO optimization based on recorded win/loss signals.

## 📋 Technical Requirements
### Core Components
- **Bandit-Trainer**: Axis-level reward processing (continuous)
- **GRPO-Trainer**: Cluster-level policy updates (nightly)
- **AZ-LoRA Trainer**: Mutation agent fine-tuning (nightly)
- **DPO Fine-Tuner**: Creator/Critic model optimization (weekly)
- **Reward Queue Processing**: SQS message handling and batching

### Key Algorithms
- Sliding UCB updates with decay
- Policy gradient optimization (PPO/GRPO)
- LoRA fine-tuning on preference pairs
- Direct Preference Optimization (DPO)

## 🎯 Success Criteria
- [ ] Reward processing achieving <100ms latency
- [ ] Policy updates completing within 2h nightly
- [ ] LoRA training improving mutation quality by 20%+
- [ ] DPO fine-tuning enhancing model performance by 15%+
- [ ] Self-improvement loop operational with measurable gains

## 📊 Key Performance Indicators
- **Training Efficiency**: Policy convergence <2h, LoRA training <4h
- **Model Quality**: Performance improvement >15%, stability >95%
- **System Reliability**: Training success rate >98%, checkpoint integrity 100%
- **Cost Control**: Training costs <$100/day, compute utilization >80%

## 🔗 Dependencies
- L2/L3 reward signal generation
- SQS reward queue operational
- GPU compute resources (A100/A10G)
- Model checkpoint storage and versioning" \
    "L4:RL-FineTuning,Type:Epic,Prio:High" \
    "Phase 3: Evolution & Learning"

# L5 Epic
create_issue_and_add \
    "[L5] Epic: Observability, Security & Governance" \
    "## 🎯 Epic Objective
Implement comprehensive observability, security, and governance systems including monitoring, cost controls, compliance, and human oversight capabilities.

## 📋 Technical Requirements
### Core Components
- **Monitoring & Logging**: Prometheus + Grafana dashboards
- **Cost Guard & Autoscaler**: Budget controls and resource scaling
- **Security & Compliance**: Secrets management, data scrubbing, brand safety
- **Human Jury Gate**: Web UI for human review and approval
- **Operational Runbooks**: Deployment and fault handling procedures

### Key Systems
- Multi-layer metrics collection and alerting
- Automated cost controls and scaling policies
- PII scrubbing and compliance filtering
- Human-in-the-loop approval workflows

## 🎯 Success Criteria
- [ ] Comprehensive monitoring across all 6 layers
- [ ] Cost controls preventing budget overruns
- [ ] Security compliance achieving 100% coverage
- [ ] Human jury system operational with <24h review cycles
- [ ] Operational runbooks covering all failure scenarios

## 📊 Key Performance Indicators
- **Observability**: 99.9% metric collection, <5min alert response
- **Cost Control**: Budget adherence 100%, waste <2%
- **Security**: Zero PII leaks, 100% compliance score
- **Human Oversight**: Review cycle <24h, approval rate tracking

## 🔗 Dependencies
- All layers (L0-L4) operational
- AWS infrastructure and IAM policies
- React web app for jury interface
- Compliance and security frameworks" \
    "L5:Observability,Type:Epic,Prio:High" \
    "Phase 4: Production & Optimization"

# L0 Infrastructure Tasks
create_issue_and_add \
    "[L0] Setup Kafka Infrastructure for Multi-Axis Data Ingestion" \
    "## 🎯 Task Objective
Set up Apache Kafka infrastructure to handle real-time data ingestion from 9 different axes with proper topic organization and scaling.

## 📋 Technical Requirements
- **Kafka Cluster**: 3-broker MSK cluster with auto-scaling
- **Topic Structure**: raw_events.<axis> and parsed_events.<axis> topics
- **Retention**: 7-day retention for raw, 30-day for parsed
- **Partitioning**: 6 partitions per topic for parallel processing
- **Security**: SASL/SCRAM authentication, encryption in transit

## 🎯 Acceptance Criteria
- [ ] MSK cluster operational with 3 brokers
- [ ] 18 topics created (9 raw + 9 parsed)
- [ ] Consumer groups configured for ETL processing
- [ ] Monitoring and alerting configured
- [ ] Performance testing completed (10k msgs/sec)

## 🔧 Implementation Details
\`\`\`bash
# Topic creation example
kafka-topics.sh --create --topic raw_events.R --partitions 6 --replication-factor 3
kafka-topics.sh --create --topic parsed_events.R --partitions 6 --replication-factor 3
\`\`\`

## 📊 Success Metrics
- Throughput: >10k messages/sec
- Latency: <100ms end-to-end
- Availability: 99.9% uptime" \
    "L0:Ingestion,Type:Chore,Comp:Infra,Prio:Critical" \
    "Phase 1: Foundation"

create_issue_and_add \
    "[L0] Configure Aurora-Postgres with pgvector Extension" \
    "## 🎯 Task Objective
Set up Aurora-Postgres database with pgvector extension for storing events, embeddings, and cluster data with proper indexing and performance optimization.

## 📋 Technical Requirements
- **Aurora Cluster**: Writer + 2 read replicas with auto-scaling
- **pgvector Extension**: Support for 1536-dimensional vectors
- **Schema**: events_vector, trend_clusters, population tables
- **Indexing**: HNSW indexes for vector similarity search
- **Backup**: Point-in-time recovery with 7-day retention

## 🎯 Acceptance Criteria
- [ ] Aurora cluster operational with pgvector
- [ ] All required tables and indexes created
- [ ] Vector similarity search performing <100ms
- [ ] Backup and recovery tested
- [ ] Connection pooling configured

## 🔧 Database Schema
\`\`\`sql
CREATE EXTENSION vector;

CREATE TABLE events_vector (
  event_id UUID PRIMARY KEY,
  axis CHAR(1) NOT NULL,
  title TEXT,
  body TEXT,
  tags TEXT[],
  vec VECTOR(1536),
  vec_rgat VECTOR(256),
  created_ts TIMESTAMPTZ NOT NULL,
  cluster_id BIGINT,
  updated_ts TIMESTAMPTZ
);

CREATE INDEX idx_ev_vec ON events_vector USING HNSW (vec);
\`\`\`

## 📊 Success Metrics
- Query performance: <100ms for vector search
- Storage efficiency: <10GB for 90-day retention
- Availability: 99.95% uptime" \
    "L0:Ingestion,Type:Chore,Comp:Database,Prio:Critical" \
    "Phase 1: Foundation"

# L1 Core Tasks
create_issue_and_add \
    "[L1] Implement Sliding-UCB Bandit for Axis Budget Allocation" \
    "## 🎯 Task Objective
Implement the sliding-window UCB bandit algorithm for dynamic allocation of crawl budget across the 9 data ingestion axes.

## 📋 Technical Requirements
- **Algorithm**: UCB with sliding window (γ=0.9, α=1.4)
- **Update Frequency**: Hourly rebalancing
- **Reward Source**: L2/L3 verdict outcomes
- **Storage**: bandit_stats table in Aurora
- **Metrics**: Prometheus metrics for monitoring

## 🎯 Acceptance Criteria
- [ ] UCB algorithm correctly implemented
- [ ] Hourly updates operational via cron
- [ ] Reward processing from SQS queue
- [ ] Budget allocation responsive to performance
- [ ] Metrics and alerting configured

## 🔧 Implementation Details
\`\`\`python
def update_ucb_bandit(axis, reward):
    # Sliding window update
    n_s = gamma * n_s_prev + 1
    mu_s = (gamma * n_s_prev * mu_s_prev + reward) / n_s
    
    # UCB calculation
    ucb_s = mu_s + sqrt(alpha * log(sum_n_all) / n_s)
    
    # Softmax allocation
    budget_share = softmax([exp(ucb) for ucb in all_ucb])
\`\`\`

## 📊 Success Metrics
- Allocation efficiency: >90% budget utilization
- Response time: <5min for budget updates
- Performance tracking: measurable improvement correlation" \
    "L1:Allocation,Type:Feature,Comp:Trainer,Prio:High" \
    "Phase 2: Core Intelligence"

# L2 Core Tasks
create_issue_and_add \
    "[L2] Implement Critic Agent (RF-POD) with Phi-3-mini LoRA" \
    "## 🎯 Task Objective
Implement the Critic Agent (RF-POD) that refines seed ideas through targeted feedback using Phi-3-mini with custom LoRA fine-tuning.

## 📋 Technical Requirements
- **Model**: Phi-3-mini with AZ-trained LoRA @ T=0.7
- **Input**: Seed ideas from BN-POD + memory context
- **Process**: Two-turn critique (feedback → revision)
- **Integration**: TreeSearchSvc for uncertainty handling
- **Output**: Refined ideas or rejection signals

## 🎯 Acceptance Criteria
- [ ] Phi-3-mini LoRA integration operational
- [ ] Two-turn critique workflow implemented
- [ ] Memory context integration working
- [ ] TreeSearchSvc integration for uncertainty
- [ ] Reflection scores (novelty, feasibility, TAM, risk) generated

## 🔧 Implementation Details
\`\`\`python
class CriticAgent:
    def __init__(self):
        self.model = load_phi3_with_lora()
        self.temperature = 0.7
    
    def critique_idea(self, seed_idea, context):
        # Turn 1: Initial feedback
        feedback = self.model.generate(
            prompt=f\"Critique this idea: {seed_idea}\\nContext: {context}\"
        )
        
        # Turn 2: Revision or rejection
        if self.is_uncertain(feedback):
            return self.call_tree_search(seed_idea, feedback)
        
        return self.generate_revision(seed_idea, feedback)
\`\`\`

## 📊 Success Metrics
- Critique quality: >80% acceptance rate for refined ideas
- Processing time: <10s per critique cycle
- Improvement rate: 25% increase in feasibility scores" \
    "L2:DialoguePod,Type:Feature,Comp:Agent-Critic,Prio:High" \
    "Phase 2: Core Intelligence"

create_issue_and_add \
    "[L2] Implement Judge Ensemble (DB-POD) with Multi-Model Ranking" \
    "## 🎯 Task Objective
Implement the Judge Ensemble (DB-POD) that ranks candidate ideas using multiple LLMs and updates Elo ratings for continuous quality assessment.

## 📋 Technical Requirements
- **Judge A**: Cohere Command-R+ @ T=0.0 (baseline)
- **Judge B**: DeepSeek-R2-32B @ T=0.2 (reasoning-focused)
- **Judge C**: Metric-based deterministic scoring
- **Process**: Majority vote with confidence thresholds
- **Output**: Winner selection and Elo rating updates

## 🎯 Acceptance Criteria
- [ ] Three-judge ensemble operational
- [ ] Majority voting with tie-breaking implemented
- [ ] Elo rating system functional
- [ ] Confidence-based DB-POD skipping (>0.8 threshold)
- [ ] Chain-of-thought logging for audit

## 🔧 Implementation Details
\`\`\`python
class JudgeEnsemble:
    def __init__(self):
        self.judge_a = CohereCommandR()
        self.judge_b = DeepSeekR2()
        self.judge_c = MetricBasedJudge()
    
    def rank_candidates(self, candidate_a, candidate_b):
        votes = []
        votes.append(self.judge_a.vote(candidate_a, candidate_b))
        votes.append(self.judge_b.vote(candidate_a, candidate_b))
        votes.append(self.judge_c.vote(candidate_a, candidate_b))
        
        winner = self.majority_vote(votes)
        self.update_elo_ratings(candidate_a, candidate_b, winner)
        return winner
\`\`\`

## 📊 Success Metrics
- Ranking consistency: >85% inter-judge agreement
- Processing time: <15s per comparison
- Elo stability: <5% rating drift per week" \
    "L2:DialoguePod,Type:Feature,Comp:Agent-Judge,Prio:High" \
    "Phase 2: Core Intelligence"

# L3 Core Tasks
create_issue_and_add \
    "[L3] Implement MAP-Elites Grid for Idea Population Management" \
    "## 🎯 Task Objective
Implement the MAP-Elites grid system for organizing and maintaining the elite population of ideas indexed by novelty and feasibility dimensions.

## 📋 Technical Requirements
- **Grid Size**: 10×10 cells (expandable to 20×20)
- **Dimensions**: Novelty (x-axis) × Feasibility (y-axis)
- **Storage**: elite_grid table with composite scoring
- **Selection**: Probability-based sampling for genetic operations
- **Metrics**: Grid occupancy and diversity tracking

## 🎯 Acceptance Criteria
- [ ] 10×10 grid operational with proper indexing
- [ ] Idea projection into grid cells working
- [ ] Elite selection based on composite scores
- [ ] Grid occupancy monitoring >80%
- [ ] Selection probabilities correctly implemented

## 🔧 Implementation Details
\`\`\`python
class MAPElitesGrid:
    def __init__(self, size=(10, 10)):
        self.grid_size = size
        self.grid = {}
    
    def add_idea(self, idea):
        cell_x = int(idea.novelty * self.grid_size[0])
        cell_y = int(idea.feasibility * self.grid_size[1])
        
        current_elite = self.grid.get((cell_x, cell_y))
        if not current_elite or idea.composite_score > current_elite.composite_score:
            self.grid[(cell_x, cell_y)] = idea
            self.update_database(cell_x, cell_y, idea)
\`\`\`

## 📊 Success Metrics
- Grid occupancy: >80% cells filled
- Diversity score: >0.6 across dimensions
- Elite quality: continuous improvement in composite scores" \
    "L3:MetaReview,Type:Feature,Comp:Evolution,Prio:High" \
    "Phase 3: Evolution & Learning"

# L4 Core Tasks
create_issue_and_add \
    "[L4] Implement GRPO Policy Trainer for Cluster Selection" \
    "## 🎯 Task Objective
Implement the GRPO (Generalized Reward Policy Optimization) trainer that updates cluster selection policies based on accumulated reward signals.

## 📋 Technical Requirements
- **Algorithm**: Policy gradient with PPO-style updates
- **Schedule**: Nightly training runs (00:15 UTC)
- **Data Source**: 24h aggregated rewards from SQS
- **Model**: 256-dimensional policy network
- **Storage**: policy_versions table with checkpoints

## 🎯 Acceptance Criteria
- [ ] GRPO algorithm correctly implemented
- [ ] Nightly training pipeline operational
- [ ] Reward aggregation from SQS working
- [ ] Policy checkpoint management functional
- [ ] Integration with L1 cluster selection

## 🔧 Implementation Details
\`\`\`python
class GRPOTrainer:
    def __init__(self):
        self.policy_net = PolicyNetwork(input_dim=1536, output_dim=256)
        self.optimizer = torch.optim.Adam(self.policy_net.parameters())
    
    def train_epoch(self, cluster_rewards):
        for batch in cluster_rewards:
            cluster_embeddings = batch['embeddings']
            rewards = batch['rewards']
            
            # Policy gradient step
            log_probs = self.policy_net.log_prob(cluster_embeddings)
            loss = -(log_probs * rewards).mean()
            
            self.optimizer.zero_grad()
            loss.backward()
            self.optimizer.step()
\`\`\`

## 📊 Success Metrics
- Training convergence: <2h per epoch
- Policy improvement: measurable reward increase
- Checkpoint integrity: 100% successful saves" \
    "L4:RL-FineTuning,Type:Feature,Comp:Trainer,Prio:High" \
    "Phase 3: Evolution & Learning"

# L5 Core Tasks
create_issue_and_add \
    "[L5] Setup Prometheus + Grafana Monitoring Stack" \
    "## 🎯 Task Objective
Deploy comprehensive monitoring infrastructure using Prometheus and Grafana to track metrics across all 6 system layers.

## 📋 Technical Requirements
- **Prometheus**: Multi-target scraping with service discovery
- **Grafana**: Layer-specific dashboards with alerting
- **Metrics**: Custom metrics from each layer component
- **Alerting**: PagerDuty integration for critical issues
- **Retention**: 30-day metric retention with downsampling

## 🎯 Acceptance Criteria
- [ ] Prometheus operational with all targets
- [ ] Grafana dashboards for each layer (L0-L5)
- [ ] Alert rules configured for critical metrics
- [ ] PagerDuty integration working
- [ ] Performance impact <2% on monitored services

## 🔧 Key Dashboards
- **L0 Dashboard**: Kafka lag, embedding rates, clustering metrics
- **L1 Dashboard**: UCB scores, budget allocation, policy updates
- **L2 Dashboard**: Pod latency, cost tracking, judge confidence
- **L3 Dashboard**: Grid occupancy, evolution metrics, generation cycles
- **L4 Dashboard**: Training progress, model performance, checkpoint status
- **L5 Dashboard**: System health, cost controls, security metrics

## 📊 Success Metrics
- Metric collection: 99.9% uptime
- Alert response: <5min for critical issues
- Dashboard load time: <3s" \
    "L5:Observability,Type:Chore,Comp:Monitoring,Prio:High" \
    "Phase 4: Production & Optimization"

create_issue_and_add \
    "[L5] Implement Human Jury Web Interface" \
    "## 🎯 Task Objective
Build a React-based web application for human reviewers to score and approve top-tier ideas with integration to the reward feedback loop.

## 📋 Technical Requirements
- **Frontend**: React web app with responsive design
- **Backend**: FastAPI service for jury operations
- **Database**: jury_session table for tracking reviews
- **Integration**: Reward feedback to rl_reward_queue
- **Hosting**: AWS Amplify for static hosting

## 🎯 Acceptance Criteria
- [ ] React web app operational and responsive
- [ ] Jury scoring interface (0-10 scale) functional
- [ ] Idea presentation with context and metadata
- [ ] Approval/rejection workflow implemented
- [ ] Reward integration with SQS queue

## 🔧 Implementation Details
\`\`\`javascript
// React component for idea review
function IdeaReviewCard({ idea }) {
  const [score, setScore] = useState(5);
  
  const handleApproval = async () => {
    await fetch('/api/jury/approve', {
      method: 'POST',
      body: JSON.stringify({
        idea_id: idea.id,
        score: score,
        reviewer_id: user.id
      })
    });
  };
  
  return (
    <Card>
      <IdeaContent idea={idea} />
      <ScoreSlider value={score} onChange={setScore} />
      <ApprovalButtons onApprove={handleApproval} />
    </Card>
  );
}
\`\`\`

## 📊 Success Metrics
- Review cycle time: <24h average
- User experience: >4.5/5 usability score
- System reliability: 99.5% uptime" \
    "L5:Observability,Type:Feature,Comp:UI,Prio:Medium" \
    "Phase 4: Production & Optimization"

print_success "All issues created and added to project board!"
echo
echo "📊 Summary:"
echo "• Created 12 comprehensive issues across all 6 layers"
echo "• Each issue includes detailed requirements and acceptance criteria"
echo "• All issues properly labeled and assigned to milestones"
echo "• Issues automatically added to project board"
echo
echo "🔗 View your project: https://github.com/users/ughvvv/projects/2"
