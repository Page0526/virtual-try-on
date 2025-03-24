from fastapi import APIRouter, status, Body, Depends
from utils.response_handler import ResponseHandler
from schemas.user import UserBase, UserCreate, UserResponse
from core.database import get_database
from services.user import UserService


"""
router tới các file api 
"""
router = APIRouter(tags = ["user"], prefix = "/user")



#get user 
@router.get("/{user_id}")
async def get_user(user_id: str):
    """
    get user by id 
    """
    from server.services.user import UserService
    user = await UserService.get_user_by_id(user_id)
    if not user:
        return ResponseHandler.not_found("User", user_id)
    return user


@router.post("/", response_model = UserResponse, status_code= status.HTTP_201_CREATED)
async def create_user(user: UserCreate = Body(), db = Depends(get_database)): 
    return await UserService.create_user(user, db) 





    











