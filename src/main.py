import argparse
from typing import List, Dict
import sys
import os
from datetime import datetime
from dotenv import load_dotenv
from .database.db_handler import DatabaseHandler
from .scrapers import HMScraper, GoatScraper
import logging
from bson import ObjectId

logger = logging.getLogger(__name__)

def setup_argparse() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description='Clothing product scraper and recommendation system')
    parser.add_argument('--search', type=str, help='Search term for products')
    parser.add_argument('--url', type=str, help='Specific product URL to scrape')
    parser.add_argument('--max-results', type=int, default=10, help='Maximum number of results to return')
    parser.add_argument('--website', type=str, choices=['hm', 'goat'], default='hm',
                      help='Website to scrape from (hm or goat)')
    return parser

def save_products(db_handler: DatabaseHandler, scraper, products: List[Dict]) -> int:
    """Save products to database and store embeddings."""
    saved = 0
    for product in products:
        try:
            # Insert into MongoDB
            result = db_handler.products.update_one(
                {'url': product['url']},
                {'$set': {
                    **product,
                    'last_updated': datetime.utcnow()
                }},
                upsert=True
            )
            
            # Get MongoDB ID
            if result.upserted_id:
                product_id = str(result.upserted_id)
            else:
                doc = db_handler.products.find_one({'url': product['url']})
                product_id = str(doc['_id'])
            
            # Store embedding in Qdrant
            if scraper._store_product_embedding(product, product_id):
                saved += 1
                logger.info(f"Saved product with embedding: {product['name']}")
            else:
                logger.warning(f"Failed to store embedding for: {product['name']}")
                
        except Exception as e:
            logger.error(f"Error saving product: {e}")
            continue
            
    return saved

def main():
    load_dotenv()
    logging.basicConfig(level=logging.INFO)
    
    parser = setup_argparse()
    args = parser.parse_args()

    if not args.search and not args.url:
        parser.print_help()
        sys.exit(1)

    # Initialize database
    db = DatabaseHandler()
    
    # Initialize appropriate scraper based on website argument
    if args.website == 'goat':
        scraper = GoatScraper()
    else:
        scraper = HMScraper()

    try:
        if args.url:
            # Scrape specific product
            print(f"Scraping product from URL: {args.url}")
            product = scraper.scrape_product(args.url)
            if save_products(db, scraper, [product]) > 0:
                print("Successfully saved product with embedding")
                print("\nProduct details:")
                print(f"Name: {product['name']}")
                print(f"Price: {product['currency']} {product['price']}")
                print(f"Description: {product['description'][:200]}...")
                print(f"URL: {product['url']}")
            else:
                print("Failed to save product")

        if args.search:
            # Search for products
            print(f"Searching for products matching: {args.search}")
            products = scraper.search_products(args.search, args.max_results)
            saved = save_products(db, scraper, products)
            print(f"\nFound {len(products)} products, saved {saved} with embeddings")
            
            print("\nSearch results:")
            for i, product in enumerate(products, 1):
                print(f"\n{i}. {product['name']}")
                print(f"   Price: {product['currency']} {product['price']}")
                print(f"   URL: {product['url']}")

    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)

    finally:
        db.close()
        scraper.vector_store.close()

if __name__ == "__main__":
    main()
