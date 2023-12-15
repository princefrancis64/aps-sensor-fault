FROM python:3.8
USER root 
RUN mkdir /app
COPY . /app/
WORKDIR /app/
RUn pip3 install -r requirements.txt
ENV AIRFLOW_HOME = "/app/airflow"
ENV AIRFLOW_CORE_DAGBAG_IMPORT_TIMEOUT = 1000
ENV AIRFLOW_CORE_ENABLE_XCOM_PICKLING = True
RUn airflow db init
RUN airflow users create -e prince.francis64@gmail.com -f Prince -l Francis -p admin -r Admin -u admin
RUn chmod 777 start.ch
RUn apt update -y && apt install awscli -y
ENTRYPOINT  ["/bin/sh"]
CMD ["start.sh"]