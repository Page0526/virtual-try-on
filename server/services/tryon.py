# services/tryon.py
from core.supabase import Client
from gradio_client import Client as GradioClient, file
from schemas.tryon import TryOnRequest
from fastapi import UploadFile
import logging
import uuid
import tempfile
import os
from contextlib import contextmanager
from typing import Optional  # Thêm import

logging.basicConfig(level="INFO")
logging.getLogger("httpx").setLevel(logging.WARNING)
logger = logging.getLogger(__name__)

class TryOnService:
    GRADIO_URL = "yisol/IDM-VTON"

    @staticmethod
    def get_gradio_client() -> GradioClient:
        """Khởi tạo Gradio Client."""
        try:
            return GradioClient(TryOnService.GRADIO_URL)
        except Exception as e:
            logger.error(f"Lỗi khi kết nối Gradio client: {str(e)}")
            raise

    @staticmethod
    @contextmanager
    def temp_file_manager(suffix=".jpg"):
        """Quản lý file tạm và đảm bảo xóa sau khi sử dụng."""
        temp_file = tempfile.NamedTemporaryFile(delete=False, suffix=suffix)
        try:
            yield temp_file.name
        finally:
            if os.path.exists(temp_file.name):
                os.remove(temp_file.name)

    @staticmethod
    async def process_tryon(
        user_image: UploadFile,
        product_image: UploadFile,
        request: TryOnRequest,
        db: Client,
        user_id: Optional[str] = None  # Làm user_id tùy chọn
    ) -> str:
        """Xử lý thử đồ và trả về URL công khai."""
        try:
            # Đọc nội dung ảnh
            user_image_data = await user_image.read()
            product_image_data = await product_image.read()
            logger.info(f"Đã đọc ảnh: user={len(user_image_data)} bytes, product={len(product_image_data)} bytes")

            # Tạo file tạm
            with TryOnService.temp_file_manager() as user_temp_path:
                with open(user_temp_path, "wb") as f:
                    f.write(user_image_data)
                with TryOnService.temp_file_manager() as product_temp_path:
                    with open(product_temp_path, "wb") as f:
                        f.write(product_image_data)
                    logger.info(f"File tạm: user={user_temp_path}, product={product_temp_path}")

                    # Gửi yêu cầu tới Gradio
                    gradio_client = TryOnService.get_gradio_client()
                    result = gradio_client.predict(
                        dict={
                            "background": file(user_temp_path),
                            "layers": [],
                            "composite": None
                        },
                        garm_img=file(product_temp_path),
                        garment_des=request.garment_des,
                        is_checked=request.is_checked,
                        is_checked_crop=request.is_checked_crop,
                        denoise_steps=request.denoise_steps,
                        seed=request.seed,
                        api_name="/tryon"
                    )
                    logger.info(f"Kết quả từ Gradio: {result}")

                    # Xử lý kết quả
                    if not isinstance(result, tuple) or len(result) == 0:
                        raise ValueError("Kết quả từ Gradio không hợp lệ")

                    result_path = result[0]
                    if not os.path.exists(result_path):
                        raise FileNotFoundError(f"Không tìm thấy file kết quả: {result_path}")

                    with open(result_path, "rb") as result_file:
                        result_image_data = result_file.read()
                    logger.info(f"Đã đọc kết quả: {len(result_image_data)} bytes")

                    # Tải lên Supabase Storage
                    bucket_name = "tryon-temp"
                    # Dùng UUID đơn giản nếu không có user_id
                    file_name = f"tryon_{user_id or 'anonymous'}_{uuid.uuid4()}.jpg"
                    db.storage.from_(bucket_name).upload(file_name, result_image_data)
                    public_url = db.storage.from_(bucket_name).get_public_url(file_name)
                    logger.info(f"Đã tải lên: {public_url}")

                    return public_url

        except Exception as e:
            logger.error(f"Lỗi trong process_tryon: {str(e)}")
            raise