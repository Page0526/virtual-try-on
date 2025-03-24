from models.user import UserModel
from core.database import get_database
from fastapi import Depends
from schemas.user import UserBase, UserCreate, UserResponse
from utils.response_handler import ResponseHandler
from fastapi.encoders import jsonable_encoder
from core.security import SecurityService
"""
sử lý logic trong user 

"""

class UserService: 

    @staticmethod 
    def get_all_user(): 
        pass 


    @staticmethod
    def get_user_by_id(user_id, db = Depends(get_database)):
        user = db[UserModel.collection_name].find_one({"_id": user_id})

        if user : 
            return UserModel.user_helper(user)
        return None 


    @staticmethod 
    async def create_user(user_data, db = Depends(get_database)):
        
        # check user existed 
        user = await db[UserModel.collection_name].find_one({"email ": user_data.email})
        if user:
            print(user) 
            return ResponseHandler.existed("User", user_data.email)
            
        # create new user
        user_data = jsonable_encoder(user_data)
        
        user_data['hash_password'] = SecurityService.get_password_hash(user_data['password'])
        del user_data['password']
        print(user_data['email']) 

        new_user = UserModel.create_user(user_data)

        # save user to db 
        result = await db[UserModel.collection_name].insert_one(new_user)
        created_user = await db[UserModel.collection_name].find_one({"_id": result.inserted_id})

        return ResponseHandler.create_success("User" ,  UserModel.user_helper(created_user)) 



    @staticmethod 
    def update_user(user_id, user_data): 
        pass



    @staticmethod
    def delete_user(user_id): 
        pass