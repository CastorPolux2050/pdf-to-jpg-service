FROM python:3.10-slim-buster

# Install poppler and other dependencies
RUN apt-get update && apt-get install -y poppler-utils libglib2.0-0 libsm6 libxext6 libxrender-dev

# Set up working directory
WORKDIR /app

# Copy the application code
COPY . /app

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose the port
EXPOSE 8000

# Run the application
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
