from models.product import Product, ProductException
from schemas.product import ProductCreate, ProductUpdate
from core.supabase import supabase
from core.qdrant import get_qdrant_db
from qdrant_client import QdrantClient
from typing import Dict, Optional, List
import logging
import clip
import torch
from PIL import Image
import requests
from io import BytesIO
import numpy as np
from datetime import datetime

logging.basicConfig(level="INFO")
logger = logging.getLogger(__name__)

class ProductService:
    def __init__(self, qdrant: Optional[QdrantClient] = None):
        self.qdrant = qdrant
        self.collection_name = "products"
        self.device = "cuda" if torch.cuda.is_available() else "cpu"
        self.clip_model, self.preprocess = clip.load("ViT-B/32", device=self.device)

    async def create_product(self, product: ProductCreate) -> Dict:
        """Tạo product mới và lưu vào Supabase."""
        try:
            product_data = {
                "title": product.title,
                "description": product.description,
                "image_urls": product.image_urls,
                "brand": product.brand,
                "price": product.price,
                "url": product.url
            }
            created_product = Product.create(product_data)
            logger.info(f"Đã tạo product mới với ID {created_product['id']}")
            return created_product
        except ProductException as e:
            logger.error(f"Lỗi khi tạo product: {str(e)}")
            raise

    async def get_product_by_id(self, product_id: str) -> Optional[Dict]:
        """Lấy thông tin product theo ID."""
        try:
            product = Product.get_by_id(product_id)
            if product:
                logger.info(f"Đã tìm thấy product với ID {product_id}")
            else:
                logger.warning(f"Không tìm thấy product với ID {product_id}")
            return product
        except ProductException as e:
            logger.error(f"Lỗi khi lấy product {product_id}: {str(e)}")
            raise

    async def list_products(self) -> List[Dict]:
        """Lấy danh sách tất cả product."""
        try:
            products = Product.get_all()
            logger.info("Đã lấy danh sách tất cả product")
            return products
        except ProductException as e:
            logger.error(f"Lỗi khi lấy danh sách product: {str(e)}")
            raise

    async def update_product(self, product_id: str, product_update: ProductUpdate) -> Dict:
        """Cập nhật thông tin product."""
        try:
            existing_product = Product.get_by_id(product_id)
            if not existing_product:
                raise ValueError("Product không tồn tại")

            update_data = product_update.dict(exclude_unset=True)
            update_data["updated_at"] = datetime.utcnow().isoformat()
            updated_product = Product.update(product_id, update_data)
            logger.info(f"Đã cập nhật product với ID {product_id}")
            return updated_product
        except (ValueError, ProductException) as e:
            logger.error(f"Lỗi khi cập nhật product {product_id}: {str(e)}")
            raise

    async def delete_product(self, product_id: str) -> None:
        """Xóa product khỏi Supabase."""
        try:
            if not Product.get_by_id(product_id):
                raise ValueError("Product không tồn tại")

            Product.delete(product_id)
            logger.info(f"Đã xóa product với ID {product_id}")
        except (ValueError, ProductException) as e:
            logger.error(f"Lỗi khi xóa product {product_id}: {str(e)}")
            raise

    async def add_product_to_qdrant(self, product: Dict) -> None:
        """Thêm product vào Qdrant với vector embedding từ CLIP."""
        if not self.qdrant:
            logger.warning("Qdrant client không khả dụng, bỏ qua việc thêm vào Qdrant")
            return

        try:
            # Use the first image URL for embedding if available
            image_url = product["image_urls"][0] if product["image_urls"] else None
            if not image_url:
                logger.warning(f"Không có image_urls cho product {product['id']}, bỏ qua.")
                return

            vector = self._generate_clip_vector(image_url, product["title"])
            if vector is None:
                logger.warning(f"Không thể tạo vector cho product {product['id']}, bỏ qua.")
                return

            self.qdrant.upsert(
                collection_name=self.collection_name,
                points=[{
                    "id": product["id"],
                    "vector": vector,
                    "payload": product
                }]
            )
            logger.info(f"Đã thêm vector cho product {product['id']} vào Qdrant")
        except Exception as e:
            logger.error(f"Lỗi khi thêm product {product['id']} vào Qdrant: {str(e)}")
            raise
    
    async def search_products(self, query: str) -> List[Dict]:
        """Tìm kiếm product bằng vector search với CLIP."""
        if not self.qdrant:
            raise ProductException("Qdrant client không khả dụng")

        try:
            text = clip.tokenize([query]).to(self.device)
            with torch.no_grad():
                text_vector = self.clip_model.encode_text(text).cpu().tolist()[0]

            search_result = self.qdrant.search(
                collection_name=self.collection_name,
                query_vector=text_vector,
                limit=10
            )

            product_ids = [hit.id for hit in search_result]
            if not product_ids:
                return []

            response = supabase.table("Products").select("*").in_("id", product_ids).execute()
            return response.data if response.data else []
        except Exception as e:
            logger.error(f"Lỗi khi tìm kiếm product: {str(e)}")
            raise

    def _generate_clip_vector(self, image_url: str, title: str) -> Optional[List[float]]:
        """Tạo vector embedding từ ảnh và tiêu đề sản phẩm bằng CLIP."""
        try:
            response = requests.get(image_url, timeout=5)
            response.raise_for_status()
            image = Image.open(BytesIO(response.content)).convert("RGB")
        except requests.exceptions.RequestException as e:
            logger.error(f"Lỗi khi tải ảnh từ {image_url}: {e}")
            return None

        image_input = self.preprocess(image).unsqueeze(0).to(self.device)
        text_input = clip.tokenize([title]).to(self.device)

        with torch.no_grad():
            image_vector = self.clip_model.encode_image(image_input).cpu().tolist()[0]
            text_vector = self.clip_model.encode_text(text_input).cpu().tolist()[0]

        combined_vector = np.concatenate([image_vector, text_vector]).tolist()
        return combined_vector