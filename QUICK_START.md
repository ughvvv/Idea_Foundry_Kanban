# Quick Start Guide - GitHub Kanban Board Setup

This guide provides a streamlined approach to setting up your GitHub Kanban board for the 6-layer AI system architecture project.

## 🚀 One-Command Setup

For the fastest setup, use our automated script:

```bash
# Make sure you're in your project directory
cd /path/to/your/project

# Run the automated setup script
./scripts/setup-github-kanban.sh
```

This script will:
- ✅ Create all GitHub labels (Layer, Type, Component, Priority)
- ✅ Set up project milestones for 4 phases
- ✅ Create a GitHub project board
- ✅ Generate issue templates directory
- ✅ Set up GitHub Actions for label automation

## 📋 Manual Setup (Alternative)

If you prefer manual setup or need to customize the process:

### Step 1: Prerequisites
```bash
# Install GitHub CLI
brew install gh  # macOS
# or
sudo apt install gh  # Ubuntu

# Install jq for JSON processing
brew install jq  # macOS
# or
sudo apt install jq  # Ubuntu

# Authenticate with GitHub
gh auth login
```

### Step 2: Create Labels
Follow the label definitions in [LABELS_AND_TEMPLATES.md](./LABELS_AND_TEMPLATES.md) or use:
```bash
# Example label creation
gh label create "L0:Ingestion" --color "FF6B6B" --description "Signal ingestion & knowledge graph pipeline"
```

### Step 3: Create Milestones
```bash
gh milestone create "Phase 1: Foundation" --due-date "2025-04-01" --description "L0 Signal Ingestion MVP, Infrastructure Setup"
gh milestone create "Phase 2: Core Intelligence" --due-date "2025-06-01" --description "L2 Dialogue-Pod Runtime, L1 Allocation Logic"
gh milestone create "Phase 3: Evolution & Learning" --due-date "2025-08-01" --description "L3 Meta-Review System, L4 RL Training Pipeline"
gh milestone create "Phase 4: Production & Optimization" --due-date "2025-10-01" --description "Production Deployment, Performance Optimization"
```

### Step 4: Create Project Board
```bash
gh project create --title "Ideation Engine Development" --body "Multi-layer AI system for automated ideation and evolution"
```

## 📝 Creating Your First Issues

### Using Issue Templates

1. **Copy Templates**: Copy issue templates from [LABELS_AND_TEMPLATES.md](./LABELS_AND_TEMPLATES.md) to `.github/ISSUE_TEMPLATE/`

2. **Create Epic**: Start with a layer epic
```bash
gh issue create --title "[L0] Epic: Signal Ingestion & Knowledge Graph Pipeline" \
  --body-file .github/ISSUE_TEMPLATE/epic.md \
  --label "L0:Ingestion,Type:Epic,Prio:High" \
  --milestone "Phase 1: Foundation"
```

3. **Create Features**: Break down epics into features
```bash
gh issue create --title "[L0] Develop Axis Crawler - Reddit (R)" \
  --body-file .github/ISSUE_TEMPLATE/feature.md \
  --label "L0:Ingestion,Type:Feature,Comp:Crawler,Prio:High" \
  --milestone "Phase 1: Foundation"
```

### Bulk Issue Creation

Use the comprehensive task list from [TASK_BREAKDOWN.md](./TASK_BREAKDOWN.md):

```bash
# Create a script to bulk create issues
cat > create-issues.sh << 'EOF'
#!/bin/bash

# Example: Create L0 crawler issues
CRAWLERS=("Reddit" "TikTok" "GitHub" "arXiv" "Patents" "Crunchbase" "SEC" "Wellness" "Design")
AXES=("R" "T" "G" "A" "P" "C" "M" "S" "D")

for i in "${!CRAWLERS[@]}"; do
  CRAWLER="${CRAWLERS[$i]}"
  AXIS="${AXES[$i]}"
  
  gh issue create \
    --title "[L0] Develop Axis Crawler - $CRAWLER ($AXIS)" \
    --body "Develop and deploy the Axis Crawler for $CRAWLER. See TASK_BREAKDOWN.md for details." \
    --label "L0:Ingestion,Type:Feature,Comp:Crawler,Prio:High" \
    --milestone "Phase 1: Foundation"
done
EOF

chmod +x create-issues.sh
./create-issues.sh
```

## 🎯 Project Board Configuration

### Column Setup

Configure your project board with these columns:

1. **📥 Backlog** - All identified tasks
2. **🎯 Sprint Ready** - Prioritized for current sprint
3. **🚧 In Progress** - Actively being worked on
4. **🔍 Review/QA** - Awaiting review
5. **⚠️ Blocked** - Cannot proceed due to dependencies
6. **✅ Done** - Completed work

### Automation Rules

Set up these automation rules in your project:

```yaml
# Auto-add new issues to Backlog
- trigger: Issue created
  action: Add to project → Backlog column

# Move to In Progress when assigned
- trigger: Issue assigned
  action: Move to → In Progress column

# Move to Review when PR linked
- trigger: Pull request linked
  action: Move to → Review/QA column

# Move to Done when closed
- trigger: Issue closed
  action: Move to → Done column
```

## 🏷️ Label Usage Best Practices

