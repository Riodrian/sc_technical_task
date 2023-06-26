# Use the official Python base image for builder container
FROM python:3.9-slim as builder

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file and application code to the working directory
COPY /src /app

# Install the Python dependencies
RUN pip install --user -r requirements.txt

# Use the official Python base image for app container
FROM python:3.9-slim as app

# Copy the application code and installed modules to the working directory
COPY --from=builder /root/.local /root/.local
COPY --from=builder /app .

# Expose the port on which the microservice will listen
EXPOSE 5000

# Set the entrypoint command to run the microservice
CMD ["python", "app.py"]
