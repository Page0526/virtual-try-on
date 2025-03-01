#!/bin/bash
# Setup script for Virtual Try-On Recommendation System

set -e  # Exit on error

echo "Setting up Virtual Try-On Recommendation System..."
echo
# Create virtual environment

# Install dependencies
echo "Installing Python dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Warning: Docker is not installed. It's recommended for running MongoDB and Qdrant."
    echo "Please install Docker from https://docs.docker.com/get-docker/"
else
    # Check if MongoDB and Qdrant containers are running
    echo "Checking if and Qdrant containers are running..."
    
    if ! docker ps | grep -q qdrant; then
        echo "Starting Qdrant container..."
        docker run -p 6333:6333 -v ~/qdrant_data:/qdrant/storage qdrant/qdrant
    else
        echo "Qdrant container is already running."
    fi
fi

# Check if Ollama is installed
if ! command -v ollama &> /dev/null; then
    echo "Warning: Ollama is not installed. It's required for the LLaVA model."
    echo "Please install Ollama from https://ollama.ai/download"
else
    # Check if LLaVA model is available
    echo "Checking if LLaVA model is available..."
    if ! ollama list | grep -q llava; then
        echo "Pulling LLaVA model..."
        ollama pull llava
    else
        echo "LLaVA model is already available."
    fi
    
    # Check if Ollama is running
    if ! ps aux | grep -q "[o]llama serve"; then
        echo "Starting Ollama service..."
        ollama serve &
        sleep 2  # Give it time to start
    else
        echo "Ollama service is already running."
    fi
fi

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "Creating .env file..."
    cat > .env << EOF
# MongoDB connection string
MONGODB_URI=mongodb://localhost:27017

# Qdrant connection
QDRANT_URL=http://localhost:6333
EOF
    echo ".env file created."
else
    echo ".env file already exists."
fi

echo
echo "Setup completed successfully!"
echo
echo "To run the API server:"
echo "  python run_api.py"
echo
echo
echo "Make sure Ollama is running with:"
echo "  ollama serve"
echo "  ollama run llava"