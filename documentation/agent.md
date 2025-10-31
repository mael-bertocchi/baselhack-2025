# BaselHack 2025 - Crowd Opinion Synthesizer Agent

This agent uses the Mistral AI model to analyze and summarize public opinions on various topics. It is built with FastAPI for easy deployment and interaction.

## Configuration

The agent requires a Mistral API key for authentication. You can set this key in your environment variables or in a `.env` file.

## Installation

1. Navigate to the `code/agent` directory.

2. Create and activate a virtual environment:

```bash
python3 -m venv .venv && source .venv/bin/activate
```

3. Install the required dependencies:

```bash
pip install -r requirements.txt
```

## Running the Agent

To start the FastAPI server, run:

```bash
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```
