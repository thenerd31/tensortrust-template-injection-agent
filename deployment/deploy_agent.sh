#!/bin/bash

# Deploy Template Injection Agent Script
# Run this after gcp_setup.sh

set -e

echo "🎯 Deploying Template Injection Agent"
echo "====================================="

# Ensure we're in the right directory
cd ~/agentbeats_tutorials

# Source environment
source ~/.bashrc

# Check if environment variables are set
if [ -z "$OPENROUTER_API_KEY" ]; then
    echo "❌ OPENROUTER_API_KEY not set!"
    echo "Run: export OPENROUTER_API_KEY=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"
    exit 1
fi

echo "✅ Environment variables configured"

# Get external IP
EXTERNAL_IP=$(curl -s http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip -H "Metadata-Flavor: Google")
echo "📍 External IP: $EXTERNAL_IP"

echo "🚀 Starting Template Injection Agent..."
echo "   Launcher: http://$EXTERNAL_IP:9010"
echo "   Agent: http://$EXTERNAL_IP:9011"

# Start the agent
agentbeats run template_injection_agent_card.toml \
            --launcher_host 0.0.0.0 \
            --launcher_port 9010 \
            --agent_host 0.0.0.0 \
            --agent_port 9011 \
            --backend "http://nuggets.puppy9.com:9000" \
            --tool template_injection_agent_tools.py \
            --model_type openrouter \
            --model_name x-ai/grok-3-mini