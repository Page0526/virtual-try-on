# config/setting.py
from pydantic_settings import BaseSettings
from pydantic import Field
import os
from dotenv import load_dotenv

load_dotenv()


class Settings(BaseSettings):
    """Cấu hình ứng dụng Easyfit Backend API."""

    # Cấu hình Supabase
    SUPABASE_URL: str = Field(..., env="SUPABASE_URL", description="URL của Supabase project")
    SUPABASE_KEY: str = Field(..., env="SUPABASE_KEY", description="API Key của Supabase")
    SUPABASE_JWT_SECRET: str = Field(..., env="SUPABASE_JWT_SECRET", description="JWT Secret để giải mã token từ Supabase Auth")
    SUPABASE_DB_NAME: str = Field(default="postgres", env="SUPABASE_DB_NAME", description="Tên database trong Supabase")

    # Cấu hình Qdrant (Vector Database)
    QDRANT_HOST: str = Field(default="localhost", env="QDRANT_HOST", description="Host của Qdrant server")
    QDRANT_API_KEY: str | None = Field(default=None, env="QDRANT_API_KEY", description="API Key của Qdrant, tùy chọn")

    # Cấu hình chung
    ENVIRONMENT: str = Field(default="development", env="ENVIRONMENT", description="Môi trường chạy ứng dụng (development/production)")
    DEBUG: bool = Field(default=True, env="DEBUG", description="Chế độ debug, bật trong môi trường phát triển")
    LOG_LEVEL: str = Field(default="INFO", env="LOG_LEVEL", description="Mức độ logging (DEBUG, INFO, WARNING, ERROR, CRITICAL)")
    
    GOOGLE_API_KEY: str = Field(..., env="GOOGLE_API_KEY", description="API Key của Gemini")


    # # setting model 

    # GEMINI_APIKEY = os.getenv("GEMINI_APIKEY")
    # VISION_GEMINI = "gemini-2.0-flash-exp-image-generation"
    # GEMINI_MODEL = "gemini-2.0-flash"

    # # tool search 
    # GOOGLE_API_KEY = os.getenv("GOOGLE_API_KEY")
    # GOOGLE_CSE_ID = os.getenv("GOOGLE_CSE_ID")

    # TOOL_TIMEOUT = 30 
    # HISTORY_TOKEN_LIMIT = 1000



    class Config:
        # Đường dẫn tới file .env nằm cùng thư mục với config
        env_file = os.path.join(os.path.dirname(__file__), ".env")
        env_file_encoding = "utf-8"
        case_sensitive = True

# Khởi tạo đối tượng settings
settings = Settings()