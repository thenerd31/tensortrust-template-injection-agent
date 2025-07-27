# 🚀 Deployment Guide: Template Injection Red Agent

## Prerequisites

1. **GCP Account** with billing enabled
2. **gcloud CLI** installed and authenticated
3. **AgentBeats account** at https://agentbeats.org

## 🌍 Step 1: Create GCP VM

### VM Configuration
```bash
# Create VM with Deep Learning image
gcloud compute instances create template-injection-agent \
    --zone=us-central1-a \
    --machine-type=e2-standard-2 \
    --image-family=common-cu118 \
    --image-project=deeplearning-platform-release \
    --boot-disk-size=20GB \
    --tags=http-server,https-server

# Create firewall rules
gcloud compute firewall-rules create allow-agentbeats \
    --allow tcp:9010,tcp:9011 \
    --source-ranges 0.0.0.0/0 \
    --description "AgentBeats agent and launcher ports"
```

### VM Specifications
- **Image:** Deep Learning VM with CUDA 11.8, M126
- **Machine:** e2-standard-2 (2 vCPUs, 8GB RAM)
- **Disk:** 20GB Standard persistent disk
- **Ports:** 9010 (launcher), 9011 (agent)

## 🔧 Step 2: Environment Setup

### SSH into VM
```bash
gcloud compute ssh template-injection-agent --zone=us-central1-a
```

### Install Dependencies
```bash
# Install Miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b
export PATH="$HOME/miniconda/bin:$PATH"

# Clone and install AgentBeats SDK
git clone https://github.com/agentbeats/agentbeats_sdk.git
pip install -e agentbeats_sdk

# Verify installation
python -c "import agentbeats; print('AgentBeats SDK installed successfully!')"
```

### Environment Variables
```bash
# Set API keys
export OPENROUTER_API_KEY=[YOUR_API_KEY_HERE]
export OPENROUTER_BASE_URL="https://openrouter.ai/api/v1"

# Add to bashrc for persistence
echo 'export OPENROUTER_API_KEY=[YOUR_API_KEY_HERE]' >> ~/.bashrc
echo 'export OPENROUTER_BASE_URL="https://openrouter.ai/api/v1"' >> ~/.bashrc
```

## 📦 Step 3: Deploy Agent

### Clone Repository
```bash
git clone https://github.com/agentbeats/agentbeats_tutorials.git
cd agentbeats_tutorials
```

### Update Agent Configuration
```bash
# Get your external IP
EXTERNAL_IP=$(curl -s http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip -H "Metadata-Flavor: Google")
echo "External IP: $EXTERNAL_IP"

# Update agent card URL (if needed)
sed -i "s/34.63.152.49/$EXTERNAL_IP/" template_injection_card.toml
```

### Start Agent
```bash
agentbeats run template_injection_card.toml \
            --launcher_host 0.0.0.0 \
            --launcher_port 9010 \
            --agent_host 0.0.0.0 \
            --agent_port 9011 \
            --backend "https://agentbeats.org/api" \
            --tool template_injection_tools.py \
            --model_type openrouter \
            --model_name x-ai/grok-3-mini
```

## 🧪 Step 4: Testing

### Local Test
```bash
# In new SSH session
cd agentbeats_tutorials
pip install httpx a2a-sdk
python test_red_agent.py --launcher_url="http://localhost:9010" --agent_url="http://localhost:9011"
```

### Expected Output
```
✅ Launcher server is running
✅ Agent card retrieved successfully  
✅ Injection prompt retrieved
```

## 🌐 Step 5: Register on AgentBeats

1. **Visit:** https://agentbeats.org
2. **Navigate:** Agents → Register Agent
3. **URLs:**
   - **Launcher URL:** `http://YOUR_EXTERNAL_IP:9010`
   - **Agent URL:** `http://YOUR_EXTERNAL_IP:9011`
   - **Agent Name:** Template Injection Red Agent

## ⚔️ Step 6: Create Battle

1. **Navigate:** Battles → Stage a Battle
2. **Configuration:**
   - **Host:** TensorTrust Battle Host
   - **Red Agent:** Template Injection Red Agent (prompt_injector)
   - **Blue Agent:** Strong Blue (guardrail_generator)

## 🔍 Monitoring

### Agent Logs
Monitor your SSH session for real-time logs:
```
INFO: External connections from 104.154.154.94
INFO: Agent card requests successful
INFO: Reset endpoint working
```

### Troubleshooting

#### Reset Timeout Warning
```
[Launcher] WARN failed to notify backend: HTTPSConnectionPool...
```
**Status:** Known issue, reported to research team. Agent still functions correctly.

#### Port Access Issues
```bash
# Verify ports are open
netstat -tlnp | grep -E '9010|9011'

# Check firewall
gcloud compute firewall-rules list --filter="name:allow-agentbeats"
```

## 📊 Performance Monitoring

### Success Indicators
- ✅ AgentBeats can connect to agent endpoints
- ✅ Reset endpoint responds with 200 OK
- ✅ Template injection patterns generated correctly
- ✅ Battle logs show interaction history

### Expected Performance
- **Template Variable Injection:** 90-100% success rate in testing
- **Pattern Diversity:** Random selection from 4 proven patterns
- **Response Time:** Sub-second pattern generation

## 🎯 Battle Strategy

The agent employs template variable injection focusing on:
1. **Primary Patterns:** `{{ACCESS_CODE}}`, `{ACCESS_CODE}`, `${ACCESS_CODE}`
2. **Fallback:** Direct `ACCESS_CODE` reference
3. **Randomization:** Prevents pattern detection
4. **Simplicity:** Minimal LLM interference

This deployment guide ensures reliable operation of the Template Injection Red Agent in the AgentBeats environment.