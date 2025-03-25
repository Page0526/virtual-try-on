from fastapi import APIRouter, status, Body, Depends
from utils.response_handler import ResponseHandler
from schemas.user import UserBase, UserCreate, UserResponse, UserUpdate
from core.database import get_database
from services.user import UserService


"""
router tới các file api 
"""
router = APIRouter(tags = ["user"], prefix = "/user")


@router.get("/", response_model = list[UserResponse], status_code= status.HTTP_200_OK)
async def get_users(db = Depends(get_database)):
    """
    get all users 
    """
    users = await UserService.get_all_users(db)
    return users





#get user 
@router.get("/{user_id}", response_model = UserResponse, status_code= status.HTTP_200_OK)
async def get_user(user_id: str, db = Depends(get_database)):
    """
    get user by id 
    """
    user = await UserService.get_user_by_id(user_id, db)
    if not user:
        return ResponseHandler.not_found("User", user_id)
    return user


@router.post("/", response_model = UserResponse, status_code= status.HTTP_201_CREATED)
async def create_user(user: UserCreate = Body(), db = Depends(get_database)): 
    return await UserService.create_user(user, db) 


@router.put("/{user_id}", response_model = UserResponse, status_code= status.HTTP_200_OK)
async def update_user(user_id: str, db = Depends(get_database)):
    """
    update user by id 
    """
    user = await UserService.get_user_by_id(user_id, db)
    if not user:
        return ResponseHandler.not_found("User", user_id)
    return await UserService.update_user(user_id, user)


@router.delete("/{user_id}", status_code= status.HTTP_204_NO_CONTENT)
async def delete_user(user_id: str, db = Depends(get_database)):
    """
    delete user by id 
    """
    user = await UserService.get_user_by_id(user_id)
    if not user:
        return ResponseHandler.not_found("User", user_id)

    return await UserService.delete_user(user_id, db)
  



    











