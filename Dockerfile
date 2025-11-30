# Base image
FROM python:3.10-slim

# Set work directory
WORKDIR /app

# Install system dependencies (optional)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential && \
    rm -rf /var/lib/apt/lists/*

# Copy project files
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code (copying all files avoids race introduced by copying twice)
COPY . .

# Expose port
EXPOSE 5000
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD python -c "import sys, urllib.request;\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\ntry:\n  urllib.request.urlopen('http://localhost:5000/health', timeout=3); sys.exit(0)\nexcept Exception:\n  sys.exit(1)"

# Run the app
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app.main:app", "--workers", "2", "--threads", "4", "--log-level", "info"]