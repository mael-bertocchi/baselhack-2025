import modules.authentication as authentication
import modules.environment as environment
from contextlib import asynccontextmanager
import modules.prompt as prompt
from typing import Optional
import mistralai
import pydantic
import fastapi
import logging
import json

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Global variables for client and prompt
client: Optional[mistralai.Mistral] = None
prompt_content: Optional[str] = None
MODEL = "mistral-medium-latest"

@asynccontextmanager
async def lifespan(app: fastapi.FastAPI):
    global client, prompt_content
    try:
        logger.info("Initializing application...")
        prompt_content = prompt.get_prompt()
        api_key = environment.get_variable("MISTRAL_API_KEY")
        client = mistralai.Mistral(api_key=api_key)
        logger.info("Application initialized successfully")
    except Exception as ex:
        logger.error(f"Failed to initialize application: {ex}")
        raise
    yield

    logger.info("Shutting down application...")
    prompt_content = None
    client = None

# Initialize the application
app = fastapi.FastAPI(title="BaselHack 2025 - Crowd Opinion Synthesizer Agent", description="AI-powered crowd opinion analysis using Mistral AI", version="1.0.0", lifespan=lifespan)

# Define request and response models
class ChatRequest(pydantic.BaseModel):
    prompt: str = pydantic.Field(..., min_length=1, max_length=10000, description="User prompt for analysis")

class ChatResponse(pydantic.BaseModel):
    response: str = pydantic.Field(..., description="AI-generated response")

class ErrorResponse(pydantic.BaseModel):
    detail: str
    error: str

# Dependency to ensure client is initialized
def get_client() -> mistralai.Mistral:
    if client is None:
        raise fastapi.HTTPException(status_code=503, detail="Service not initialized")
    return client

def get_prompt_content() -> str:
    if prompt_content is None:
        raise fastapi.HTTPException(status_code=503, detail="Prompt not initialized")
    return prompt_content

# Non-streaming endpoint
@app.post("/analyze", response_model=ChatResponse, responses={
    503: {"model": ErrorResponse, "description": "Service unavailable"},
    500: {"model": ErrorResponse, "description": "Internal server error"}
})

def analyze(data: ChatRequest, token_payload: dict = fastapi.Depends(authentication.jwt_required), mistral_client: mistralai.Mistral = fastapi.Depends(get_client), system_prompt: str = fastapi.Depends(get_prompt_content)):
    try:
        logger.info(f"Processing analysis request for user: {token_payload.get('sub', 'unknown')}")

        chat_response = mistral_client.chat.complete(model=MODEL, messages=[
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": data.prompt},
        ])

        response_content = chat_response.choices[0].message.content
        logger.info("Analysis completed successfully")

        return ChatResponse(response=response_content)
    except mistralai.SDKError as ex:
        detail = getattr(ex, "http_res_text", None) or str(ex)
        logger.error(f"Mistral API error: {detail}")
        raise fastapi.HTTPException(status_code=503, detail=f"Upstream service error: {detail}")
    except Exception as ex:
        logger.error(f"Unexpected error in analyze: {ex}", exc_info=True)
        raise fastapi.HTTPException(status_code=500, detail="An unexpected error occurred")

# Streaming endpoint
@app.post("/analyze/stream", responses={
    200: {"description": "Server-Sent Events stream"},
    503: {"model": ErrorResponse, "description": "Service unavailable"},
    500: {"model": ErrorResponse, "description": "Internal server error"}
})

def analyze_stream(data: ChatRequest, token_payload: dict = fastapi.Depends(authentication.jwt_required), mistral_client: mistralai.Mistral = fastapi.Depends(get_client), system_prompt: str = fastapi.Depends(get_prompt_content)):
    def generate():
        try:
            logger.info(f"Processing streaming analysis for user: {token_payload.get('sub', 'unknown')}")

            stream_response = mistral_client.chat.stream(model=MODEL, messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": data.prompt},
            ])

            for chunk in stream_response:
                try:
                    if (hasattr(chunk, 'data') and hasattr(chunk.data, 'choices') and len(chunk.data.choices) > 0 and hasattr(chunk.data.choices[0], 'delta') and hasattr(chunk.data.choices[0].delta, 'content') and chunk.data.choices[0].delta.content):

                        content = chunk.data.choices[0].delta.content
                        yield f"data: {json.dumps({'content': content})}\n\n"
                except AttributeError as ex:
                    logger.warning(f"Skipped malformed chunk: {ex}")
                    continue
                except Exception as ex:
                    logger.warning(f"Error processing chunk: {ex}")
                    continue

            logger.info("Streaming analysis completed successfully")
            yield f"data: {json.dumps({'done': True})}\n\n"
        except mistralai.SDKError as ex:
            detail = getattr(ex, "http_res_text", None) or str(ex)
            logger.error(f"Mistral API error during streaming: {detail}")

            error_data = {
                'error': 'upstream_service_error',
                'detail': detail,
                'fatal': True
            }
            yield f"data: {json.dumps(error_data)}\n\n"
        except Exception as ex:
            logger.error(f"Unexpected error during streaming: {ex}", exc_info=True)

            error_data = {
                'error': 'internal_error',
                'detail': 'An unexpected error occurred',
                'fatal': True
            }
            yield f"data: {json.dumps(error_data)}\n\n"

    return fastapi.responses.StreamingResponse(generate(), media_type="text/event-stream", headers={
        "Cache-Control": "no-cache",
        "Connection": "keep-alive",
        "X-Accel-Buffering": "no"
    })

# Health check endpoint
@app.get("/health")
def health_check():
    return {
        "status": "healthy",
        "service": "crowd-opinion-synthesizer",
        "client_initialized": client is not None,
        "prompt_initialized": prompt_content is not None
    }
