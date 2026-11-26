.PHONY: ruff
ruff:
	cd backend && uv run ruff format
	cd backend && uv run ruff check --fix

.PHONY: lint
lint:
	cd backend && uv run ruff format --check .
	cd backend && uv run ruff check .

PYTEST_MARKERS ?= not wip
.PHONY: test
test:
	cd backend && uv sync --group test
	cd backend && CONSULTATIONLIST_ENV_FILE=../.env.test uv run pytest -m "$(PYTEST_MARKERS)" -s || test $$? -eq 5

.PHONY: test-only
test-only:
	$(MAKE) test PYTEST_MARKERS="only"

.PHONY: makemigrations
makemigrations:
	cd backend && CONSULTATIONLIST_ENV_FILE=../.env.dev uv run python manage.py makemigrations

.PHONY: dev
dev:
	docker compose -f docker-compose.dev.yml up --build --watch --force-recreate
	docker compose -f docker-compose.dev.yml down
