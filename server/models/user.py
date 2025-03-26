# models/user.py
from uuid import uuid4
from datetime import datetime
from core.supabase import supabase 
from typing import Dict, Optional

class UserException(Exception):
    pass

class User:
    TABLE_NAME = "Users"

    columns = {
        "id": "UUID PRIMARY KEY DEFAULT uuid_generate_v4()",
        "email": "TEXT UNIQUE NOT NULL",
        "full_name": "TEXT NOT NULL",
        "created_at": "TIMESTAMP DEFAULT NOW()",
        "updated_at": "TIMESTAMP DEFAULT NOW()"
    }

    @classmethod
    def create(cls, data: Dict[str, str]) -> Dict:
        """Tạo user trong bảng Users."""
        try:
            user_data = {
                "id": data["id"],
                "email": data["email"],
                "full_name": data["full_name"],
                "created_at": datetime.utcnow().isoformat(),
                "updated_at": datetime.utcnow().isoformat()
            }
            response = supabase.table(cls.TABLE_NAME).insert(user_data).execute()
            return response.data[0] if response.data else {}
        except Exception as e:
            raise UserException(f"Không thể tạo user: {str(e)}")

    @classmethod
    def get_by_id(cls, user_id: str) -> Optional[Dict]:
        """Lấy user theo ID."""
        try:
            response = supabase.table(cls.TABLE_NAME).select("*").eq("id", user_id).execute()
            return response.data[0] if response.data else None
        except Exception as e:
            raise UserException(f"Không thể lấy user {user_id}: {str(e)}")

    @classmethod
    def get_by_email(cls, email: str) -> Optional[Dict]:
        """Lấy user theo email."""
        try:
            response = supabase.table(cls.TABLE_NAME).select("*").eq("email", email).execute()
            return response.data[0] if response.data else None
        except Exception as e:
            raise UserException(f"Không thể lấy user với email {email}: {str(e)}")

    @classmethod
    def update(cls, user_id: str, data: Dict[str, str]) -> Dict:
        """Cập nhật thông tin user."""
        try:
            response = supabase.table(cls.TABLE_NAME).update(data).eq("id", user_id).execute()
            return response.data[0] if response.data else {}
        except Exception as e:
            raise UserException(f"Không thể cập nhật user {user_id}: {str(e)}")

    @classmethod
    def delete(cls, user_id: str) -> None:
        """Xóa user khỏi bảng Users."""
        try:
            supabase.table(cls.TABLE_NAME).delete().eq("id", user_id).execute()
        except Exception as e:
            raise UserException(f"Không thể xóa user {user_id}: {str(e)}")