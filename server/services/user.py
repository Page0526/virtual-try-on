# services/user.py
from models.user import User, UserException
from schemas.user import UserCreate, UserLogin, UserUpdate
from core.supabase import supabase
from typing import Dict, Optional
import logging

logging.basicConfig(level="INFO")
logger = logging.getLogger(__name__)

class UserService:
    @staticmethod
    async def create_user(user: UserCreate) -> Dict:
        """Tạo user mới với Supabase Auth và lưu vào bảng Users."""
        try:
            if User.get_by_email(user.email):
                raise ValueError("Email đã tồn tại")

            auth_response = supabase.auth.sign_up({"email": user.email, "password": user.password})
            if not auth_response.user:
                raise ValueError("Không thể tạo user trong Supabase Auth")

            user_data = {
                "id": auth_response.user.id,
                "email": user.email,
                "full_name": user.full_name
            }
            created_user = User.create(user_data)
            logger.info(f"Đã tạo user mới với email {user.email}")
            return created_user
        except (ValueError, UserException) as e:
            logger.error(f"Lỗi khi tạo user với email {user.email}: {str(e)}")
            raise

    @staticmethod
    async def login_user(user: UserLogin) -> Dict:
        """Đăng nhập user và trả về token."""
        try:
            auth_response = supabase.auth.sign_in_with_password({
                "email": user.email,
                "password": user.password
            })
            if not auth_response.user:
                raise ValueError("Thông tin đăng nhập không chính xác")

            logger.info(f"User {user.email} đã đăng nhập thành công")
            return {
                "access_token": auth_response.session.access_token,
                "token_type": "bearer",
                "user": {"id": auth_response.user.id, "email": auth_response.user.email}
            }
        except ValueError as e:
            logger.error(f"Lỗi khi đăng nhập user {user.email}: {str(e)}")
            raise

    @staticmethod
    async def get_user_by_id(user_id: str) -> Optional[Dict]:
        """Lấy thông tin user theo ID."""
        try:
            user = User.get_by_id(user_id)
            if user:
                logger.info(f"Đã tìm thấy user với ID {user_id}")
            else:
                logger.warning(f"Không tìm thấy user với ID {user_id}")
            return user
        except UserException as e:
            logger.error(f"Lỗi khi lấy user {user_id}: {str(e)}")
            raise

    @staticmethod
    async def update_user(user_id: str, user_update: UserUpdate) -> Dict:
        """Cập nhật thông tin user."""
        try:
            existing_user = User.get_by_id(user_id)
            if not existing_user:
                raise ValueError("User không tồn tại")

            update_data = user_update.dict(exclude_unset=True)
            update_data["updated_at"] = datetime.utcnow().isoformat()
            updated_user = User.update(user_id, update_data)
            logger.info(f"Đã cập nhật user với ID {user_id}")
            return updated_user
        except (ValueError, UserException) as e:
            logger.error(f"Lỗi khi cập nhật user {user_id}: {str(e)}")
            raise

    @staticmethod
    async def delete_user(user_id: str) -> None:
        """Xóa user khỏi bảng Users."""
        try:
            if not User.get_by_id(user_id):
                raise ValueError("User không tồn tại")

            User.delete(user_id)
            logger.info(f"Đã xóa user với ID {user_id}")
        except (ValueError, UserException) as e:
            logger.error(f"Lỗi khi xóa user {user_id}: {str(e)}")
            raise