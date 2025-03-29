# main.py
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from api.user import router as user_router
from api.tryon import router as tryon_router
from api.product import router as product_router
from config.setting import settings
import logging
from api.chat import router as chat_router

# Thiết lập logging từ settings
logging.basicConfig(level=settings.LOG_LEVEL if hasattr(settings, "LOG_LEVEL") else "INFO")
logger = logging.getLogger(__name__)

# Khởi tạo ứng dụng FastAPI
app = FastAPI(
    title="Easyfit Backend API",
    description="API for Easyfit Backend",
    version="0.0.1",
)

# Thêm middleware CORS (nếu cần)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Có thể thay bằng danh sách cụ thể (e.g., ["http://localhost:3000"])
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Hàm khởi động
async def startup_event():
    """Xử lý khi ứng dụng khởi động."""
    logger.info("Easyfit Backend API đã khởi động thành công")

# Hàm tắt ứng dụng (tùy chọn)
async def shutdown_event():
    """Xử lý khi ứng dụng tắt."""
    logger.info("Easyfit Backend API đang tắt")

# Thêm event handler
app.add_event_handler("startup", startup_event)
app.add_event_handler("shutdown", shutdown_event)

# Thêm router
app.include_router(user_router)
app.include_router(tryon_router)
app.include_router(product_router)
app.include_router(chat_router)

# Endpoint kiểm tra API
@app.get("/", summary="Kiểm tra trạng thái API", description="Trả về thông báo API đang chạy.")
async def read_root():
    return {"message": "Easyfit Backend API is running"}