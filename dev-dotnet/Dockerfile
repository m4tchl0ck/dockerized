FROM m4tchl0ck/dev-base:latest

# Add Microsoft apt repo (.NET)
# The Debian 13 (trixie) prod repo is signed with a key absent from the stale
# keys/microsoft.asc, so take the current key from the official config deb.
RUN install -m 0755 -d /etc/apt/keyrings \
    && . /etc/os-release \
    && curl -fsSL "https://packages.microsoft.com/config/debian/$VERSION_ID/packages-microsoft-prod.deb" -o /tmp/pmp.deb \
    && dpkg-deb --fsys-tarfile /tmp/pmp.deb | tar -xO usr/share/keyrings/microsoft-prod.gpg > /etc/apt/keyrings/microsoft.gpg \
    && rm /tmp/pmp.deb \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/debian/$VERSION_ID/prod $VERSION_CODENAME main" \
       > /etc/apt/sources.list.d/microsoft.list

RUN apt-get update && apt-get install -y --no-install-recommends \
    dotnet-sdk-10.0 \
    && rm -rf /var/lib/apt/lists/*
