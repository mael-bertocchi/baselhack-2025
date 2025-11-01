# BaselHack 2025 - Crowd Opinion Synthesizer Agent

This agent uses the Mistral AI model to analyze and summarize public opinions on various topics. It is built with FastAPI for easy deployment and interaction.

## Generate keys

To generate a private key for the agent, you can use the following OpenSSL command:

```bash
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:3072 -out private.pem
```

You should also need to create a public key from the private key:

```bash
openssl rsa -in private.pem -pubout -out public.pem
```

## Configuration

The agent requires a Mistral API key for authentication. You can set this key in your environment variables or in a `.env` file.

## Installation

1. Navigate to the `code/agent` directory.

```bash
cd code/agent
```

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
uvicorn main:app --reload
```
