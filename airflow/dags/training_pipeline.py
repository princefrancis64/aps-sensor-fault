from asyncio import tasks
import json
from textwrap import dedent
import pendulum
import os
from airflow import DAG
from airflow.operators.python import PythonOperator
import logging


with DAG(
    'sensor_training',
    default_args={'retries': 2},
    # [END default_args]
    description='Sensor Fault Detection',
    schedule_interval="@weekly",
    start_date=pendulum.datetime(2024, 4, 1, tz="UTC"),
    catchup=False,
    tags=['example'],
) as dag:

    
    def training(**kwargs):
        from sensor.pipeline.training_pipeline import start_training_pipeline
        start_training_pipeline()
    
    def sync_artifact_to_s3_bucket(**kwargs):
        bucket_name = os.getenv("BUCKET_NAME")
        logging.info(f"{bucket_name}")
        os.system(f"aws s3 sync /app/artifact s3://{bucket_name}/artifact")
        logging.info("1")
        os.system(f"aws s3 sync /app/saved_models s3://{bucket_name}/saved_models")
        logging.info("2")

    training_pipeline  = PythonOperator(
            task_id="train_pipeline",
            python_callable=training

    )

    sync_data_to_s3 = PythonOperator(
            task_id="sync_data_to_s3",
            python_callable=sync_artifact_to_s3_bucket

    )

    training_pipeline >> sync_data_to_s3