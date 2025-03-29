from pydantic import BaseModel, EmailStr, Field
from datetime import datetime 
from schemas.cart import CartBase
from typing import Optional, Union, List

class AccountBase(BaseModel): 
    id: str
    fullname : str
    email : EmailStr
    phone : str
    address : str 
    avatar : str
    carts : List[CartBase]
    created_at : datetime



class AccountUpdate(BaseModel):

    fullname : Optional[str] = None
    phone : Optional[str] = None
    address : Optional[str] = None
    avatar : Optional[str] = None


class AccountResponse(BaseModel):

    message : str
    data : AccountBase

    class Config:
        from_attributes = True