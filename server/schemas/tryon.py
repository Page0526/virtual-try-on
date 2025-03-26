# schemas/tryon.py
from pydantic import BaseModel
from typing import Optional

class TryOnRequest(BaseModel):
    garment_des: str = ""  # Mô tả trang phục
    is_checked: bool = True       # Sử dụng mask
    is_checked_crop: bool = False # Cắt ảnh
    denoise_steps: int = 30       # Số bước giảm nhiễu
    seed: int = 42                # Giá trị seed

    class Config:
        json_schema_extra = {
            "example": {
                "garment_des": "A red casual shirt",
                "is_checked": True,
                "is_checked_crop": False,
                "denoise_steps": 30,
                "seed": 42
            }
        }

class TryOnResponse(BaseModel):
    status: str                   # Trạng thái (success/error)
    result_url: str               # URL công khai của ảnh kết quả

    class Config:
        from_attributes = True