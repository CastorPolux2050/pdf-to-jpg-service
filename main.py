from fastapi import FastAPI, File, UploadFile
from fastapi.responses import JSONResponse
from pdf2image import convert_from_bytes
import base64
from io import BytesIO
import logging

# Configurar logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

app = FastAPI()

@app.post("/convert")
async def convert_pdf(file: UploadFile = File(...)):
    logging.info("Recibida solicitud en /convert")  # Nuevo log
    try:
        content = await file.read()
        logging.info("PDF leido correctamente")      # Nuevo log
        images = convert_from_bytes(content)

        encoded_images = []
        for img in images:
            buffered = BytesIO()
            img.save(buffered, format="JPEG")
            encoded_images.append(base64.b64encode(buffered.getvalue()).decode("utf-8"))

        logging.info("Conversion a JPG exitosa")     # Nuevo log
        return JSONResponse(content={"images": encoded_images})
    except Exception as e:
        logging.error(f"Error durante la conversion: {e}")  # Nuevo log
        return JSONResponse(content={"error": str(e)}, status_code=500)
