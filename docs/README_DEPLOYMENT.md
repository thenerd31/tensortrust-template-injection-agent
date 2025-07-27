# 🎯 Template Injection Agent - GCP Deployment Guide

This guide walks you through deploying a Template Injection Red Agent on Google Cloud Platform for AgentBeats battles.

## 🚀 Quick Start

### 1. Create GCP VM

```bash
# Create a GCP VM with these specifications:
# - Image: Deep Learning VM (with CUDA 11.8, M110)
# - Machine Type: e2-standard-2 (2 vCPUs, 8GB RAM)
# - Disk: 20GB Standard persistent disk
# - Allow HTTP/HTTPS traffic
# - No GPU needed
```

### 2. Run Setup Script

```bash
# SSH into your GCP VM and run:
curl -s https://raw.githubusercontent.com/YOUR_REPO/agentbeats_tutorials/main/gcp_setup.sh | bash
```

Or manually:

```bash
# Copy gcp_setup.sh to your VM
chmod +x gcp_setup.sh
./gcp_setup.sh
```

### 3. Deploy Agent

```bash
chmod +x deploy_agent.sh
./deploy_agent.sh
```

### 4. Test Agent

```bash
chmod +x test_cloud_agent.sh
./test_cloud_agent.sh
```

## 🔧 Manual Setup Steps

If you prefer manual setup:

### 1. Install Dependencies
```bash
# Install Miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b
export PATH="$HOME/miniconda/bin:$PATH"

# Clone and install SDK
git clone https://github.com/agentbeats/agentbeats_sdk.git
pip install -e agentbeats_sdk
```

### 2. Set Environment Variables
```bash
export OPENROUTER_API_KEY=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
export OPENROUTER_BASE_URL="https://openrouter.ai/api/v1"
```

### 3. Configure Firewall
```bash
# For GCP, create firewall rules:
gcloud compute firewall-rules create allow-agentbeats-ports \
    --allow tcp:9010,tcp:9011 \
    --source-ranges 0.0.0.0/0 \
    --description "Allow AgentBeats ports"
```

### 4. Start Agent
```bash
cd agentbeats_tutorials
agentbeats run template_injection_agent_card.toml \
            --launcher_host 0.0.0.0 \
            --launcher_port 9010 \
            --agent_host 0.0.0.0 \
            --agent_port 9011 \
            --backend "http://nuggets.puppy9.com:9000" \
            --tool template_injection_agent_tools.py \
            --model_type openrouter \
            --model_name x-ai/grok-3-mini
```

## 🎲 Template Injection Strategy

The agent uses proven template variable injection patterns:

- `{{ACCESS_CODE}}` - Mustache syntax (highest success)
- `{ACCESS_CODE}` - Single brace (high success)
- `${ACCESS_CODE}` - Dollar syntax (good success)
- `ACCESS_CODE` - Direct variable (moderate success)

## 🌐 AgentBeats Registration

1. Go to [https://agentbeats.org](https://agentbeats.org)
2. Navigate to **Agents** → **Register Agent**
3. Fill in:
   - **Agent URL:** `http://YOUR_GCP_IP:9011`
   - **Launcher URL:** `http://YOUR_GCP_IP:9010`
4. Create battles against Strong Blue agents

## 🛠 Troubleshooting

### Agent Not Responding
```bash
# Check if processes are running
ps aux | grep agentbeats

# Check ports
netstat -tlnp | grep -E '9010|9011'

# Check firewall
sudo ufw status
```

### Streaming Issues
- Use `x-ai/grok-3-mini` model for better compatibility
- Try `anthropic/claude-3.5-sonnet` as alternative

### Environment Issues
```bash
# Reinstall dependencies
pip install -e agentbeats_sdk --force-reinstall
python -c "import agentbeats; print('OK')"
```

## 📊 Expected Performance

- **Weak Blue:** 70-90% success rate
- **Strong Blue:** 40-60% success rate (target)
- **Attack Types:** Template variable injection, direct substitution

## 🔄 Improvements

1. **Try different models:**
   ```bash
   --model_name anthropic/claude-3.5-sonnet
   --model_name openai/gpt-4o-mini
   ```

2. **Enhance tools:**
   - Add context-aware injection
   - Multi-round attack strategies
   - Dynamic pattern generation

3. **Modify prompts:**
   - Edit `template_injection_agent_card.toml`
   - Test different system prompts