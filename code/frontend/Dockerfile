FROM debian:bookworm-slim AS flutter-sdk

ARG FLUTTER_VERSION=3.35.7

ENV FLUTTER_HOME=/opt/flutter \
    PATH=/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:$PATH \
    PUB_CACHE=/opt/flutter/.pub-cache

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    unzip \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

RUN curl -L "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" -o /tmp/flutter.tar.xz \
    && tar -xJf /tmp/flutter.tar.xz -C /opt \
    && rm /tmp/flutter.tar.xz
RUN git config --global --add safe.directory /opt/flutter
RUN flutter config --no-analytics && flutter precache --web

FROM flutter-sdk AS builder
WORKDIR /app

COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .
ARG API_URL=/api
RUN printf "API_URL=%s\n" "${API_URL}" > .env
RUN flutter build web --release

FROM nginx:1.27-alpine AS runner

COPY --from=builder /app/build/web /usr/share/nginx/html

RUN rm /etc/nginx/conf.d/default.conf && \
    printf 'server {\n    listen 80;\n    server_name _;\n    root /usr/share/nginx/html;\n\n    location / {\n        try_files $uri $uri/ /index.html;\n    }\n\n    location /assets/ {\n        try_files $uri =404;\n        add_header Cache-Control "no-store";\n    }\n}\n' > /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
