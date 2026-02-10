from fastapi import FastAPI
import pickle
import base64

app = FastAPI()

@app.get("/")
def root():
    """
    """
    return {"message": "Zero-Trust API is running"}

# # Vulnerable route
# @app.get("/load-note")
# def load_note(data: str):
#     """Demonstrates insecure deserialization using pickle"""
#     decoded_data = base64.b64decode(data)
#     note = pickle.loads(decoded_data)
#     return {"note": note}

# Secure route
@app.get("/load-note")
def load_note(data: str):
    """Uses secure JSON deserialization"""
    try:
        # JSON is data-only and can't execute arbitrary code
        decoded_data = base64.b64decode(data).decode('utf-8')
        note = json.loads(decoded_data)
        return {"note": note}
    except Exception as e:
        return {"error": "Invalid data format"}, 400
