import pandas as pd
import psycopg2
from sqlalchemy import create_engine

metadata_df = pd.read_csv('../processed_data/metadata.csv')
images_df = pd.read_csv('../processed_data/base64.csv')

# database name = postgres, password = 12345
engine = create_engine('postgresql+psycopg2://postgres:12345@localhost:5432/postgres')

metadata_df.to_sql('metadata', engine, if_exists='append', index=False)
images_df.to_sql('images', engine, if_exists='append', index=False)
