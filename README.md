# BaselHack 2025

This repository contains our work for the BaselHack 2025 event. We selected the Endress+Hauser sponsored challenge focused on developing an application to create surveys, gather people's opinions, and analyze the results with AI.

## Project Overview

We have developed the backend with Fastify and the frontend with Flutter. The application allows users to create surveys, distribute them, and analyze the collected data using AI techniques. We also have developed an AI agent to assist users in generating survey questions based on specific topics.

## Environment Configuration

Each component has its own `.env.example` file. Copy the appropriate file next to it, rename it to `.env`, and fill in the required values before running the app:

- `code/.env.example` → `code/.env`: shared variables for Docker Compose (e.g., `MISTRAL_API_KEY`, default admin credentials, port overrides).
- `code/backend/.env.example` → `code/backend/.env`: Fastify API configuration (Mongo URI, JWT expirations/secrets, agent URL, optional default admin fields).
- `code/agent/.env.example` → `code/agent/.env`: Python agent settings (Mistral API key, expected JWT issuer/audience, path to the backend public key).

Secrets expected at runtime:

- `code/secrets/public_key.pem`: backend public key used by the agent.
- `code/secrets/private_key.pem`: backend private key used to sign requests towards the agent.

Sample `.env` files with development defaults are already provided (`code/.env`, `code/backend/.env`, `code/agent/.env`). Adjust them as needed or rebuild them from the corresponding `*.env.example`. Compose variables like `DB_URI`, `AGENT_AUTHENTICATION_PRIVATE_KEY_PATH`, or `AGENT_AUTHENTICATION_PUBLIC_KEY_PATH` let you point services at external infrastructure when required. Once the environment files are in place, you can start the full stack from the `code/` directory:

```bash
cp code/.env.example code/.env
cp code/backend/.env.example code/backend/.env
cp code/agent/.env.example code/agent/.env
# populate the files with your values, then:
docker compose up --build
```

## Contributors

- [Enzo Lorenzini](https://github.com/Enzolorenzini)
- [Mael Bertocchi](https://github.com/mael-bertocchi)
- [Matteo Tutti](https://github.com/matteoepitech)
- [Maxime Entz](https://github.com/MaxEntz)
- [Yann Toison-Chabane](https://github.com/NeuralProg)
- [Romain Schmitz](https://github.com/r-schmitz11)
- [Matthias Yildirim](https://github.com/Rimapus)
- [Matteo Bianchi](https://github.com/WaterDev-25)
