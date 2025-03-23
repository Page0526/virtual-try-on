from pydantic import BaseModel, EmailStr, Field
from datetime import datetime 
from cart import CartBase
from typing import Optional



class UserBase(BaseModel): 
    id : str = Field(default=None)
    username : str 
    fullname : str
    email : EmailStr
    password : str
    phone_number : Optional[str] = None
    address : Optional[str] = None
    avatar : str # dduwong dan toi file luw avatar 
    carts : CartBase
    create_at : datetime 


class UserUpdate(BaseModel): 

    fullname : Optional[str] = None
    phone : Optional[str] = None
    address : Optional[str] = None


class UserResponse(BaseModel): 
    message : str
    data : UserBase

    class Config:
        orm_mode = True
        