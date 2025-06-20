# Usar imagen más ligera de Python
FROM python:3.11-slim

# Variables de entorno para optimización
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Instalar dependencias del sistema necesarias para PDF processing
RUN apt-get update && apt-get install -y \
    poppler-utils \
    libpoppler-dev \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Crear directorio de trabajo
WORKDIR /app

# Copiar requirements primero para aprovechar cache de Docker
COPY requirements.txt .

# Instalar dependencias de Python
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copiar código de la aplicación
COPY . .

# Crear directorios para archivos temporales
RUN mkdir -p temp_uploads temp_outputs

# Exponer puerto
EXPOSE 8000

# Comando optimizado para Railway
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "2", "--timeout", "120", "--max-requests", "1000", "--max-requests-jitter", "50", "app:app"]
