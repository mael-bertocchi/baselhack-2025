from mistralai import Mistral
from pydantic import BaseModel
from fastapi import FastAPI
from dotenv import load_dotenv
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

# Define endpoint for analyzing crowd opinions
@app.post("/analyze")
def analyze(data: ChatRequest):
    chat_response = client.chat.complete(model=model, messages=[
        {"role": "system", "content": BASE_PROMPT},
        {"role": "user", "content": data.prompt},
    ])

    return {"response": chat_response.choices[0].message.content}
