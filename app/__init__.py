from flask import Flask


def create_app(config_overrides=None):
    """Create and configure the Flask app (factory pattern).

    Args:
        config_overrides (dict): optional overrides for app.config for testing/dev.
    """
    app = Flask(__name__)

    # Import and register blueprints 
    from .routes import bp as main_bp
    app.register_blueprint(main_bp)

    # Apply optional config overrides (useful for tests)
    if config_overrides:
        app.config.update(config_overrides)

    return app
