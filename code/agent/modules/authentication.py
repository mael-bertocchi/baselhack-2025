from fastapi import HTTPException, Request
import modules.environment as environment
from typing import Any, Dict
import jwt

# Configuration via environment variables
AGENT_AUTHENTICATION_PUBLIC_KEY_PATH = environment.get_variable("AGENT_AUTHENTICATION_PUBLIC_KEY_PATH")
EXPECTED_ISS = environment.get_variable("EXPECTED_ISS", "fastify-api")
EXPECTED_AUD = environment.get_variable("EXPECTED_AUD", "python-agent")
LEEWAY = int(environment.get_variable("JWT_LEEWAY_SECONDS", "60"))

def raise_unauthorized(msg: str):
    raise HTTPException(status_code=401, detail=msg)

def verify_jwt(token: str) -> Dict[str, Any]:
    if not AGENT_AUTHENTICATION_PUBLIC_KEY_PATH:
        raise_unauthorized("Public key not configured on agent")

    try:
        with open(AGENT_AUTHENTICATION_PUBLIC_KEY_PATH, "r") as key_file:
            public_key = key_file.read()
        payload = jwt.decode(token, public_key, algorithms=["RS256"], audience=EXPECTED_AUD, issuer=EXPECTED_ISS, leeway=LEEWAY)
        return payload
    except jwt.ExpiredSignatureError:
        raise_unauthorized("Token expired")
    except jwt.InvalidAudienceError:
        raise_unauthorized("Invalid token audience")
    except jwt.InvalidIssuerError:
        raise_unauthorized("Invalid token issuer")
    except jwt.PyJWTError as e:
        raise_unauthorized(f"Invalid token: {str(e)}")

async def jwt_required(request: Request) -> Dict[str, Any]:
    auth = request.headers.get("authorization") or request.headers.get("Authorization")
    if not auth:
        raise_unauthorized("Missing Authorization header")

    if not auth.startswith("Bearer "):
        raise_unauthorized("Invalid Authorization header")

    token = auth.split(" ", 1)[1].strip()
    if not token:
        raise_unauthorized("Empty bearer token")

    payload = verify_jwt(token)
    return payload
