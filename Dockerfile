# Use a minimal Python image
FROM python:3.10-slim

# -----------------------------
# Set environment variables
# -----------------------------
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# -----------------------------
# Install system dependencies
# -----------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        nano \
        git \
    && rm -rf /var/lib/apt/lists/*

# -----------------------------
# Set working directory
# -----------------------------
WORKDIR /app

# -----------------------------
# Copy project files into the container
# -----------------------------
COPY . .

# -----------------------------
# Install Python dependencies
# -----------------------------
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# -----------------------------
# Set Flask environment variables
# -----------------------------
ENV FLASK_APP=app/main.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_ENV=development

# Optional: Copy .env if needed
# COPY .env .env

# -----------------------------
# Expose Flask default port
# -----------------------------
EXPOSE 5000

# -----------------------------
# Run the Flask app
# -----------------------------
CMD ["flask", "run"]
