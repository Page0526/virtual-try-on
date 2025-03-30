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


    # Gemini API settings
    GEMINI_APIKEY: str | None = Field(default=None, env="GEMINI_APIKEY", description="API Key for Gemini AI models")
    VISION_GEMINI: str = Field(default="gemini-2.0-flash-exp-image-generation", description="Gemini model for vision tasks")
    GEMINI_MODEL: str = Field(default="gemini-2.0-flash", description="Default Gemini model for text tasks")
    GEMINI_EMBEDDING_MODEL: str = Field(default="models/embedding-001", description="Gemini model for embedding tasks")

    # Google Search settings
    GOOGLE_API_KEY: str | None = Field(default=None, env="GOOGLE_API_KEY", description="Google API key for search functionality")
    GOOGLE_CSE_ID: str | None = Field(default=None, env="GOOGLE_CSE_ID", description="Google Custom Search Engine ID")

    # Tool settings
    TOOL_TIMEOUT: int = Field(default=30, description="Timeout in seconds for external tool calls")
    HISTORY_TOKEN_LIMIT: int = Field(default=1000, description="Maximum number of tokens to store in conversation history")
    MAX_ITERATIONS: int = Field(default=3, description="Maximum number of iterations for the agent to perform")



    class Config:
        # Đường dẫn tới file .env nằm cùng thư mục với config
        env_file = os.path.join(os.path.dirname(__file__), ".env")
        env_file_encoding = "utf-8"
        case_sensitive = True

# Khởi tạo đối tượng settings
settings = Settings()