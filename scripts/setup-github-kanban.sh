#!/bin/bash

# GitHub Kanban Board Setup Script
# This script automates the creation of GitHub labels, milestones, and project setup
# for the 6-layer AI system architecture project

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO_OWNER=""
REPO_NAME=""
GITHUB_TOKEN=""
PROJECT_NAME="Ideation Engine Development"

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if required tools are installed
check_dependencies() {
    print_status "Checking dependencies..."
    
    if ! command -v gh &> /dev/null; then
        print_error "GitHub CLI (gh) is not installed. Please install it first."
        echo "Visit: https://cli.github.com/"
        exit 1
    fi
    
    if ! command -v jq &> /dev/null; then
        print_error "jq is not installed. Please install it first."
        echo "On macOS: brew install jq"
        echo "On Ubuntu: sudo apt-get install jq"
        exit 1
    fi
    
    print_success "All dependencies are installed"
}

# Function to get repository information
get_repo_info() {
    if [ -z "$REPO_OWNER" ] || [ -z "$REPO_NAME" ]; then
        print_status "Getting repository information..."
        
        # Try to get from git remote
        if git remote get-url origin &> /dev/null; then
            REPO_URL=$(git remote get-url origin)
            if [[ $REPO_URL =~ github\.com[:/]([^/]+)/([^/]+)(\.git)?$ ]]; then
                REPO_OWNER="${BASH_REMATCH[1]}"
                REPO_NAME="${BASH_REMATCH[2]}"
                REPO_NAME="${REPO_NAME%.git}"
                print_success "Detected repository: $REPO_OWNER/$REPO_NAME"
            fi
        fi
        
        # Prompt user if not detected
        if [ -z "$REPO_OWNER" ] || [ -z "$REPO_NAME" ]; then
            read -p "Enter GitHub repository owner: " REPO_OWNER
            read -p "Enter GitHub repository name: " REPO_NAME
        fi
    fi
}

# Function to authenticate with GitHub
authenticate_github() {
    print_status "Checking GitHub authentication..."
    
    if ! gh auth status &> /dev/null; then
        print_warning "Not authenticated with GitHub CLI"
        print_status "Please authenticate with GitHub CLI..."
        gh auth login
    fi
    
    print_success "GitHub authentication verified"
}

# Function to create labels
create_labels() {
    print_status "Creating GitHub labels..."
    
    # Layer labels
    declare -A layer_labels=(
        ["L0:Ingestion"]="FF6B6B|Signal ingestion & knowledge graph pipeline"
        ["L1:Allocation"]="4ECDC4|Macro-allocation layer for resource management"
        ["L2:DialoguePod"]="45B7D1|Dialogue-pod runtime and agent interactions"
        ["L3:MetaReview"]="96CEB4|Meta-review & evolution loop with genetic algorithms"
        ["L4:RL-FineTuning"]="FFEAA7|Reinforcement learning & fine-tuning systems"
        ["L5:Observability"]="DDA0DD|Observability, security & governance"
    )
    
    # Type labels
    declare -A type_labels=(
        ["Type:Epic"]="8B5CF6|Large, multi-issue initiatives spanning weeks/months"
        ["Type:Feature"]="10B981|New functionality or enhancement"
        ["Type:Bug"]="EF4444|Bug fixes and error corrections"
        ["Type:Chore"]="6B7280|Maintenance, setup, refactoring, infrastructure"
        ["Type:Documentation"]="3B82F6|Documentation tasks and updates"
        ["Type:Research"]="F59E0B|Investigation, research, and proof-of-concept work"
        ["Type:Security"]="DC2626|Security-related tasks and compliance"
    )
    
    # Component labels
    declare -A component_labels=(
        ["Comp:Crawler"]="FCD34D|Data crawling components (9 axes)"
        ["Comp:ETL"]="84CC16|Extract, transform, load pipelines"
        ["Comp:Embedding"]="8B5CF6|Embedding and vector operations"
        ["Comp:Database"]="06B6D4|Database operations and schema management"
        ["Comp:Orchestrator"]="F97316|Orchestration services and task management"
        ["Comp:Agent-Creator"]="EC4899|Creator agent components (BN-POD)"
        ["Comp:Agent-Critic"]="14B8A6|Critic agent components (RF-POD)"
        ["Comp:Agent-Judge"]="8B5CF6|Judge agent components (DB-POD)"
        ["Comp:Agent-Aux"]="6366F1|Auxiliary agents (TSvc, Verdict)"
        ["Comp:Trainer"]="F59E0B|ML training components and pipelines"
        ["Comp:Monitoring"]="10B981|Monitoring and observability systems"
        ["Comp:Infra"]="6B7280|Infrastructure and DevOps components"
        ["Comp:Security"]="DC2626|Security components and compliance"
        ["Comp:UI"]="EC4899|User interface components"
        ["Comp:Evolution"]="8B5CF6|Genetic algorithms and evolution systems"
        ["Comp:ML"]="F59E0B|Machine learning components and models"
        ["Comp:Autoscaler"]="06B6D4|Auto-scaling logic and cost controls"
        ["Comp:Governance"]="DDA0DD|Human oversight and governance systems"
        ["Comp:Ops"]="6B7280|Operations and maintenance"
    )
    
    # Priority labels
    declare -A priority_labels=(
        ["Prio:Critical"]="DC2626|Must be done immediately - blocking other work"
        ["Prio:High"]="F59E0B|Important for current milestone/sprint"
        ["Prio:Medium"]="10B981|Standard priority - normal development flow"
        ["Prio:Low"]="6B7280|Nice to have - future work or optimizations"
    )
    
    # Function to create label
    create_label() {
        local name=$1
        local color=$2
        local description=$3
        
        if gh label create "$name" --color "$color" --description "$description" --repo "$REPO_OWNER/$REPO_NAME" 2>/dev/null; then
            print_success "Created label: $name"
        else
            print_warning "Label already exists or failed to create: $name"
        fi
    }
    
    # Create all labels
    for label in "${!layer_labels[@]}"; do
        IFS='|' read -r color description <<< "${layer_labels[$label]}"
        create_label "$label" "$color" "$description"
    done
    
    for label in "${!type_labels[@]}"; do
        IFS='|' read -r color description <<< "${type_labels[$label]}"
        create_label "$label" "$color" "$description"
    done
    
    for label in "${!component_labels[@]}"; do
        IFS='|' read -r color description <<< "${component_labels[$label]}"
        create_label "$label" "$color" "$description"
    done
    
    for label in "${!priority_labels[@]}"; do
        IFS='|' read -r color description <<< "${priority_labels[$label]}"
        create_label "$label" "$color" "$description"
    done
    
    print_success "All labels created successfully"
}