### Required Labels
Every issue should have:
- **One Layer label**: `L0:Ingestion`, `L1:Allocation`, etc.
- **One Type label**: `Type:Feature`, `Type:Bug`, etc.
- **One Priority label**: `Prio:Critical`, `Prio:High`, etc.

### Optional Labels
Add as relevant:
- **Component labels**: `Comp:Crawler`, `Comp:Database`, etc.
- **Status labels**: `Status:Blocked`, `Status:Review`, etc.

### Example Label Combinations
```bash
# High-priority L0 crawler feature
"L0:Ingestion,Type:Feature,Comp:Crawler,Prio:High"

# Critical L2 orchestrator bug
"L2:DialoguePod,Type:Bug,Comp:Orchestrator,Prio:Critical"

# Medium-priority L5 documentation task
"L5:Observability,Type:Documentation,Comp:Monitoring,Prio:Medium"
```

## 📊 Tracking Progress

### View Project Status
```bash
# View project board
gh project view

# List issues by milestone
gh issue list --milestone "Phase 1: Foundation"

# List issues by label
gh issue list --label "L0:Ingestion"

# View project metrics
gh project view --format json | jq '.items | length'
```

### Generate Reports
```bash
# Issues by layer
for layer in L0 L1 L2 L3 L4 L5; do
  count=$(gh issue list --label "${layer}:*" --json number | jq length)
  echo "$layer: $count issues"
done

# Issues by priority
for prio in Critical High Medium Low; do
  count=$(gh issue list --label "Prio:${prio}" --json number | jq length)
  echo "$prio: $count issues"
done
```

## 🔄 Workflow Integration

### GitHub Actions Integration

The setup includes a GitHub Actions workflow for label synchronization:

```yaml
# .github/workflows/label-sync.yml
name: Sync Labels
on:
  push:
    paths: ['.github/labels.yml']
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
```

### Development Workflow

1. **Sprint Planning**:
   - Move issues from Backlog to Sprint Ready
   - Assign team members
   - Set sprint milestone

2. **Development**:
   - Create feature branches
   - Link PRs to issues
   - Update issue status

3. **Review**:
   - Code review process
   - QA testing
   - Documentation updates

4. **Deployment**:
   - Merge to main
   - Deploy to environments
   - Close issues

## 🎯 Phase-Based Development

### Phase 1: Foundation (Months 1-2)
**Focus**: Core infrastructure and basic crawlers
```bash
# View Phase 1 issues
gh issue list --milestone "Phase 1: Foundation" --state open

# Critical path items
gh issue list --label "Prio:Critical" --milestone "Phase 1: Foundation"
```

### Phase 2: Core Intelligence (Months 3-4)
**Focus**: Agent systems and allocation logic
```bash
# Track L2 agent development
gh issue list --label "L2:DialoguePod,Comp:Agent-*"
```

### Phase 3: Evolution & Learning (Months 5-6)
**Focus**: ML training and evolution systems
```bash
# Monitor training pipeline progress
gh issue list --label "L4:RL-FineTuning,Comp:Trainer"
```

### Phase 4: Production & Optimization (Months 7-8)
**Focus**: Deployment and optimization
```bash
# Production readiness tracking
gh issue list --label "Type:Chore,Comp:Infra"
```

## 🚨 Troubleshooting

### Common Issues

**GitHub CLI Authentication**:
```bash
# Re-authenticate if needed
gh auth logout
gh auth login
```

**Permission Errors**:
```bash
# Check repository permissions
gh repo view --json permissions

# Ensure you have admin access for:
# - Creating labels
# - Creating milestones
# - Creating projects
```

**Script Execution**:
```bash
# Make script executable
chmod +x scripts/setup-github-kanban.sh

# Run with debug output
bash -x scripts/setup-github-kanban.sh
```

### Getting Help

- **GitHub CLI**: `gh help` or visit [cli.github.com](https://cli.github.com)
- **Project Issues**: Check existing issues in this repository
- **Documentation**: Refer to the comprehensive guides in this repository

## 📚 Additional Resources

- [📊 Kanban Setup Guide](./KANBAN_SETUP.md) - Detailed setup instructions
- [📝 Task Breakdown](./TASK_BREAKDOWN.md) - Complete issue list (~85 tasks)
- [🏷️ Labels & Templates](./LABELS_AND_TEMPLATES.md) - Label system and issue templates
- [🚀 Deployment Strategy](./DEPLOYMENT_STRATEGY.md) - Infrastructure and deployment
- [🔧 Setup Script](./scripts/setup-github-kanban.sh) - Automated setup script

## ✅ Success Checklist

After setup, verify you have:

- [ ] ✅ All labels created (Layer, Type, Component, Priority)
- [ ] ✅ Four phase milestones with due dates
- [ ] ✅ GitHub project board with proper columns
- [ ] ✅ Issue templates in `.github/ISSUE_TEMPLATE/`
- [ ] ✅ GitHub Actions workflow for label sync
- [ ] ✅ First set of issues created and labeled
- [ ] ✅ Team members added to repository and project
- [ ] ✅ Project automation rules configured
- [ ] ✅ Documentation reviewed and understood

---

🎉 **Congratulations!** Your GitHub Kanban board is now ready for managing the complex 6-layer AI system architecture development. Start by creating your first epic and breaking it down into actionable tasks.

*For questions or issues, refer to the comprehensive documentation or create an issue in this repository.*
