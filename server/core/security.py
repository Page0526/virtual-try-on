from passlib.context import CryptContext
from fastapi.security import OAuth2PasswordBearer
from fastapi import Depends
from models.user import UserModel




"""
class xử lý thong tin mat khau, dang ki dang nhap 
"""

class SecurityService: 

    pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
    oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/auth/token")


    @staticmethod 
    def verify_password(plain_password, hashed_password): 

        return SecurityService.pwd_context.verify(plain_password, hashed_password)
    
    @staticmethod 
    def get_password_hash(password): 
        return SecurityService.pwd_context.hash(password)
    

    @staticmethod 
    async def authenticate_user(db, email: str, password: str):

        user = await db[UserModel.collection_name].find_one({"email : email"})

        if not user: 
            return False 
        
        if not SecurityService.verify_password(password, user["password"]):
            return False
        
        return user 
    
    @staticmethod 
    async def check_admin_role(): 
        pass 