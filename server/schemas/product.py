from pydantic import BaseModel, validator
from uuid import UUID
from typing import Optional, List
from typing import Optional, List
from datetime import datetime

class ProductBase(BaseModel):
    title: str
    image_urls: List[str]
    title: str
    image_urls: List[str]

class ProductCreate(ProductBase):
    description: Optional[str] = None
    brand: Optional[str] = None
    price: Optional[float] = None
    url: Optional[str] = None

class ProductUpdate(BaseModel):
    title: Optional[str] = None
    title: Optional[str] = None
    description: Optional[str] = None
    image_urls: Optional[List[str]] = None
    brand: Optional[str] = None
    price: Optional[float] = None
    url: Optional[str] = None

class ProductOut(BaseModel):
    id: UUID
    title: str
    description: Optional[str] = None
    image_urls: List[str]
    brand: Optional[str] = None
    price: Optional[float] = None
    url: Optional[str] = None
    created_at: Optional[datetime] = None

    class Config:
        from_attributes = True
        
class RecommendRequest(BaseModel):
    text: Optional[str] = None
    image: Optional[str] = None  # Can be URL or base64 encoded image

    @validator('text', 'image')
    def validate_input(cls, v, values):
        if not values.get('text') and not values.get('image') and not v:
            raise ValueError("Must provide either text or image")
        return v