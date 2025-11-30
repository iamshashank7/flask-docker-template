from app import create_app
import os

app = create_app()

if __name__ == "__main__":
    # Don't enable debug by default for production safety; set via FLASK_DEBUG=1 for local dev
    debug = os.environ.get("FLASK_DEBUG", "0") == "1"
    port = int(os.environ.get("PORT", "5000"))
    app.run(debug=debug, host="0.0.0.0", port=port)