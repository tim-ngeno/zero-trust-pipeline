# Using a specific digest instead of 'latest' ensures the image doesn't change unexpectedly
FROM python@sha256:25ec71a3df55517ab5f6f2fcd0e45b8dba3d197faf0ef2e5611a9a8bbd495c1e
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

# Run as a non-root user
USER 1000
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]