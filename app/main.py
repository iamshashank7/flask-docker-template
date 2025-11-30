from . import create_app

# Provide a top-level `app` object for WSGI servers (gunicorn/uwsgi). We import
# the factory from the package and create a runtime app instance here.
app = create_app()

@app.route("/health")
def health():
    return {"status": "ok"}

if __name__ == "__main__":
    # Only enable debug with an env var; avoid accidental debug in production
    import os
    debug = os.environ.get("FLASK_DEBUG", "0") == "1"
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", 5000)), debug=debug)