FROM m4tchl0ck/dev-base:latest

# Add Microsoft apt repo (.NET)
RUN install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/debian/12/prod bookworm main" \
       > /etc/apt/sources.list.d/microsoft.list

RUN apt-get update && apt-get install -y --no-install-recommends \
    dotnet-sdk-10.0 \
    && rm -rf /var/lib/apt/lists/*
