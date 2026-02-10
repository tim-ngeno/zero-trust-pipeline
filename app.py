from fastapi import FastAPI
import pickle
import base64

app = FastAPI()

@app.get("/")
def root():
    """
    """
    return {"message": "Zero-Trust API is running"}

# Vulnerable route
@app.get("/load-note")
def load_note(data: str):
    """Demonstrates insecure deserialization using pickle"""
    decoded_data = base64.b64decode(data)
    note = pickle.loads(decoded_data)
    return {"note": note}
