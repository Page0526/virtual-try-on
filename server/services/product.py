from models.product import Product, ProductException
from schemas.product import ProductCreate, ProductUpdate, RecommendRequest
from core.supabase import supabase
from core.qdrant import get_qdrant_db
from qdrant_client import QdrantClient
from typing import Dict, Optional, List, Union
import logging
import clip
import torch
from PIL import Image as PILImage
from io import BytesIO
import numpy as np
from datetime import datetime
import requests
import base64
import google.generativeai as genai
from config.setting import settings

logging.basicConfig(level="INFO")
logger = logging.getLogger(__name__)


class ProductService:
    def __init__(self, qdrant: Optional[QdrantClient] = None):
        self.qdrant = qdrant
        self.collection_name = "products"
        self.device = "cuda" if torch.cuda.is_available() else "cpu"
        self.clip_model, self.preprocess = clip.load("ViT-B/32", device=self.device)
        
        api_key = settings.GOOGLE_API_KEY
        if api_key:
            genai.configure(api_key=api_key)
            self.gemini_model = genai.GenerativeModel('gemini-pro-vision')
        else:
            logger.warning("Google API key not found. Gemini features will be limited.")
            self.gemini_model = None

    async def create_product(self, product: ProductCreate) -> Dict:
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
            logger.info(f"Created product with ID {created_product['id']}")
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
    async def delete_product(self, product_id: str) -> None:
        try:
            if not Product.get_by_id(product_id):
                raise ValueError("Product not found")


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
    def search_products(query: str, qdrant: Optional[QdrantClient] = None, limit = 10) -> List[Dict]: 
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
                limit= limit, 
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
    def _generate_clip_vector(self, image_url: str, name: str) -> Optional[List[float]]:
        """Create vector embedding from image and product name using CLIP."""
        try:
            response = requests.get(image_url, timeout=5)
            response.raise_for_status()
            image = PILImage.open(BytesIO(response.content)).convert("RGB")
        except requests.exceptions.RequestException as e:
            logger.error(f"Error loading image from {image_url}: {e}")
            return None

        image_input = self.preprocess(image).unsqueeze(0).to(self.device)
        text_input = clip.tokenize([name]).to(self.device)

        with torch.no_grad():
            image_vector = ProductService.CLIP_MODEL.encode_image(image_input).cpu().tolist()[0]
            text_vector = ProductService.CLIP_MODEL.encode_text(text_input).cpu().tolist()[0]

        # Kết hợp vector ảnh và text bằng concatenation
        combined_vector = np.concatenate([image_vector, text_vector]).tolist()
        return combined_vector
        
    async def recommend_products(self, recommend_request: RecommendRequest) -> List[Dict]:
        try:
            search_queries = await self._generate_search_queries(
                text=recommend_request.text, 
                image=recommend_request.image
            )
            
            if not search_queries:
                logger.warning("Could not generate search queries")
                return []
            
            all_results = []
            seen_product_ids = set()
            
            for query in search_queries:
                logger.info(f"Searching with query: {query}")
                query_results = await self.search_products(query)
                
                for product in query_results:
                    if product["id"] not in seen_product_ids:
                        all_results.append(product)
                        seen_product_ids.add(product["id"])
                
                if len(all_results) >= 20:
                    break
            
            return all_results
            
        except Exception as e:
            logger.error(f"Error recommending products: {str(e)}")
            raise

    async def _generate_search_queries(self, text: Optional[str] = None, image: Optional[str] = None) -> List[str]:
        if not self.gemini_model:
            logger.warning("Gemini model not available. Using input text directly.")
            return [text] if text else []
        
        try:
            if image:
                prompt = (
                    "Describe the outfit in this image in detail, focusing on style, colors, and type of clothing. "
                    "Then, generate up to 3 short English search queries (3-10 words each) for tops and pants "
                    "that would match this outfit. Return only the queries, one per line."
                )
            elif text:
                prompt = (
                    "Based on this text, describe a suitable outfit focusing on style and context. "
                    "Then, generate up to 3 short English search queries (3-10 words each) for tops and pants "
                    "that would match this context. Return only the queries, one per line."
                )
            else:
                return []

            content = []
            if text:
                content.append(text)
            if image:
                img = await self._process_image_input(image)
                if img:
                    content.append(img)
                else:
                    logger.warning("Invalid image input")
                    return []

            if not content:
                logger.warning("No valid input for Gemini")
                return []

            response = self.gemini_model.generate_content([prompt] + content)
            
            if response and response.text:
                queries = [q.strip() for q in response.text.strip().split('\n') if q.strip()]
                return queries[:3]  # Limit to 3 queries
            
            return []
            
        except Exception as e:
            logger.error(f"Error generating search queries with Gemini: {str(e)}")
            return [text] if text else []
    
    async def _process_image_input(self, image_data: str) -> Optional[PILImage.Image]:
        try:
            if image_data.startswith(('http://', 'https://')):
                response = requests.get(image_data, timeout=10)
                response.raise_for_status()
                return PILImage.open(BytesIO(response.content)).convert("RGB")
            
            elif image_data.startswith(('data:image', 'base64:')):
                if ',' in image_data:
                    image_data = image_data.split(',', 1)[1]
                elif image_data.startswith('base64:'):
                    image_data = image_data[7:]
                
                image_bytes = base64.b64decode(image_data)
                return PILImage.open(BytesIO(image_bytes)).convert("RGB")
                
            else:
                try:
                    image_bytes = base64.b64decode(image_data)
                    return PILImage.open(BytesIO(image_bytes)).convert("RGB")
                except:
                    logger.error("Unsupported image format")
                    return None
                    
        except Exception as e:
            logger.error(f"Error processing image input: {str(e)}")
            return None