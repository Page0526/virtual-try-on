# core/security.py
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from core.supabase import supabase
from config.setting import settings
import jwt as pyjwt  # Sửa import
from typing import Dict

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/user/token")  # Đảm bảo đúng tokenUrl

def get_current_user(token: str = Depends(oauth2_scheme)) -> Dict:
    try:
        payload = pyjwt.decode(token, settings.SUPABASE_JWT_SECRET, algorithms=["HS256"])
        user_id: str = payload.get("sub")
        if not user_id:
            raise HTTPException(status_code=401, detail="Token không hợp lệ")

        user = supabase.auth.get_user(token)
        if not user:
            raise HTTPException(status_code=401, detail="Không tìm thấy người dùng")

        return {
            "id": user.user.id,
            "email": user.user.email,
            "created_at": user.user.created_at
        }
    except pyjwt.ExpiredSignatureError:  # Sửa thành pyjwt
        raise HTTPException(status_code=401, detail="Token đã hết hạn")
    except pyjwt.PyJWTError:  # Sửa thành pyjwt
        raise HTTPException(status_code=401, detail="Không thể giải mã token")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Lỗi server: {str(e)}")