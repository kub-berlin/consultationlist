

FROM ghcr.io/astral-sh/uv:0.13.9 AS uv-bin

FROM python:3.14.10-slim-bookworm AS runtime
ENV APP_NAME=consultationlist
ENV APP_USER=_${APP_NAME}
ENV APP_PATH=/app
ENV DATA_DIR=/var/lib/${APP_NAME}
# upgrade system and remove unneeded packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends adduser \
    && rm -rf /var/lib/apt/lists/*
# configure runtime user
RUN adduser \ 
    --system \ 
    --group \
    --uid 302 \ 
    --home "$DATA_DIR" \
    "$APP_USER"

RUN chown -R "$APP_USER": "$DATA_DIR"

# bootstrap dependencies
WORKDIR $APP_PATH
COPY --from=uv-bin /uv /bin/
COPY ./backend/pyproject.toml ./
COPY ./backend/uv.lock ./
ARG UV_FLAGS=--no-dev
RUN uv sync --no-cache --locked $UV_FLAGS

ENV PYTHONPATH=$APP_PATH
ENV PATH=$APP_PATH/.venv/bin:/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV PYTHONUNBUFFERED=1
# set container runtime settings
COPY --chmod=755 ./backend/container/${APP_NAME}.sh /usr/local/bin/${APP_NAME}
COPY ./backend/ $APP_PATH/.

ENV DJANGO_SETTINGS_MODULE=${APP_NAME}.settings
USER "$APP_USER"
WORKDIR "$DATA_DIR"
ENTRYPOINT ["/usr/local/bin/consultationlist"]
CMD ["uvicorn", "0.0.0.0:8000"]
EXPOSE 8000
