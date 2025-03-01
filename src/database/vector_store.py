from typing import List, Dict, Optional
import os
from dotenv import load_dotenv
from qdrant_client import QdrantClient
from qdrant_client.http.models import (
    Distance,
    VectorParams,
    PointStruct,
    UpdateStatus,
    CollectionStatus,
    Filter,
    FieldCondition,
    MatchValue
)
import uuid
import logging

logger = logging.getLogger(__name__)

class VectorStore:
    def __init__(self):
        """Initialize Qdrant client and ensure collection exists."""
        load_dotenv()
        
        # Connect to Qdrant
        self.client = QdrantClient(
            url=os.getenv('QDRANT_URL', 'http://localhost:6333'),
            api_key=os.getenv('QDRANT_API_KEY')
        )
        
        self.collection_name = "clothing_embeddings"
        self.vector_size = 512  # Size of CLIP embeddings
        
        # Ensure collection exists
        self._setup_collection()
    
    def _setup_collection(self) -> None:
        """Create collection if it doesn't exist."""
        try:
            collections = self.client.get_collections()
            exists = any(c.name == self.collection_name for c in collections.collections)
            
            if not exists:
                logger.info(f"Creating collection: {self.collection_name}")
                self.client.create_collection(
                    collection_name=self.collection_name,
                    vectors_config=VectorParams(
                        size=self.vector_size,
                        distance=Distance.COSINE
                    )
                )
                
                # Wait for collection to be ready
                status = self.client.get_collection(self.collection_name)
                while status.status != CollectionStatus.GREEN:
                    status = self.client.get_collection(self.collection_name)
        
        except Exception as e:
            logger.error(f"Error setting up collection: {e}")
            raise
    
    def upsert_vector(self, mongo_id: str, vector: List[float], metadata: Dict) -> bool:
        """
        Store or update product vector and metadata.
        
        Args:
            mongo_id: MongoDB ObjectID as string
            vector: Embedding vector
            metadata: Additional product metadata
            
        Returns:
            bool: True if operation was successful
        """
        try:
            # Ensure vector is the correct size
            if len(vector) != self.vector_size:
                raise ValueError(f"Vector size must be {self.vector_size}")
            
            # Generate UUID from MongoDB ID
            point_id = uuid.uuid5(uuid.NAMESPACE_OID, mongo_id)
            
            # Create point with vector and metadata
            point = PointStruct(
                id=str(point_id),
                vector=vector,
                payload={
                    "mongo_id": mongo_id,
                    **metadata
                }
            )
            
            # Upsert point
            operation = self.client.upsert(
                collection_name=self.collection_name,
                points=[point]
            )
            
            return operation.status == UpdateStatus.COMPLETED
            
        except Exception as e:
            logger.error(f"Error upserting vector: {e}")
            return False
    
    def search_similar(
        self,
        vector: List[float],
        limit: int = 10,
        score_threshold: float = 0.7,
        category: Optional[str] = None
    ) -> List[Dict]:
        """
        Search for similar vectors.
        
        Args:
            vector: Query vector
            limit: Maximum number of results
            score_threshold: Minimum similarity score (0-1)
            category: Optional category to filter by
            
        Returns:
            List of similar items with scores and metadata
        """
        try:
            # Ensure vector is the correct size
            if len(vector) != self.vector_size:
                raise ValueError(f"Vector size must be {self.vector_size}")
            
            # Build filter if category provided
            filter_param = None
            if category:
                filter_param = Filter(
                    must=[
                        FieldCondition(
                            key="category",
                            match=MatchValue(value=category)
                        )
                    ]
                )
            
            # Search for similar vectors
            results = self.client.search(
                collection_name=self.collection_name,
                query_vector=vector,
                limit=limit,
                score_threshold=score_threshold,
                query_filter=filter_param
            )
            
            # Format results
            return [
                {
                    "product_id": hit.payload["mongo_id"],
                    "score": hit.score,
                    "metadata": {k:v for k,v in hit.payload.items() if k != "mongo_id"}
                }
                for hit in results
            ]
            
        except Exception as e:
            logger.error(f"Error searching vectors: {e}")
            return []
    
    def delete_vector(self, mongo_id: str) -> bool:
        """Delete a vector by MongoDB ID."""
        try:
            # Generate UUID from MongoDB ID
            point_id = uuid.uuid5(uuid.NAMESPACE_OID, mongo_id)
            
            operation = self.client.delete(
                collection_name=self.collection_name,
                points_selector=[str(point_id)]
            )
            return operation.status == UpdateStatus.COMPLETED
        except Exception as e:
            logger.error(f"Error deleting vector: {e}")
            return False
    
    def close(self):
        """Close the client connection."""
        self.client.close()
