# api/tryon.py
from fastapi import APIRouter, UploadFile, File, Depends, status
from schemas.tryon import TryOnRequest, TryOnResponse
from services.tryon import TryOnService
from core.supabase import Client, get_supabase_db
from utils.response_handler import ResponseHandler
import logging

logging.basicConfig(level="INFO")
logger = logging.getLogger(__name__)

router = APIRouter(tags=["tryon"], prefix="/tryon")

@router.post(
    "/",
    response_model=TryOnResponse,
    status_code=status.HTTP_200_OK,
    summary="Thử đồ ảo",
    description="Nhận ảnh người dùng và sản phẩm, trả về URL ảnh kết quả sau khi thử đồ."
)
async def try_on(
    user_image: UploadFile = File(...),
    product_image: UploadFile = File(...),
    request: TryOnRequest = Depends(),
    db: Client = Depends(get_supabase_db),
):
    try:
        # Gọi TryOnService mà không cần user_id
        result_urls = await TryOnService.process_tryon(
            user_image=user_image,
            product_image=product_image,
            request=request,
            db=db
        )
        logger.info(f"Try-on thành công: {result_urls}")
        return ResponseHandler.tryon_success(
            result_urls["result_url"], 
        )
    except ValueError as ve:
        logger.error(f"Lỗi dữ liệu trong try-on: {str(ve)}")
        return ResponseHandler.error(str(ve), status_code=400)
    except FileNotFoundError as fnf:
        logger.error(f"Không tìm thấy file trong try-on: {str(fnf)}")
        return ResponseHandler.error(str(fnf), status_code=404)
    except Exception as e:
        logger.error(f"Lỗi không xác định trong try-on: {str(e)}")
        return ResponseHandler.error(f"Lỗi khi xử lý try-on: {str(e)}", status_code=500)