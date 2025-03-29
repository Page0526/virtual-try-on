# services/tryon.py
from core.supabase import Client
from gradio_client import Client as GradioClient, handle_file
from schemas.tryon import TryOnRequest
from fastapi import UploadFile
import logging
import uuid
import tempfile
import os
from contextlib import contextmanager
from typing import Optional, Dict, Tuple, List, Union

logging.basicConfig(level="INFO")
logging.getLogger("httpx").setLevel(logging.WARNING)
logger = logging.getLogger(__name__)

class TryOnService:
    GRADIO_URL = "https://3702f602a4ecdb2bed.gradio.live/"

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
    async def upload_file_to_storage(db: Client, file_path: str, user_id: Optional[str] = None, suffix: str = "") -> str:
        """Tải file lên Supabase Storage và trả về URL công khai."""
        try:
            if not os.path.exists(file_path):
                raise FileNotFoundError(f"Không tìm thấy file: {file_path}")
                
            with open(file_path, "rb") as file:
                file_data = file.read()
                
            bucket_name = "tryon-temp"
            file_name = f"tryon_{user_id or 'anonymous'}_{suffix}_{uuid.uuid4()}.jpg"
            db.storage.from_(bucket_name).upload(file_name, file_data)
            return db.storage.from_(bucket_name).get_public_url(file_name)
        except Exception as e:
            logger.error(f"Lỗi khi tải lên file {file_path}: {str(e)}")
            raise

    @staticmethod
    def extract_file_path(result: Union[str, Dict]) -> str:
        """Trích xuất đường dẫn file từ kết quả trả về."""
        if isinstance(result, str):
            return result
        elif isinstance(result, dict) and "url" in result:
            return result["url"]
        else:
            raise ValueError(f"Không thể trích xuất đường dẫn file từ: {result}")

    @staticmethod
    async def process_tryon(
        user_image: UploadFile,
        product_image: UploadFile,
        request: TryOnRequest,
        db: Client,
        user_id: Optional[str] = None
    ) -> Dict[str, str]:
        """Xử lý thử đồ và trả về các URL công khai."""
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

                    # Gửi yêu cầu tới Leffa API
                    gradio_client = TryOnService.get_gradio_client()
                    result = gradio_client.predict(
                        src_image_path=handle_file(user_temp_path),  # Sử dụng handle_file
                        ref_image_path=handle_file(product_temp_path),  # Sử dụng handle_file
                        ref_acceleration=request.ref_acceleration,
                        step=request.step,
                        scale=request.scale,
                        seed=request.seed,
                        vt_model_type=request.vt_model_type,
                        vt_garment_type=request.vt_garment_type,
                        vt_repaint=request.vt_repaint,
                        api_name="/leffa_predict_vt"
                    )
                    logger.info(f"Kết quả từ Leffa API: {result}")

                    # Xử lý kết quả
                    if not result or len(result) < 1:
                        raise ValueError("Kết quả từ Leffa API không hợp lệ")
                    
                    # Trích xuất đường dẫn file
                    generated_image = TryOnService.extract_file_path(result[0]) if len(result) > 0 else None
                    
                    logger.info(f"Đường dẫn kết quả: image={generated_image}")
                    
                    # Tải các file lên Supabase và trả về URL
                    urls = {}
                    
                    if generated_image:
                        urls["result_url"] = await TryOnService.upload_file_to_storage(
                            db, generated_image, user_id, "image"
                        )
                    else:
                        raise FileNotFoundError("Không tìm thấy ảnh kết quả từ API")
                    
                    
                    logger.info(f"Đã tải lên: {urls}")
                    return urls

        except Exception as e:
            logger.error(f"Lỗi trong process_tryon: {str(e)}")
            raise