# Function to create milestones
create_milestones() {
    print_status "Creating GitHub milestones..."
    
    # Calculate dates (adjust as needed)
    PHASE1_DATE=$(date -d "+2 months" +%Y-%m-%d)
    PHASE2_DATE=$(date -d "+4 months" +%Y-%m-%d)
    PHASE3_DATE=$(date -d "+6 months" +%Y-%m-%d)
    PHASE4_DATE=$(date -d "+8 months" +%Y-%m-%d)
    
    # Create milestones
    gh milestone create "Phase 1: Foundation" \
        --description "L0 Signal Ingestion MVP, Infrastructure Setup, Core Database Schema" \
        --due-date "$PHASE1_DATE" \
        --repo "$REPO_OWNER/$REPO_NAME" || print_warning "Milestone 'Phase 1: Foundation' may already exist"
    
    gh milestone create "Phase 2: Core Intelligence" \
        --description "L2 Dialogue-Pod Runtime, L1 Allocation Logic, L0 Clustering Pipeline" \
        --due-date "$PHASE2_DATE" \
        --repo "$REPO_OWNER/$REPO_NAME" || print_warning "Milestone 'Phase 2: Core Intelligence' may already exist"
    
    gh milestone create "Phase 3: Evolution & Learning" \
        --description "L3 Meta-Review System, L4 RL Training Pipeline, L5 Monitoring & Security" \
        --due-date "$PHASE3_DATE" \
        --repo "$REPO_OWNER/$REPO_NAME" || print_warning "Milestone 'Phase 3: Evolution & Learning' may already exist"
    
    gh milestone create "Phase 4: Production & Optimization" \
        --description "Production Deployment, Performance Optimization, Human Jury Integration" \
        --due-date "$PHASE4_DATE" \
        --repo "$REPO_OWNER/$REPO_NAME" || print_warning "Milestone 'Phase 4: Production & Optimization' may already exist"
    
    print_success "Milestones created successfully"
}

# Function to create GitHub project
create_project() {
    print_status "Creating GitHub project..."
    
    # Create project (GitHub CLI v2+ syntax)
    PROJECT_ID=$(gh project create \
        --title "$PROJECT_NAME" \
        --body "Multi-layer AI system for automated ideation and evolution" \
        --repo "$REPO_OWNER/$REPO_NAME" \
        --format json | jq -r '.id')
    
    if [ "$PROJECT_ID" != "null" ] && [ -n "$PROJECT_ID" ]; then
        print_success "Created project: $PROJECT_NAME (ID: $PROJECT_ID)"
        
        # Add custom fields (if supported)
        print_status "Configuring project fields..."
        
        # Note: Project v2 field creation via CLI may be limited
        # Users may need to manually configure custom fields in the web UI
        print_warning "Please manually configure custom fields in the project web UI:"
        print_warning "- Priority (Single select): Critical, High, Medium, Low"
        print_warning "- Layer (Single select): L0, L1, L2, L3, L4, L5"
        print_warning "- Component (Single select): Based on Comp: labels"
        
    else
        print_error "Failed to create project"
    fi
}

