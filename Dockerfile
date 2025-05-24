FROM python:3.10-slim

# Dependencias de sistema para pdf2image
RUN apt-get update && \
    apt-get install -y poppler-utils libglib2.0-0 libsm6 libxext6 libxrender-dev && \
    pip install --upgrade pip

# Copiar código
WORKDIR /app
COPY . /app

# Instalar libs Python
RUN pip install -r requirements.txt

EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
