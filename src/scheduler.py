#!/usr/bin/env python3
import logging
from datetime import datetime, timedelta
import time
from typing import List, Dict
import sys
from dotenv import load_dotenv

from database.db_handler import DatabaseHandler
from scrapers import HMScraper, GoatScraper

# Set up logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('scraper.log'),
        logging.StreamHandler(sys.stdout)
    ]
)
logger = logging.getLogger(__name__)

class ScraperScheduler:
    def __init__(self):
        self.db = DatabaseHandler()
        self.scrapers = {
            'hm': HMScraper(),
            'goat': GoatScraper()
        }
        
    def update_existing_products(self, max_age_days: int = 1) -> None:
        """
        Update products that haven't been updated in the specified number of days.
        
        Args:
            max_age_days: Maximum age of products in days before updating
        """
        cutoff = datetime.utcnow() - timedelta(days=max_age_days)
        
        # Find products that need updating
        products = self.db.products.find({
            'last_updated': {'$lt': cutoff}
        })
        
        updated_count = 0
        failed_count = 0
        
        for product in products:
            try:
                website = product.get('website', '').lower()
                if website not in self.scrapers:
                    logger.warning(f"No scraper found for website: {website}")
                    continue
                    
                scraper = self.scrapers[website]
                logger.info(f"Updating product from {website}: {product['url']}")
                updated_product = scraper.scrape_product(product['url'])
                
                if self.db.insert_product(updated_product):
                    updated_count += 1
                    logger.info(f"Successfully updated product: {product['name']}")
                else:
                    failed_count += 1
                    logger.error(f"Failed to save updated product: {product['name']}")
                
                # Sleep briefly to avoid overwhelming the website
                time.sleep(2)
                
            except Exception as e:
                failed_count += 1
                logger.error(f"Error updating product {product['url']}: {e}")
                continue
        
        logger.info(f"Update complete. Updated: {updated_count}, Failed: {failed_count}")

    def refresh_search_results(self, search_terms: List[str], max_results: int = 20) -> None:
        """
        Refresh product catalog by searching for specific terms across all scrapers.
        
        Args:
            search_terms: List of search terms to use
            max_results: Maximum number of results to fetch per term
        """
        total_products = 0
        
        for website, scraper in self.scrapers.items():
            logger.info(f"Starting search on {website}")
            
            for term in search_terms:
                try:
                    logger.info(f"Searching {website} for: {term}")
                    products = scraper.search_products(term, max_results)
                    
                    saved = 0
                    for product in products:
                        if self.db.insert_product(product):
                            saved += 1
                    
                    total_products += saved
                    logger.info(f"Saved {saved} products from {website} for term: {term}")
                    
                    # Sleep between searches to avoid overwhelming the website
                    time.sleep(5)
                    
                except Exception as e:
                    logger.error(f"Error searching {website} for term {term}: {e}")
                    continue
            
            # Longer sleep between websites
            time.sleep(10)
        
        logger.info(f"Search refresh complete. Total products saved: {total_products}")

    def cleanup_old_products(self, max_age_days: int = 30) -> None:
        """Remove products that haven't been updated in the specified number of days."""
        deleted = self.db.delete_old_products(max_age_days)
        logger.info(f"Removed {deleted} old products from database")

def main():
    load_dotenv()
    
    # Common search terms for clothing
    SEARCH_TERMS = [
        "men's shirts",
        "women's dresses",
        "jeans",
        "t-shirts",
        "sweaters",
        "jackets",
        "pants",
        "skirts",
        "shoes"
    ]
    
    try:
        scheduler = ScraperScheduler()
        
        # Update existing products
        scheduler.update_existing_products(max_age_days=1)
        
        # Refresh search results
        scheduler.refresh_search_results(SEARCH_TERMS)
        
        # Clean up old products
        scheduler.cleanup_old_products(max_age_days=30)
        
    except Exception as e:
        logger.error(f"Scheduler error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
