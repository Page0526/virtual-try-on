# schemas/product.py
from pydantic import BaseModel
from uuid import UUID
from typing import Optional, List
from datetime import datetime

class ProductBase(BaseModel):
    title: str
    image_urls: List[str]

class ProductCreate(ProductBase):
    description: Optional[str] = None
    brand: Optional[str] = None

class ProductUpdate(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    image_urls: Optional[List[str]] = None
    brand: Optional[str] = None

class ProductOut(BaseModel):
    id: UUID
    name: str
    description: Optional[str] = None
    image_urls: List[str]
    brand: Optional[str] = None 

    class Config:
        from_attributes = True
        
class RecommendRequest(BaseModel):
    image: str