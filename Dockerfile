# Use a minimal Python image (based on Debian)
FROM python:3.10-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install basic system tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    nano \
    iputils-ping \
    net-tools \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy the entire project into the container
COPY . .

# Install Python dependencies
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Expose the port Flask runs on
EXPOSE 5000

# Start the app
CMD ["python", "app/main.py"]
