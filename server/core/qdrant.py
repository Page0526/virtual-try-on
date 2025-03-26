# core/qdrant.py
from qdrant_client import QdrantClient
from qdrant_client.http import models
from config.setting import settings
from typing import List, Dict, Any, Optional
import logging

# Khởi tạo logging
logging.basicConfig(level=settings.LOG_LEVEL if hasattr(settings, "LOG_LEVEL") else "INFO")
logger = logging.getLogger(__name__)

# Khởi tạo client Qdrant toàn cục
try:
    qdrant: QdrantClient = QdrantClient(
        url=settings.QDRANT_HOST,
        api_key=settings.QDRANT_API_KEY,
        timeout=10.0
    )
    logger.info("Khởi tạo và kết nối tới Qdrant thành công")
except Exception as e:
    logger.error(f"Lỗi khi khởi tạo client Qdrant: {str(e)}")
    raise

def get_qdrant_db() -> QdrantClient:
    """Dependency injection để cung cấp Qdrant client."""
    if qdrant is None:
        raise RuntimeError("Qdrant client chưa được khởi tạo")
    return qdrant