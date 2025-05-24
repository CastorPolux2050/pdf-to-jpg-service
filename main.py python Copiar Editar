from fastapi import FastAPI, File, UploadFile
from fastapi.responses import JSONResponse
from pdf2image import convert_from_bytes
import base64
from io import BytesIO

app = FastAPI()

@app.post("/convert")
async def convert_pdf(file: UploadFile = File(...)):
    content = await file.read()
    images = convert_from_bytes(content)          # convierte cada página a PIL.Image

    encoded_images = []
    for img in images:
        buf = BytesIO()
        img.save(buf, format="JPEG", quality=90)  # guardá como JPG
        encoded_images.append(base64.b64encode(buf.getvalue()).decode())

    return JSONResponse({"images": encoded_images})
