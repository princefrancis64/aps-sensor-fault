FROM python:3.8
# Create a non-root user
RUN useradd -ms /bin/bash princefrancis64
USER princefrancis64

RUN mkdir /app
COPY . /app/
WORKDIR /app/
RUN pip3 install --no-cache-dir -r requirements.txt
ENV AIRFLOW_HOME="/app/airflow"
ENV AIRFLOW__CORE__DAGBAG_IMPORT_TIMEOUT=1000
ENV AIRFLOW__CORE__ENABLE_XCOM_PICKLING=True
RUN airflow db init 
RUN airflow users create  -e prince.francis64@gmail.com -f Prince -l Francis -p admin -r Admin  -u admin
RUN chmod +x start.sh
RUN apt-get update -y && apt-get install -y awscli
ENTRYPOINT ["/bin/sh" ]
CMD ["./start.sh"]