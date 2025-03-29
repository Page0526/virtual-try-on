import os
import csv
import logging
from dotenv import load_dotenv
from qdrant_client import QdrantClient
from qdrant_client.http.models import PointStruct, VectorParams, Distance
import clip
import torch

# Load biến môi trường từ file .env
load_dotenv()

# Thiết lập logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Đường dẫn file CSV
CSV_FILE_PATH = "utils/products.csv"

def load_clip_model():
    """Tải mô hình CLIP"""
    device = "cuda" if torch.cuda.is_available() else "cpu"
    model, preprocess = clip.load("ViT-B/32", device=device)
    return model, device

def generate_description_vector(description: str, clip_model, device) -> list:
    """Tạo vector embedding từ description bằng CLIP"""
    try:
        text_input = clip.tokenize([description]).to(device)
        with torch.no_grad():
            text_vector = clip_model.encode_text(text_input).cpu().tolist()[0]
        return text_vector
    except Exception as e:
        logger.error(f"Lỗi khi tạo vector cho description '{description}': {str(e)}")
        return None

def seed_products_from_csv(csv_file_path: str, qdrant_client: QdrantClient, collection_name: str):
    """Đọc dữ liệu từ CSV và lưu vào Qdrant, tạo collection nếu chưa tồn tại"""
    clip_model, device = load_clip_model()

    # Kiểm tra và tạo collection nếu chưa tồn tại
    if not qdrant_client.collection_exists(collection_name):
        qdrant_client.create_collection(
            collection_name=collection_name,
            vectors_config=VectorParams(
                size=512,  # CLIP ViT-B/32 tạo vector 512 chiều cho text
                distance=Distance.COSINE  # Khoảng cách Cosine cho tìm kiếm
            )
        )
        logger.info(f"Đã tạo collection {collection_name} trong Qdrant")

    points = []
    with open(csv_file_path, newline='', encoding='utf-8') as csvfile:
        reader = csv.DictReader(csvfile)
        if "id" not in reader.fieldnames or "description" not in reader.fieldnames:
            raise ValueError("File CSV phải có cột 'id' và 'description'")

        for row in reader:
            product_id = row["id"]  # UUID dạng chuỗi từ CSV
            description = row["description"]

            vector = generate_description_vector(description, clip_model, device)
            if vector is None:
                logger.warning(f"Bỏ qua product {product_id} do lỗi tạo vector")
                continue

            point = PointStruct(
                id=product_id,  # Giữ nguyên UUID dạng chuỗi
                vector=vector,
                payload={"product_id": product_id}
            )
            points.append(point)
            logger.info(f"Chuẩn bị product {product_id} để lưu vào Qdrant")

    batch_size = 100
    for i in range(0, len(points), batch_size):
        batch = points[i:i + batch_size]
        try:
            qdrant_client.upsert(
                collection_name=collection_name,
                points=batch
            )
            logger.info(f"Đã thêm batch {i // batch_size + 1}: {len(batch)} sản phẩm vào Qdrant")
        except Exception as e:
            logger.error(f"Lỗi khi upsert batch {i // batch_size + 1}: {str(e)}")
            raise

    logger.info(f"Hoàn tất: Đã thêm tổng cộng {len(points)} sản phẩm vào Qdrant")

if __name__ == "__main__":
    # Lấy thông tin từ biến môi trường
    QDRANT_HOST = os.getenv("QDRANT_HOST", "http://localhost:6333")
    QDRANT_API_KEY = os.getenv("QDRANT_API_KEY", None)
    QDRANT_COLLECTION = os.getenv("QDRANT_COLLECTION", "products")

    # Kiểm tra biến môi trường
    if not QDRANT_HOST or not QDRANT_COLLECTION:
        logger.error("Thiếu thông tin cấu hình Qdrant. Kiểm tra lại file .env.")
        exit(1)

    # Kết nối tới Qdrant cluster
    try:
        qdrant_client = QdrantClient(url=QDRANT_HOST, api_key=QDRANT_API_KEY, timeout=10.0)
        # Kiểm tra kết nối
        collections = qdrant_client.get_collections()
        logger.info(f"Kết nối thành công tới Qdrant tại {QDRANT_HOST}")
    except Exception as e:
        logger.error(f"Lỗi kết nối Qdrant: {str(e)}")
        exit(1)

    try:
        seed_products_from_csv(CSV_FILE_PATH, qdrant_client, QDRANT_COLLECTION)
    except Exception as e:
        logger.error(f"Lỗi khi seed dữ liệu: {str(e)}")