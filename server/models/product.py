from uuid import uuid4
from datetime import datetime
from core.supabase import supabase
from typing import Dict, Optional, List

class ProductException(Exception):
    pass

class Product:
    TABLE_NAME = "Products"

    columns = {
        "id": "UUID PRIMARY KEY DEFAULT uuid_generate_v4()",
        "title": "TEXT NOT NULL",

        "description": "TEXT",
        "image_urls": "JSONB NOT NULL",
        "brand": "TEXT",
        "price": "FLOAT4",

        "url": "TEXT",
        "created_at": "TIMESTAMP DEFAULT NOW()"
    }

    @classmethod

    def create(cls, data: Dict) -> Dict:

        """Tạo product trong bảng Products."""
        try:
            product_data = {
                "id": str(uuid4()),
                "title": data["title"],

                "description": data.get("description"),
                "image_urls": data["image_urls"],  # JSONB, expects a list of URLs
                "brand": data.get("brand"),
                "price": data.get("price"),
                "url": data.get("url"),
                "created_at": datetime.utcnow().isoformat()

            }
            response = supabase.table(cls.TABLE_NAME).insert(product_data).execute()
            return response.data[0] if response.data else {}
        except Exception as e:
            raise ProductException(f"Không thể tạo product: {str(e)}")

    @classmethod
    def get_by_id(cls, product_id: str) -> Optional[Dict]:
        """Lấy product theo ID."""
        try:
            response = supabase.table(cls.TABLE_NAME).select("*").eq("id", product_id).execute()
            return response.data[0] if response.data else None
        except Exception as e:
            raise ProductException(f"Không thể lấy product {product_id}: {str(e)}")

    @classmethod
    def get_all(cls) -> list[Dict]:
        """Lấy tất cả product."""
        try:
            response = supabase.table(cls.TABLE_NAME).select("*").execute()
            return response.data if response.data else []
        except Exception as e:
            raise ProductException(f"Không thể lấy danh sách product: {str(e)}")

    @classmethod

    def update(cls, product_id: str, data: Dict) -> Dict:
        """Cập nhật thông tin product."""
        try:
            response = supabase.table(cls.TABLE_NAME).update(data).eq("id", product_id).execute()
            return response.data[0] if response.data else {}
        except Exception as e:
            raise ProductException(f"Không thể cập nhật product {product_id}: {str(e)}")

    @classmethod
    def delete(cls, product_id: str) -> None:
        """Xóa product khỏi bảng Products."""
        try:
            supabase.table(cls.TABLE_NAME).delete().eq("id", product_id).execute()
        except Exception as e:
            raise ProductException(f"Không thể xóa product {product_id}: {str(e)}")