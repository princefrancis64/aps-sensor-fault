import pymongo
import json
import pandas as pd
from sensor.config import mongo_client

# Provide the mongodb localhost url to connect python to mongodb.
# client = pymongo.MongoClient("mongodb://localhost:27017/neurolabDB")
client = mongo_client

DATA_FILE_PATH = "/config/workspace/aps_failure_training_set1.csv"
DATABASE_NAME="aps"
COLLECTION_NAME="sensor"

if __name__=="__main__":
    df = pd.read_csv(DATA_FILE_PATH)

    #Convert dataframe to json to dump the records into mongodb
    df.reset_index(drop = True,inplace = True)
    json_record = list(json.loads(df.T.to_json()).values())


    #insert converted json record to mongodb
    client[DATABASE_NAME][COLLECTION_NAME].insert_many(json_record)


