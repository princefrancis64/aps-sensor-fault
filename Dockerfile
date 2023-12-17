FROM python:3.8

# Create a root user
USER root

RUN mkdir /app
COPY . /app/
WORKDIR /app/

# Install dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

# Set environment variables
ENV AIRFLOW_HOME="/app/airflow"
ENV AIRFLOW__CORE__DAGBAG_IMPORT_TIMEOUT=1000
ENV AIRFLOW__CORE__ENABLE_XCOM_PICKLING=True

# Initialize Airflow database
RUN airflow db init 

# Create Airflow user
RUN airflow users create -e prince.francis64@gmail.com -f Prince -l Francis -p admin -r Admin -u admin

# Allow execution of start.sh
RUN chmod +x start.sh

# Install AWS CLI
RUN apt-get update -y && apt-get install -y awscli

# Specify the default command to run on container startup
ENTRYPOINT ["/bin/sh", "start.sh"]
CMD []
