from typing import Dict
from datetime import datetime, timedelta
from pymongo import MongoClient
from pymongo.collection import Collection
from pymongo.database import Database
import os
from dotenv import load_dotenv
import logging

logger = logging.getLogger(__name__)

class DatabaseHandler:
    def __init__(self):
        """Initialize MongoDB connection for storing product details."""
        load_dotenv()
        self.client = MongoClient(os.getenv('MONGODB_URI', 'mongodb://localhost:27017'))
        self.db: Database = self.client['clothing_recommendations']
        self.products: Collection = self.db['products']
        self._setup_indexes()

    def _setup_indexes(self):
        """Set up database indexes for efficient querying."""
        try:
            # Create indexes for common query fields
            self.products.create_index([('url', 1)], unique=True)
            self.products.create_index([('website', 1)])
            self.products.create_index([('name', 'text')])
        except Exception as e:
            logger.error(f"Error setting up indexes: {e}")

    def insert_product(self, product: Dict) -> bool:
        """
        Insert or update a product in the database.
        
        Args:
            product: Dictionary containing product information
            
        Returns:
            bool: True if operation was successful
        """
        try:
            # Use upsert to update if exists, insert if not
            self.products.update_one(
                {'url': product['url']},
                {'$set': {
                    **product,
                    'last_updated': datetime.utcnow()
                }},
                upsert=True
            )
            return True
        except Exception as e:
            logger.error(f"Error inserting product: {e}")
            return False

    def delete_old_products(self, days: int = 90) -> int:
        """
        Delete products that haven't been updated in the specified number of days.
        
        Args:
            days: Number of days after which products are considered old
            
        Returns:
            Number of products deleted
        """
        try:
            cutoff = datetime.utcnow() - timedelta(days=days)
            result = self.products.delete_many({
                'last_updated': {'$lt': cutoff}
            })
            return result.deleted_count
        except Exception as e:
            logger.error(f"Error deleting old products: {e}")
            return 0

    def close(self):
        """Close the database connection."""
        try:
            self.client.close()
        except Exception as e:
            logger.error(f"Error closing database connection: {e}")
