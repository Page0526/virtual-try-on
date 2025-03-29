# core/supabase.py
from supabase import create_client, Client
from config.setting import settings
import logging

# Khởi tạo logging
logging.basicConfig(level=settings.LOG_LEVEL if hasattr(settings, "LOG_LEVEL") else "INFO")
logger = logging.getLogger(__name__)

# Khởi tạo client Supabase toàn cục
try:
    supabase: Client = create_client(settings.SUPABASE_URL, settings.SUPABASE_KEY)
    logger.info("Successfuly connected to Supabase")
except Exception as e:
    logger.error(f"Error in connection to Supabase: {str(e)}")
    raise

def get_supabase_db() -> Client:
    """Dependency injection để cung cấp Supabase client."""
    if supabase is None:
        raise RuntimeError("Supabase client haven't been initialized")
    return supabase