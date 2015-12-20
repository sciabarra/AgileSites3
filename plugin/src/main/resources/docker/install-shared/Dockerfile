FROM owcs-base-oracle
RUN useradd -d /app app
WORKDIR /app
RUN mkdir -p /app/shared && chown -Rv app /app
VOLUME /app/shared
