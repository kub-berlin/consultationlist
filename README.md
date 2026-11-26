# consultationlist

## Concept

We are starting a new project here to do the following:

1. **Consultation table:** We create a table for KuB's daily business of managing legal consultation appointments. The table structure can be hardcoded at first, so it does not need to be changeable in the frontend for now. In the future, we could add an admin user who can change the table structure in the frontend if needed.
2. **Editor role:** An editor can add, edit and delete rows and change the sorting order in the frontend.
3. **Viewer role:** A viewer has view-only permissions.
4. **Authentication:** Later we want to add SSO authentication.
5. **Concurrent editing:** Several devices can be logged in with the same user account. The simplest workflow for now:
   - The user on one device enters the edit mode.
   - All other devices see a message that the edit mode is already active and temporarily not available.
   - Changes are synced live and are visible to all editors on different devices.
   - The edit mode is left after 30 seconds of inactivity.
   - Viewers see the changes only after the editor has left the edit mode.

See the [developer README](./README.dev.md) for the technology stack, testing and implementation plan.

## Local development

The current setup runs the Django backend and nginx; the Vue frontend is not
implemented yet. Use fictional data only, and do not use this configuration in
production. Editor/viewer permissions and the editing lock are not implemented.

### Prerequisites

- Docker with Compose and Compose Watch, and Make.
- Python 3.14 and [uv](https://docs.astral.sh/uv/) for local management commands,
  linting and tests. The Docker image includes its own Python environment.

Run the following commands from the repository root unless stated otherwise.

### Configuration and startup

The checked-in `.env.dev` contains development-only settings. Compose injects
these into the backend; do not use its key or settings in production.
`.env.test` is used by the local test command. Keep production secrets in an
ignored `.env` file and never commit real consultation data.

Start the development stack:

```sh
make dev
```

The backend runs migrations and collects static files at startup. In another
terminal, create an admin account:

```sh
docker compose -f docker-compose.dev.yml exec backend consultationlist createsuperuser
```

For other Django management commands, use the same wrapper, for example:

```sh
docker compose -f docker-compose.dev.yml exec backend consultationlist check
```

Create migrations locally, rather than inside the container, so their files can
be committed. (see make commands)

Open [the admin](http://localhost:1234/admin/) and sign in. The authenticated
API is available at [http://localhost:1234/api/v1/](http://localhost:1234/api/v1/).

Press Ctrl+C to stop the stack. The database, collected static files and logs
remain in the `consultationlist-data` Docker volume.

### Django commands and checks

For local management commands, install the locked dependencies and select the
development settings file:

```sh
export CONSULTATIONLIST_ENV_FILE="$PWD/.env.dev"
cd backend
uv sync --locked
uv run python manage.py check
uv run python manage.py migrate
```

The exported path applies to that terminal session. Local commands use
`backend/data/` by default, separate from the Docker volume. Create migrations
from the repository root with `make makemigrations`, then rebuild the stack so
the container receives the new files and applies them at startup.

From the repository root:

```sh
make lint  # Check formatting and lint rules
make ruff  # Format and apply lint fixes
make test  # Run pytest with .env.test
make makemigrations  # Create migrations locally using .env.dev
```

The default test target excludes tests marked `wip` and treats no tests collected
as success. `make test-only` runs tests marked `only`.
