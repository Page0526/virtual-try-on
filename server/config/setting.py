import os 
from pydantic_settings import BaseSettings
from pydantic import Field
from dotenv import load_dotenv


"""
File này lưu các biến môi trường 
"""
load_dotenv()


class Setting(BaseSettings): 

    MONGO_URI: str = Field(..., env="MONGO_URI")
    DATABASE_NAME: str = Field(..., env="DATABASE_NAME")


    class Config: 
        env_file = os.path.join(os.path.dirname(__file__), ".env")
        env_file_encoding = "utf-8"
        case_sensitive = True


setting = Setting()