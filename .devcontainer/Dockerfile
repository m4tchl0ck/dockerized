FROM m4tchl0ck/dev-dotnet:0.0.5

RUN apk add --no-cache \
  bash \
  coreutils \
  procps \
  socat \
  git \
  openssh-client \
  gnupg \
  gnupg-scdaemon \
  pinentry \
  pcsc-lite \
  pcsc-lite-libs \
  ccid

# Configure GPG - disable auto-start so socat forwarding socket is used instead
RUN mkdir -p /root/.gnupg && \
  chmod 700 /root/.gnupg && \
  echo "no-autostart" >> /root/.gnupg/gpg.conf

# Create startup script for YubiKey
RUN echo '#!/bin/bash' > /usr/local/bin/setup-yubikey.sh && \
  echo 'mkdir -p /run/pcscd' >> /usr/local/bin/setup-yubikey.sh && \
  echo 'pcscd' >> /usr/local/bin/setup-yubikey.sh && \
  echo 'gpg-connect-agent updatestartuptty /bye > /dev/null 2>&1' >> /usr/local/bin/setup-yubikey.sh && \
  chmod +x /usr/local/bin/setup-yubikey.sh