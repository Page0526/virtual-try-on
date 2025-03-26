# schemas/user.py
from pydantic import BaseModel, EmailStr
from uuid import UUID
from typing import Optional
from datetime import datetime

class UserBase(BaseModel):
    email: EmailStr
    full_name: str

class UserCreate(UserBase):
    password: str

class UserLogin(BaseModel):
    email: EmailStr
    password: str

class UserUpdate(BaseModel):
    full_name: Optional[str] = None

class UserOut(BaseModel):
    id: UUID
    email: EmailStr
    full_name: str
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True