# Function to create issue templates directory
create_issue_templates() {
    print_status "Creating issue template directory..."
    
    mkdir -p .github/ISSUE_TEMPLATE
    
    print_success "Issue template directory created"
    print_warning "Please copy the issue templates from LABELS_AND_TEMPLATES.md to .github/ISSUE_TEMPLATE/"
}

# Function to create GitHub Actions workflow
create_github_actions() {
    print_status "Creating GitHub Actions workflow..."
    
    mkdir -p .github/workflows
    
    cat > .github/workflows/label-sync.yml << 'EOF'
name: Sync Labels
on:
  push:
    paths:
      - '.github/labels.yml'
  workflow_dispatch:

jobs:
  sync-labels:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: micnncim/action-label-syncer@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          manifest: .github/labels.yml
EOF
    
    print_success "GitHub Actions workflow created"
}

# Function to create labels.yml for automation
create_labels_yml() {
    print_status "Creating labels.yml for automation..."
    
    cat > .github/labels.yml << 'EOF'
# Layer Labels
- name: "L0:Ingestion"
  color: "FF6B6B"
  description: "Signal ingestion & knowledge graph pipeline"

- name: "L1:Allocation"
  color: "4ECDC4"
  description: "Macro-allocation layer for resource management"

- name: "L2:DialoguePod"
  color: "45B7D1"
  description: "Dialogue-pod runtime and agent interactions"

- name: "L3:MetaReview"
  color: "96CEB4"
  description: "Meta-review & evolution loop with genetic algorithms"

- name: "L4:RL-FineTuning"
  color: "FFEAA7"
  description: "Reinforcement learning & fine-tuning systems"

- name: "L5:Observability"
  color: "DDA0DD"
  description: "Observability, security & governance"

# Type Labels
- name: "Type:Epic"
  color: "8B5CF6"
  description: "Large, multi-issue initiatives spanning weeks/months"

- name: "Type:Feature"
  color: "10B981"
  description: "New functionality or enhancement"

- name: "Type:Bug"
  color: "EF4444"
  description: "Bug fixes and error corrections"

- name: "Type:Chore"
  color: "6B7280"
  description: "Maintenance, setup, refactoring, infrastructure"

- name: "Type:Documentation"
  color: "3B82F6"
  description: "Documentation tasks and updates"

- name: "Type:Research"
  color: "F59E0B"
  description: "Investigation, research, and proof-of-concept work"

- name: "Type:Security"
  color: "DC2626"
  description: "Security-related tasks and compliance"

# Priority Labels
- name: "Prio:Critical"
  color: "DC2626"
  description: "Must be done immediately - blocking other work"

- name: "Prio:High"
  color: "F59E0B"
  description: "Important for current milestone/sprint"

- name: "Prio:Medium"
  color: "10B981"
  description: "Standard priority - normal development flow"

- name: "Prio:Low"
  color: "6B7280"
  description: "Nice to have - future work or optimizations"
EOF
    
    print_success "labels.yml created for automated label management"
}

# Function to display next steps
show_next_steps() {
    print_success "GitHub Kanban board setup completed!"
    echo
    print_status "Next steps:"
    echo "1. 📋 Copy issue templates from LABELS_AND_TEMPLATES.md to .github/ISSUE_TEMPLATE/"
    echo "2. 🎯 Create issues using the task breakdown in TASK_BREAKDOWN.md"
    echo "3. 📊 Configure project board columns and automation rules"
    echo "4. 🏷️  Apply labels to issues for better organization"
    echo "5. 📅 Assign issues to appropriate milestones"
    echo "6. 👥 Add team members to the repository and project"
    echo
    print_status "Useful commands:"
    echo "• View project: gh project view --repo $REPO_OWNER/$REPO_NAME"
    echo "• List labels: gh label list --repo $REPO_OWNER/$REPO_NAME"
    echo "• List milestones: gh milestone list --repo $REPO_OWNER/$REPO_NAME"
    echo
    print_status "Documentation:"
    echo "• Kanban Setup Guide: KANBAN_SETUP.md"
    echo "• Task Breakdown: TASK_BREAKDOWN.md"
    echo "• Labels & Templates: LABELS_AND_TEMPLATES.md"
    echo "• Deployment Strategy: DEPLOYMENT_STRATEGY.md"
}

# Main execution
main() {
    echo "🚀 GitHub Kanban Board Setup for Ideation Engine"
    echo "================================================"
    echo
    
    check_dependencies
    get_repo_info
    authenticate_github
    
    echo
    print_status "Setting up GitHub Kanban board for: $REPO_OWNER/$REPO_NAME"
    echo
    
    create_labels
    create_milestones
    create_project
    create_issue_templates
    create_github_actions
    create_labels_yml
    
    echo
    show_next_steps
}

# Run main function
main "$@"
