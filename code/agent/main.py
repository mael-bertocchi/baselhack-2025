from fastapi.responses import StreamingResponse
from pydantic import BaseModel
from dotenv import load_dotenv
from mistralai import Mistral
from fastapi import FastAPI
import json
import os

# Load environment variables
load_dotenv()

# Find the base prompt file
BASE_PROMPT_PATH = os.path.join(os.path.dirname(__file__), "assets", "prompt.txt")

# Load the base prompt from file
try:
    with open(BASE_PROMPT_PATH, "r", encoding="utf-8") as _f:
        BASE_PROMPT = _f.read().strip()
        if not BASE_PROMPT:
            BASE_PROMPT = "You are an AI that synthesizes crowd opinions."
except Exception:
    BASE_PROMPT = "You are an AI that synthesizes crowd opinions."

# Initialize the application
app = FastAPI(title="BaselHack 2025 - Crowd Opinion Synthesizer Agent")

# Initialize Mistral client
api_key = os.getenv("MISTRAL_API_KEY")
client = Mistral(api_key=api_key)
model = "mistral-medium-latest"

# Define request model
class ChatRequest(BaseModel):
    prompt: str

# Non-streaming endpoint
@app.post("/analyze")
def analyze(data: ChatRequest):
    chat_response = client.chat.complete(model=model, messages=[
        {"role": "system", "content": BASE_PROMPT},
        {"role": "user", "content": data.prompt},
    ])

    return {"response": chat_response.choices[0].message.content}

# Streaming endpoint
@app.post("/analyze/stream")
def analyze_stream(data: ChatRequest):
    def generate():
        stream_response = client.chat.stream(model=model, messages=[
            {"role": "system", "content": BASE_PROMPT},
            {"role": "user", "content": data.prompt},
        ])

        for chunk in stream_response:
            if chunk.data.choices[0].delta.content:
                content = chunk.data.choices[0].delta.content
                yield f"data: {json.dumps({'content': content})}\n\n"

        yield f"data: {json.dumps({'done': True})}\n\n"

    return StreamingResponse(generate(), media_type="text/event-stream")
