from . import create_app

app = create_app()

@app.route("/health")
def health():
    return {"status": "ok"}

if __name__ == "__main__":
   
    import os
    debug = os.environ.get("FLASK_DEBUG", "0") == "1"
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", 5000)), debug=debug)
