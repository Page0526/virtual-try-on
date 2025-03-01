import argparse
from .vlm import UserItem
from .recommendation_handler import RecommendationHandler
import logging

logger = logging.getLogger(__name__)

def main():
    parser = argparse.ArgumentParser(description='Get outfit recommendations')
    parser.add_argument('--image', required=True, help='Path to image file')
    parser.add_argument('--description', required=True, help='Style preferences and context')
    parser.add_argument('--category', help='Item category')
    parser.add_argument('--threshold', type=float, default=0.5, help='Similarity score threshold')
    args = parser.parse_args()
    
    # Initialize recommendation handler
    handler = RecommendationHandler()
    
    try:
        # Create user item
        user_item = UserItem(
            image=args.image,
            description=args.description,
            category=args.category
        )
        
        # Get recommendations
        recommendations = handler.get_recommendations(
            user_item=user_item,
            score_threshold=args.threshold
        )
        
        # Print recommendations
        print("\nRecommended products:")
        print("=" * 50)
        print()
        
        if not recommendations:
            print("No matching products found.")
            return
            
        for category, products in recommendations.items():
            if products:
                print(f"{category.upper()}:")
                print("-" * 30)
                print()
                
                for product in products:
                    print(f"{product['name']}")
                    print(f"From: {product['website']}")
                    print(f"URL: {product['url']}")
                    print()
                
                print()
        
    except Exception as e:
        logger.error(f"Error: {e}")
        print("An error occurred while getting recommendations.")
    
    finally:
        handler.close()

if __name__ == '__main__':
    main()
