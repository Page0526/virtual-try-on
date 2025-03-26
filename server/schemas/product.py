# schemas/product.py
from pydantic import BaseModel
from uuid import UUID
from typing import Optional
from datetime import datetime

class ProductBase(BaseModel):
    name: str
    image_url: str

class ProductCreate(ProductBase):
    description: Optional[str] = None
    category: Optional[str] = None

class ProductUpdate(BaseModel):
    name: Optional[str] = None
    description: Optional[str] = None
    image_url: Optional[str] = None
    category: Optional[str] = None

class ProductOut(BaseModel):
    id: UUID
    name: str
    description: Optional[str] = None
    image_url: str
    category: Optional[str] = None
    created_at: datetime

    class Config:
        from_attributes = True
        
class RecommendRequest(BaseModel):
    image: str