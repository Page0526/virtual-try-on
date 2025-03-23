import motor.motor_asyncio
from pymongo import MongoClient 
from pymongo.errors import ConnectionFailure
from config.setting import Setting 

"""
File này connect tới mongodb -> setup db  
"""

db = None 


async def connect_to_mongo():
    global db 

    client = motor.motor_asyncio.AsyncIOMotorClient(Setting.MONGO_URI)
    try: 
        await client.admin.command("ping")
        db = client[Setting.DATABASE_NAME]
        print("Connected to MongoDB")
    except ConnectionFailure: 
        print("Failed to connect to MongoDB")
    except Exception as e:
        print(f"An error occurred: {e}")
        

async def close_mongo_connection():
    global db 

    if db: 
        db.client.close()
        print("MongoDB connection closed")
        db = None 


def get_database(): 
    if db is None: 
        raise Exception("Database connection not established")
    return db 

