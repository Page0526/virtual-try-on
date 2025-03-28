# services/product.py
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

    COLLECTION_NAME = "products"
    DEVICE = "cuda" if torch.cuda.is_available() else "cpu"
    CLIP_MODEL, PREPROCESS = clip.load("ViT-B/32", device=DEVICE)

    @staticmethod
    async def create_product(product: ProductCreate) -> Dict:
        """Create new product and save to Supabase."""
        try:
            product_data = {
                "title": product.name,
                "description": product.description,
                "image_urls": product.image_urls,
                "brand": product.brand
            }
            created_product = Product.create(product_data)
            logger.info(f"Created new product with ID {created_product['id']}")
            return created_product
        except ProductException as e:
            logger.error(f"Error creating product: {str(e)}")
            raise

    @staticmethod
    async def get_product_by_id(product_id: str) -> Optional[Dict]:
        """Get product information by ID."""
        try:
            product = Product.get_by_id(product_id)
            if product:
                logger.info(f"Found product with ID {product_id}")
            else:
                logger.warning(f"Product with ID {product_id} not found")
            return product
        except ProductException as e:
            logger.error(f"Error retrieving product {product_id}: {str(e)}")
            raise

    @staticmethod
    async def list_products() -> List[Dict]:
        """Get list of all products."""
        try:
            products = Product.get_all()
            logger.info("Retrieved list of all products")
            return products
        except ProductException as e:
            logger.error(f"Error retrieving product list: {str(e)}")
            raise

    @staticmethod
    async def update_product(product_id: str, product_update: ProductUpdate) -> Dict:
        """Update product information."""
        try:
            existing_product = Product.get_by_id(product_id)
            if not existing_product:
                raise ValueError("Product does not exist")

            update_data = product_update.dict(exclude_unset=True)
            update_data["updated_at"] = datetime.utcnow().isoformat()
            updated_product = Product.update(product_id, update_data)
            logger.info(f"Updated product with ID {product_id}")
            return updated_product
        except (ValueError, ProductException) as e:
            logger.error(f"Error updating product {product_id}: {str(e)}")
            raise

    @staticmethod
    async def delete_product(product_id: str) -> None:
        """Delete product from Supabase."""
        try:
            if not Product.get_by_id(product_id):
                raise ValueError("Product does not exist")

            Product.delete(product_id)
            logger.info(f"Deleted product with ID {product_id}")
        except (ValueError, ProductException) as e:
            logger.error(f"Error deleting product {product_id}: {str(e)}")
            raise
    
    @staticmethod
    async def add_product_to_qdrant(product: Dict, qdrant: Optional[QdrantClient] = None) -> None:
        """Add product to Qdrant with vector embedding from CLIP."""
        if not qdrant:
            logger.warning("Qdrant client not available, skipping adding to Qdrant")
            return

        try:
            vector = ProductService._generate_clip_vector(product["image_urls"][0], product["name"])
            if vector is None:
                logger.warning(f"Could not create vector for product {product['id']}, skipping.")
                return

            qdrant.upsert(
                collection_name= ProductService.COLLECTION_NAME,
                points=[{
                    "id": product["id"],
                    "vector": vector,
                    "payload": product
                }]
            )
            logger.info(f"Added vector for product {product['id']} to Qdrant")
        except Exception as e:
            logger.error(f"Error adding product {product['id']} to Qdrant: {str(e)}")
            raise
    
    @staticmethod
    async def search_products(query: str, qdrant: Optional[QdrantClient] = None) -> List[Dict]: 
        """Search products using vector search with CLIP."""
        if not qdrant:
            raise ProductException("Qdrant client not available")

        try:
            text = clip.tokenize([query]).to(ProductService.DEVICE)
            with torch.no_grad():
                text_vector = ProductService.CLIP_MODEL.encode_text(text).cpu().tolist()[0]

            search_result = qdrant.search(
                collection_name=ProductService.COLLECTION_NAME,
                query_vector=text_vector,
                limit=10
            )

            product_ids = [hit.id for hit in search_result]
            if not product_ids:
                return []

            response = supabase.table("Products").select("*").in_("id", product_ids).execute()
            return response.data if response.data else []
        except Exception as e:
            logger.error(f"Error searching products: {str(e)}")
            raise

    @staticmethod
    def _generate_clip_vector(image_url: str, name: str) -> Optional[List[float]]:
        """Create vector embedding from image and product name using CLIP."""
        try:
            response = requests.get(image_url, timeout=5)
            response.raise_for_status()
            image = Image.open(BytesIO(response.content)).convert("RGB")
        except requests.exceptions.RequestException as e:
            logger.error(f"Error loading image from {image_url}: {e}")
            return None

        image_input = ProductService.PREPROCESS(image).unsqueeze(0).to(ProductService.DEVICE)
        text_input = clip.tokenize([name]).to(ProductService.DEVICE)

        with torch.no_grad():
            image_vector = ProductService.CLIP_MODEL.encode_image(image_input).cpu().tolist()[0]
            text_vector = ProductService.CLIP_MODEL.encode_text(text_input).cpu().tolist()[0]

        # Combine image and text vectors by concatenation
        combined_vector = np.concatenate([image_vector, text_vector]).tolist()
        return combined_vector
