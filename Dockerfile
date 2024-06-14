# Use an official Python runtime as a parent image, Debian-based, with platform specification for amd64
FROM --platform=linux/amd64 python:3.9-slim

# Update and upgrade the system
RUN apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y

# Install necessary packages
RUN apt-get install -y gnupg2 curl apt-transport-https ca-certificates

# Add Microsoft repository key and list
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list

# Update package list again
RUN apt-get update

# Accept the EULA and install MS ODBC Driver and Firefox ESR
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql18 firefox-esr

# Install unixODBC development package
RUN apt-get install -y unixodbc-dev

# Install build tools (gcc, g++, make)
RUN apt-get install -y build-essential

# Download and install geckodriver
RUN curl -L "https://github.com/mozilla/geckodriver/releases/download/v0.30.0/geckodriver-v0.30.0-linux64.tar.gz" | tar -xz -C /usr/local/bin

# Set the working directory in the container
WORKDIR /FAST_API

# Copy the FastAPI application and other necessary files into the Docker container
COPY . /FAST_API

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Make port 8000 available to the world outside this container
EXPOSE 8000

# Command to run the Uvicorn server
CMD ["uvicorn", "sql_app.main:app", "--host", "0.0.0.0", "--port", "8000"]
