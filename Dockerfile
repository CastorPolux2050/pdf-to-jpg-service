FROM alpine/git as source

# Clone the repo
RUN git clone --depth 1 https://github.com/oschwartz10612/poppler-alpine /tmp/poppler-alpine

# List directory content, to check if the content is correctly cloned
RUN ls -la /tmp/poppler-alpine

FROM python:3.10-slim-buster

# Install poppler
COPY --from=source /tmp/poppler-alpine /usr/src/poppler-alpine
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    libmagic1 \
    gcc \
    make \
    curl \
 && curl -sSL https://raw.githubusercontent.com/oschwartz10612/poppler-alpine/master/poppler.install \
  | sh /dev/stdin \
 && rm -rf /var/lib/apt/lists/*

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
