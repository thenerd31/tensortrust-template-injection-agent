#!/bin/bash

# Test Cloud Agent Script

set -e

# Get external IP
EXTERNAL_IP=$(curl -s http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip -H "Metadata-Flavor: Google")

echo "🧪 Testing Template Injection Agent"
echo "==================================="
echo "External IP: $EXTERNAL_IP"

# Test locally first
echo "📍 Testing locally..."
cd ~/agentbeats_tutorials
python test_red_agent.py --launcher_url="http://localhost:9010" --agent_url="http://localhost:9011"

echo ""
echo "🌐 Testing external access..."
python test_red_agent.py --launcher_url="http://$EXTERNAL_IP:9010" --agent_url="http://$EXTERNAL_IP:9011"

echo ""
echo "✅ Agent ready for registration on AgentBeats!"
echo "   Launcher URL: http://$EXTERNAL_IP:9010"
echo "   Agent URL: http://$EXTERNAL_IP:9011"