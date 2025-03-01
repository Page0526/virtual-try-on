#!/usr/bin/env python3
"""
Test script for the Virtual Try-On Recommendation API.
"""
import requests
import argparse
import json
from pathlib import Path

def test_api(image_path, description, category=None, threshold=0.5, limit=3):
    """
    Test the recommendation API by sending a request and printing the response.
    
    Args:
        image_path: Path to the image file
        description: Style preferences and context
        category: Optional item category
        threshold: Minimum similarity score (0-1)
        limit: Maximum recommendations per category
    """
    # API endpoint
    url = "http://localhost:8000/recommendations"
    
    # Prepare form data
    files = {
        'image': open(image_path, 'rb')
    }
    
    data = {
        'description': description,
        'threshold': str(threshold),
        'limit_per_category': str(limit)
    }
    
    if category:
        data['category'] = category
    
    # Send request
    print(f"Sending request to {url}...")
    print(f"Image: {image_path}")
    print(f"Description: {description}")
    if category:
        print(f"Category: {category}")
    print(f"Threshold: {threshold}")
    print(f"Limit per category: {limit}")
    print()
    
    try:
        response = requests.post(url, files=files, data=data)
        
        # Check response
        if response.status_code == 200:
            print("Success! Recommendations received:")
            print("=" * 50)
            
            # Pretty print the JSON response
            recommendations = response.json()["recommendations"]
            for category, products in recommendations.items():
                print(f"\n{category.upper()}:")
                print("-" * 30)
                
                for product in products:
                    print(f"Name: {product['name']}")
                    print(f"Website: {product['website']}")
                    print(f"URL: {product['url']}")
                    print(f"Similarity Score: {product['similarity_score']:.2f}")
                    print()
        
        elif response.status_code == 404:
            print("No matching products found.")
            
        else:
            print(f"Error: {response.status_code}")
            print(response.text)
    
    except Exception as e:
        print(f"Error: {e}")
    
    finally:
        files['image'].close()

def main():
    """Parse command line arguments and call test function."""
    parser = argparse.ArgumentParser(description='Test the Virtual Try-On Recommendation API')
    parser.add_argument('--image', required=True, help='Path to image file')
    parser.add_argument('--description', required=True, help='Style preferences and context')
    parser.add_argument('--category', help='Item category')
    parser.add_argument('--threshold', type=float, default=0.5, help='Similarity score threshold')
    parser.add_argument('--limit', type=int, default=3, help='Maximum recommendations per category')
    
    args = parser.parse_args()
    
    # Check if image file exists
    image_path = Path(args.image)
    if not image_path.exists():
        print(f"Error: Image file not found: {args.image}")
        return
    
    test_api(
        image_path=args.image,
        description=args.description,
        category=args.category,
        threshold=args.threshold,
        limit=args.limit
    )

if __name__ == "__main__":
    main()
