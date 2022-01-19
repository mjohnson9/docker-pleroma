FROM elixir:1.11.2-alpine

ENV UID=911 GID=911 \
    MIX_ENV=prod

ARG PLEROMA_VER=stable

RUN apk -U upgrade \
    && apk add --no-cache \
    build-base \
    cmake \
    git \
    file-dev

RUN addgroup -g ${GID} pleroma \
    && adduser -h /pleroma -s /bin/sh -D -G pleroma -u ${UID} pleroma

USER pleroma
WORKDIR /pleroma

RUN git clone -b stable https://git.pleroma.social/pleroma/pleroma.git /pleroma \
    && git checkout ${PLEROMA_VER}

COPY config/secret.exs /pleroma/config/prod.secret.exs

RUN mix local.hex --force \
    && mix local.rebar --force \
    && mix deps.get --only prod \
    && mkdir release \
    && mix release --path /pleroma || mix deps.get --only prod \
    && mix release --path /pleroma

VOLUME /pleroma/uploads/

CMD ["mix", "phx.server"]
