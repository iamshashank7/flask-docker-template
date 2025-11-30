# Flask Docker Template

Minimal Flask app scaffold with:
- factory pattern
- gunicorn production entry
- multi-stage Dockerfile for small images

## Run locally (dev)
1. python -m venv venv
2. source venv/bin/activate
3. pip install -r requirements.txt
4. python run.py
Open http://localhost:5000

## Build Docker image (dev)
docker build -t cloud-ready-flask:dev -f Dockerfile .

## Build production image (multi-stage)
docker build -t cloud-ready-flask:prod -f Dockerfile.multistage .

## Run container (prod)
docker run --rm -p 80:80 cloud-ready-flask:prod

## Push to GitHub
Create repo, then:
git remote add origin git@github.com:YOURUSER/flask-docker-template.git
git push -u origin main

## Notes
- Use the multistage image + gunicorn for production.
- Healthchecks are built-in for both images (`/health`).
- Configure via env: `FLASK_DEBUG=1` for debug; `PORT` for dev run.py.
- Add environment-based config and secrets (don't commit `.env`).# flask-docker-template
