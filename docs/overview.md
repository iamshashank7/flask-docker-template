# Cloud-Ready Flask Template – Overview

## Project Structure
- `app/`: Flask application package
  - `__init__.py`: App factory `create_app(config_overrides=None)` and blueprint registration
  - `main.py`: Creates a module-level `app` for WSGI servers; defines `/health`
  - `routes.py`: Simple blueprint with `/` root endpoint
- `run.py`: Dev entry using the app factory; reads `FLASK_DEBUG` and `PORT`
- `requirements.txt`: Python dependencies (Flask, gunicorn)
- `Dockerfile`: Dev-focused container running Gunicorn on port 5000
- `Dockerfile.multistage`: Production multi-stage image running Gunicorn on port 80
- `README.md`: Usage instructions
- `Makefile`: Convenience targets for building/running dev/prod

## Key Concepts
- **Flask App Factory**: `create_app()` returns a configured Flask instance. Enables flexible config and testing.
- **Blueprints**: `routes.py` defines a `Blueprint` registered under the factory for modular routing.
- **WSGI App Exposure**: `main.py` creates a module-level `app` object for Gunicorn (`app.main:app`).
- **Health Endpoint**: `/health` returns `{"status":"ok"}` for health checks and orchestration.

## Files Explained
### `app/__init__.py`
- Defines `create_app(config_overrides=None)`.
- Registers `routes.bp` blueprint.
- Applies optional configuration overrides.

### `app/main.py`
- Imports `create_app` and instantiates `app`.
- Defines `/health` route.
- Provides `if __name__ == "__main__"` guard for direct execution.

### `app/routes.py`
- Declares `bp = Blueprint("bp", __name__)`.
- Implements `@bp.route("/")` returning a JSON message.

### `run.py`
- Imports and instantiates `app = create_app()`.
- Reads `FLASK_DEBUG` and `PORT` from environment for dev runs.
- Runs `app.run(host="0.0.0.0", port=PORT, debug=FLASK_DEBUG)`.

### `requirements.txt`
- `Flask>=2.2.0`: Web framework.
- `gunicorn>=20.1.0`: WSGI HTTP server for UNIX.

### `Dockerfile`
- Base: `python:3.10-slim`.
- Installs deps from `requirements.txt`.
- Copies source; exposes `5000`.
- Healthcheck: probes `http://localhost:5000/health`.
- CMD: `gunicorn --bind 0.0.0.0:5000 app.main:app --workers 2 --threads 4 --log-level info`.

### `Dockerfile.multistage`
- Stage `builder`: installs build tooling; installs dependencies to `/install`.
- Final stage: copies libraries from `/install` into `/usr/local`.
- Copies app code; exposes `80`.
- Healthcheck: probes `http://localhost:80/health`.
- CMD: `gunicorn --bind 0.0.0.0:80 run:app --workers 2 --threads 4 --log-level info`.

### `Makefile`
- `build`: builds dev image `cloud-ready-flask:dev`.
- `run-3000` / `run-9000`: runs dev mapping host ports 3000/9000 → container 5000.
- `stop-ports`: stops containers bound to common dev/prod ports.
- `build-prod`: builds production image `cloud-ready-flask:prod` using `Dockerfile.multistage`.
- `run-prod`: runs production image mapping host `80` → container `80`.

## How to Run
### Dev
```bash
make stop-ports
make run-3000
# or
make run-9000
```
Visit `http://localhost:3000/` (or `9000`).

### Prod
```bash
make run-prod
```
Visit `http://localhost/`.

## Health Checks
- Dev container healthcheck: queries `http://localhost:5000/health` from inside the container.
- Prod container healthcheck: queries `http://localhost:80/health`.

## Environment Variables
- `FLASK_DEBUG`: `1` enables debug mode in `run.py` (dev runs).
- `PORT`: Overrides dev server port in `run.py` (default `5000`).

## Gunicorn Settings
- `--workers 2`: process workers (increase for CPU-bound workloads).
- `--threads 4`: threads per worker (good for I/O-bound Flask apps).
- `--log-level info`: standard logging verbosity.

## Security & Best Practices
- Use multi-stage for production to reduce image size.
- Do not enable Flask debug in production.
- Prefer environment variables for secrets/config; do not commit `.env`.
- Consider a reverse proxy (e.g., Nginx) and TLS termination in production.

## Troubleshooting
- Port conflicts: use `make stop-ports` or pick alternative host ports.
- Build errors from `pip`: ensure `requirements.txt` contains only valid package lines.
- Runtime import errors: confirm `app.main:app` exists and `app/__init__.py` imports are correct.

## Exporting to PDF
You can export this document to a PDF using `pandoc`:
```bash
sudo apt-get install -y pandoc
cd /home/incredible/flask-docker-template
pandoc docs/overview.md -o CloudReadyFlaskTemplate.pdf
```

Alternatively, use VS Code “Markdown PDF” extension to export `docs/overview.md` to PDF.
