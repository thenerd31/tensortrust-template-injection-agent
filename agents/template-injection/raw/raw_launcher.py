#!/usr/bin/env python3
"""
Simple launcher for the Raw Template Injection Agent
A2A protocol requires both launcher and agent endpoints
"""

import asyncio
import json
from fastapi import FastAPI
from contextlib import asynccontextmanager
import uvicorn
import argparse

@asynccontextmanager
async def lifespan(app: FastAPI):
    print("🚀 Raw Agent Launcher Starting...")
    yield
    print("🛑 Raw Agent Launcher Stopping...")

app = FastAPI(lifespan=lifespan)

@app.get("/status")
async def get_status():
    """Return launcher status"""
    return {
        "status": "server up, with agent running",
        "pid": 1337
    }

@app.get("/")
async def root():
    """Root endpoint"""
    return {"message": "Raw Template Injection Launcher"}

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Raw Agent Launcher")
    parser.add_argument("--host", default="0.0.0.0", help="Host to bind to")
    parser.add_argument("--port", type=int, default=9010, help="Port to bind to")
    args = parser.parse_args()
    
    print(f"🚀 Starting Raw Agent Launcher on {args.host}:{args.port}")
    
    uvicorn.run(
        app,
        host=args.host,
        port=args.port,
        access_log=False
    )