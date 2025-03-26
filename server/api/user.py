# api/user.py
from fastapi import APIRouter, status, Depends, HTTPException
from schemas.user import UserCreate, UserLogin, UserOut, UserUpdate
from services.user import UserService
from core.security import get_current_user
from utils.response_handler import ResponseHandler
from fastapi.security import OAuth2PasswordRequestForm
import logging

logging.basicConfig(level="INFO")
logger = logging.getLogger(__name__)

router = APIRouter(tags=["user"], prefix="/user")

@router.post("/signup", response_model=UserOut, status_code=status.HTTP_201_CREATED,
             summary="Đăng ký user mới", description="Tạo một user mới với Supabase Auth.")
async def signup_user(user: UserCreate):
    try:
        created_user = await UserService.create_user(user)
        return ResponseHandler.created(created_user)
    except ValueError as ve:
        return ResponseHandler.error(str(ve), status_code=400)
    except Exception as e:
        return ResponseHandler.error(f"Lỗi khi đăng ký user: {str(e)}", status_code=500)

@router.post("/login", summary="Đăng nhập user", description="Đăng nhập và trả về access token.")
async def login_user(user: UserLogin):
    try:
        login_response = await UserService.login_user(user)
        return ResponseHandler.success(login_response)
    except ValueError as ve:
        return ResponseHandler.error(str(ve), status_code=401)
    except Exception as e:
        return ResponseHandler.error(f"Lỗi khi đăng nhập: {str(e)}", status_code=500)

@router.get("/{user_id}", response_model=UserOut,
            summary="Lấy thông tin user", description="Lấy thông tin user theo ID, yêu cầu xác thực.")
async def get_user(user_id: str, current_user: dict = Depends(get_current_user)):
    if current_user["id"] != user_id:
        raise HTTPException(status_code=403, detail="Không có quyền truy cập")
    try:
        user = await UserService.get_user_by_id(user_id)
        if not user:
            return ResponseHandler.not_found("User", user_id)
        return ResponseHandler.success(user)
    except Exception as e:
        return ResponseHandler.error(f"Lỗi khi lấy user: {str(e)}", status_code=500)

@router.put("/{user_id}", response_model=UserOut,
            summary="Cập nhật user", description="Cập nhật thông tin user, yêu cầu xác thực.")
async def update_user(
    user_id: str,
    user_update: UserUpdate,
    current_user: dict = Depends(get_current_user)
):
    if current_user["id"] != user_id:
        raise HTTPException(status_code=403, detail="Không có quyền truy cập")
    try:
        updated_user = await UserService.update_user(user_id, user_update)
        if not updated_user:
            return ResponseHandler.not_found("User", user_id)
        return ResponseHandler.success(updated_user)
    except ValueError as ve:
        return ResponseHandler.error(str(ve), status_code=400)
    except Exception as e:
        return ResponseHandler.error(f"Lỗi khi cập nhật user: {str(e)}", status_code=500)

@router.delete("/{user_id}", summary="Xóa user", description="Xóa user, yêu cầu xác thực.")
async def delete_user(user_id: str, current_user: dict = Depends(get_current_user)):
    if current_user["id"] != user_id:
        raise HTTPException(status_code=403, detail="Không có quyền truy cập")
    try:
        await UserService.delete_user(user_id)
        return ResponseHandler.success({"message": "User đã được xóa"})
    except ValueError as ve:
        return ResponseHandler.error(str(ve), status_code=400)
    except Exception as e:
        return ResponseHandler.error(f"Lỗi khi xóa user: {str(e)}", status_code=500)


# Endpoint mới cho Swagger UI
@router.post("/token", summary="Lấy token theo chuẩn OAuth2", description="Dùng cho Swagger UI.")
async def login_for_access_token(form_data: OAuth2PasswordRequestForm = Depends()):
    user = UserLogin(email=form_data.username, password=form_data.password)
    try:
        login_response = await UserService.login_user(user)
        return {
            "access_token": login_response["access_token"],
            "token_type": login_response["token_type"]
        }
    except ValueError as ve:
        raise HTTPException(status_code=401, detail=str(ve))
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Lỗi khi đăng nhập: {str(e)}")