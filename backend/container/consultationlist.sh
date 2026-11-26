#!/bin/sh

set -eu

if [ "${1:-}" = "runserver" ] || [ "${1:-}" = "uvicorn" ]; then
  django-admin migrate --no-input
  django-admin collectstatic --no-input --clear
fi

_is_true() {
  echo "$1" | grep --quiet --ignore-case --extended-regexp '^(1|yes|on|true)$'
}

if [ "${1:-}" = "uvicorn" ]; then
  listen=${2:-0.0.0.0:8000}
  host=$(echo "$listen" | cut -d: -f1)
  port=$(echo "$listen" | cut -d: -f2)
  args=
  if _is_true "${CONSULTATIONLIST_DEBUG:-0}"; then
    args="--reload --reload-dir /app/consultationlist/"
  fi

  exec uvicorn consultationlist.asgi:application $args \
    --lifespan off \
    --host "$host" \
    --port "$port"
else
  exec django-admin "$@"
fi
