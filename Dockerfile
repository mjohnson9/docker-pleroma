FROM elixir:1.11.4-alpine

ARG PLEROMA_VER=v2.4.4
ARG UID=911
ARG GID=911
ENV MIX_ENV=prod
ENV OAUTH_CONSUMER_STRATEGIES="keycloak:ueberauth_keycloak_strategy"

RUN apk update \
    && apk add git gcc g++ musl-dev make cmake file-dev \
    exiftool imagemagick libmagic ncurses postgresql-client ffmpeg

RUN addgroup -g ${GID} pleroma \
    && adduser -h /pleroma -s /bin/false -D -G pleroma -u ${UID} pleroma

ARG DATA=/var/lib/pleroma
RUN mkdir -p /etc/pleroma \
    && chown -R pleroma /etc/pleroma \
    && mkdir -p ${DATA}/uploads \
    && mkdir -p ${DATA}/static \
    && chown -R pleroma ${DATA}

USER pleroma
WORKDIR /pleroma

RUN git clone --depth=1 -b "${PLEROMA_VER}" https://git.pleroma.social/pleroma/pleroma.git /pleroma

RUN echo "import Mix.Config" > config/prod.secret.exs \
    && mix local.hex --force \
    && mix local.rebar --force \
    && mix deps.get --only prod \
    && mkdir release \
    && mix release --path /pleroma

COPY ./config.exs /etc/pleroma/config.exs

EXPOSE 4000

ENTRYPOINT ["/pleroma/docker-entrypoint.sh"]
