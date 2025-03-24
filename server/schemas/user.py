from pydantic import BaseModel, EmailStr, Field
from datetime import datetime 
from schemas.cart import CartBase
from typing import Optional



class UserBase(BaseModel): 
    fullname : str
    email : EmailStr
    phone : Optional[str] = None
    address : Optional[str] = None
    


class UserUpdate(BaseModel): 

    fullname : Optional[str] = None
    phone : Optional[str] = None
    address : Optional[str] = None


class UserResponse(BaseModel): 
    message : str
    data : UserBase

    class Config:
        from_attributes = True


class UserCreate(BaseModel): 
    email : EmailStr
    password : str



