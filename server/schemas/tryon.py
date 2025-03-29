# schemas/tryon.py
from pydantic import BaseModel, Field
from typing import Optional

class TryOnRequest(BaseModel):
    # Các tham số phù hợp với API Leffa
    ref_acceleration: bool = False
    step: int = Field(30, ge=1, le=100)  # Tương đương với denoise_steps trong mã cũ
    scale: float = Field(2.5, ge=0.1, le=10.0)
    seed: int = 42
    vt_model_type: str = "viton_hd"
    vt_garment_type: str = "upper_body"
    vt_repaint: bool = False

    class Config:
        json_schema_extra = {
            "example": {
                "ref_acceleration": False,
                "step": 30,
                "scale": 2.5,
                "seed": 42,
                "vt_model_type": "viton_hd",
                "vt_garment_type": "upper_body",
                "vt_repaint": False
            }
        }

class TryOnResponse(BaseModel):
    status: str                   # Trạng thái (success/error)
    result_url: str               # URL công khai của ảnh kết quả
    mask_url: Optional[str] = None     # URL công khai của mask (nếu có)
    densepose_url: Optional[str] = None # URL công khai của densepose (nếu có)

    class Config:
        from_attributes = True