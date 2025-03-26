# api/product.py
from fastapi import APIRouter, Depends, HTTPException
from schemas.product import ProductCreate, ProductUpdate, ProductOut
from services.product import ProductService
from core.supabase import get_supabase_db
from core.qdrant import get_qdrant_db
from supabase import Client
from qdrant_client import QdrantClient

router = APIRouter(prefix="/products", tags=["products"])

@router.post("/", response_model=ProductOut)
async def create_product(
    product: ProductCreate,
    supabase: Client = Depends(get_supabase_db),
    qdrant: QdrantClient = Depends(get_qdrant_db)
):
    """Tạo một sản phẩm mới."""
    try:
        product_service = ProductService(qdrant)
        created_product = await product_service.create_product(product)
        await product_service.add_product_to_qdrant(created_product)
        return created_product
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@router.get("/{product_id}", response_model=ProductOut)
async def get_product(
    product_id: str,
    supabase: Client = Depends(get_supabase_db)
):
    """Lấy thông tin sản phẩm theo ID."""
    product_service = ProductService()
    product = await product_service.get_product_by_id(product_id)
    if not product:
        raise HTTPException(status_code=404, detail="Sản phẩm không tồn tại")
    return product

@router.get("/", response_model=list[ProductOut])
async def list_products(
    supabase: Client = Depends(get_supabase_db)
):
    """Lấy danh sách tất cả sản phẩm."""
    product_service = ProductService()
    return await product_service.list_products()

@router.put("/{product_id}", response_model=ProductOut)
async def update_product(
    product_id: str,
    product_update: ProductUpdate,
    supabase: Client = Depends(get_supabase_db)
):
    """Cập nhật thông tin sản phẩm."""
    try:
        product_service = ProductService()
        return await product_service.update_product(product_id, product_update)
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@router.delete("/{product_id}")
async def delete_product(
    product_id: str,
    supabase: Client = Depends(get_supabase_db)
):
    """Xóa sản phẩm."""
    try:
        product_service = ProductService()
        await product_service.delete_product(product_id)
        return {"message": f"Đã xóa sản phẩm với ID {product_id}"}
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@router.post("/search", response_model=list[ProductOut])
async def search_products(
    query: str,
    supabase: Client = Depends(get_supabase_db),
    qdrant: QdrantClient = Depends(get_qdrant_db)
):
    """Tìm kiếm sản phẩm bằng vector search với CLIP."""
    try:
        product_service = ProductService(qdrant)
        return await product_service.search_products(query)
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))