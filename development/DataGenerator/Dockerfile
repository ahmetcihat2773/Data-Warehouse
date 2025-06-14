FROM python:3.9-slim

WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the data generator script
COPY data_generator.py .

# Run the data generator with unbuffered output
CMD ["python", "-u", "data_generator.py"] 