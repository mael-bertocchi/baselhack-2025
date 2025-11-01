import os

BASE_PROMPT_PATH = os.path.join(os.path.dirname(__file__), "assets", "prompt.txt")

# Load the base prompt from file
def get_prompt() -> str:
    try:
        with open(BASE_PROMPT_PATH, "r", encoding="utf-8") as _f:
            prompt = _f.read().strip()
            if not prompt:
                return "You are an AI that synthesizes crowd opinions."
    except Exception:
        return "You are an AI that synthesizes crowd opinions."
    return prompt
