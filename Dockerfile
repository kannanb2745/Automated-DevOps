# Use a minimal Python base image
FROM python:3.10-slim

# Set environment variables to reduce overhead and improve performance
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    python3-dev \
    curl \
    nano \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set working directory in the container
WORKDIR /app

# Copy dependency and source files
COPY requirements.txt .
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt

# Copy rest of the application code
COPY . .

# Set environment variables for Flask
ENV FLASK_APP=app/main.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_ENV=development

# Install python-dotenv if not already in requirements.txt
RUN pip install python-dotenv

# Optional: Copy .env file if you're not using Docker Compose
COPY .env .env

# Expose the Flask port
EXPOSE 5678

# Run the app
CMD ["flask", "run", "--port=5678"]
