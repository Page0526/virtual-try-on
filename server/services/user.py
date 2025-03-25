from models.user import UserModel
from core.database import get_database
from fastapi import Depends
from schemas.user import UserBase, UserCreate, UserResponse
from utils.response_handler import ResponseHandler
from fastapi.encoders import jsonable_encoder
from core.security import SecurityService


from schemas.user import UserUpdate
"""
sử lý logic trong user 

"""

class UserService: 

    @staticmethod 
    async def get_all_users(db = Depends(get_database)):
        users = await db[UserModel.collection_name].find().to_list(length=None)
        data =  [UserModel.user_helper(user) for user in users] 
        return [ResponseHandler.success("Users retrieved successfully", data[i]) for i in range(len(data))]


    @staticmethod
    async  def get_user_by_id(user_id, db = Depends(get_database)):
        user = await db[UserModel.collection_name].find_one({"_id": user_id})

        if user : 
            print(user)
            return [UserModel.user_helper(user)]
        return None 


    @staticmethod 
    async def create_user(user_data, db = Depends(get_database)):
        
        # check user existed 
        user = await db[UserModel.collection_name].find_one({"email": user_data.email})
        
        if user is not None:
            return ResponseHandler.existed(user_data.email)
            
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
    async  def update_user(user_id: str, user_data: UserUpdate, db = Depends(get_database)): 

        user = await db[UserModel.collection_name].find_one({"_id": user_id})
        if not user:
            return ResponseHandler.not_found("User", user_id)
        
        user_data = {k : v for k, v in user_data.dict().items() if v is not None }
        result = await db[UserModel.collection_name].update_one({"_id": user_id}, {"$set": user_data})
        
        return ResponseHandler.update_success("User", user_id, UserModel.user_helper(result)) 



    @staticmethod
    async def delete_user(user_id: str, db = Depends(get_database)): 

        user = await db[UserModel.collection_name].find_one({"_id": user_id})
        if not user:
            return ResponseHandler.not_found("User", user_id)
        
        result = await db[UserModel.collection_name].delete_one({"_id": user_id})
        return ResponseHandler.success("User deleted successfully", UserModel.user_helper(result))