# Use Alpine Linux as the base image
FROM alpine:latest

# Set the working directory in the container
WORKDIR /app

# Install curl, Python, and pip
RUN apk add --no-cache curl python3 py3-pip

# Create a virtual environment in the container and activate it
RUN python3 -m venv /venv
ENV PATH="/venv/bin:$PATH"

# Install sqlfluff in the virtual environment
RUN pip install --upgrade pip && pip install sqlfluff

# Download dbmate binary for Linux and install it
RUN curl -fsSL -o /usr/local/bin/dbmate https://github.com/amacneil/dbmate/releases/latest/download/dbmate-linux-amd64 \
    && chmod +x /usr/local/bin/dbmate

# Copy the local files to the container's working directory
COPY . /app

# Your application's run command goes here
# For example, if you have a Python script named main.py, use:
# CMD ["python3", "main.py"]