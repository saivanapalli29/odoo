# Use an official Python base image
FROM python:3.11

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    ODOO_VERSION=custom \
    ODOO_USER=odoo

# Set the working directory
WORKDIR /odoo

# Copy the requirements file
COPY requirements.txt /odoo/requirements.txt

# Install system dependencies required by Odoo
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    python3-dev \
    libxml2-dev \
    libxslt1-dev \
    libldap2-dev \
    libsasl2-dev \
    libssl-dev \
    libjpeg-dev \
    zlib1g-dev \
    libpq-dev \
    wget \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Install Odoo dependencies
RUN pip install --upgrade pip setuptools wheel && \
    pip install -r requirements.txt

# Copy the project files into the container
COPY . /odoo

# Set the entrypoint to the Odoo binary
ENTRYPOINT ["./odoo-bin"]

# Default command to run the Odoo server
CMD ["--addons-path=addons", "--db-filter=^odoo$", "--dev=reload"]

# Expose the Odoo port
EXPOSE 8069
