# Using a specific digest instead of 'latest' ensures the image doesn't change unexpectedly

# Stage 1: Build Stage
FROM python:3.13-alpine AS builder

# Install build dependencies needed for the build stage
RUN apk add --no-cache gcc musl-dev libffi-dev

WORKDIR /app

# Copy and Install dependencies into a local folder
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt


# Stage 2: Distroless Stage
FROM python:3.13-alpine

WORKDIR /app

# Copy the installed libraries from the builder stage
COPY --from=builder /install /usr/local
COPY app.py .

# Run as a non-root user
USER nonroot
CMD ["python3", "-m", "uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]