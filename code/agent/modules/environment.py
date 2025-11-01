import dotenv
import os

# Load environment variables
dotenv.load_dotenv()

# Helper function to get environment variables with error handling
def get_variable(key: str, default: str = None) -> str:
    variable = os.getenv(key, default)
    if variable is None:
        raise EnvironmentError(f"Environment variable '{key}' is not set.")
    return variable
