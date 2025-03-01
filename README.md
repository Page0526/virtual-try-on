# Virtual Try-On Recommendation System

A recommendation system that suggests matching outfit pieces based on visual similarity using LLaVA for analysis and CLIP embeddings for matching.

## Overview

The system analyzes a user's clothing item and suggests matching pieces based on:
1. The uploaded clothing item image
2. User's desired style preferences (e.g., "casual streetwear", "formal office attire")
3. Visual similarity between suggestions and available products

## Usage
chmod +x ./setup.sh
./setup.sh

### FastAPI Application

You can run the recommendation system as a FastAPI application:

```bash
# Run directly
python run_api.py

# Or using Docker Compose (includes MongoDB and Qdrant)
docker-compose up
```

The API will be available at http://localhost:8000 with the following endpoints:

- `GET /`: Root endpoint to check if API is running
- `GET /health`: Health check endpoint
- `POST /recommendations`: Get outfit recommendations

You can also access the interactive API documentation at http://localhost:8000/docs

#### Using the API

To get recommendations via the API, send a POST request to `/recommendations` with:

- `image`: The clothing item image file
- `description`: User's style preferences (e.g., "casual streetwear with earth tones")
- `category`: (Optional) Item category
- `threshold`: (Optional) Minimum similarity score (0-1, default: 0.5)
- `limit_per_category`: (Optional) Maximum recommendations per category (default: 3)

Example using the test script:
```bash
python test_api.py \
  --image path/to/image.jpg \
  --description "Want a casual streetwear look with earth tones" \
  --category tops \
  --threshold 0.5 \
  --limit 3
```

Or using curl:
```bash
curl -X POST http://localhost:8000/recommendations \
  -F "image=@path/to/image.jpg" \
  -F "description=Want a casual streetwear look with earth tones" \
  -F "category=tops" \
  -F "threshold=0.5" \
  -F "limit_per_category=3"
```

### Command Line Interface

```bash
python -m src.recommendation.cli \
  --image path/to/image.jpg \
  --description "Want a casual streetwear look with earth tones" \
  --category tops \
  --limit 3 \
  --threshold 0.7
```

Arguments:
- `--image`: Path to clothing item image
- `--description`: Your desired style preferences (not image description)
- `--category`: Item category (tops/bottoms/footwear/accessories)
- `--limit`: Max recommendations per category (default: 3)
- `--threshold`: Minimum similarity score 0-1 (default: 0.7)

Example Style Descriptions:
- "Looking for a minimalist Scandinavian style outfit"
- "Need formal office attire in dark colors"
- "Want a sporty casual look for summer"
- "Seeking vintage-inspired streetwear pieces"

### Python API

```python
from src.recommendation.vlm import UserItem
from src.recommendation.recommendation_handler import RecommendationHandler

# Initialize item with style preferences
user_item = UserItem(
    image="path/to/image.jpg",
    description="Want a casual streetwear look with earth tones",
    category="tops"
)

# Get recommendations
recommender = RecommendationHandler()
try:
    recommendations = recommender.get_recommendations(
        user_item,
        limit_per_category=3,
        score_threshold=0.7
    )
    
    # Process results by category
    for category, results in recommendations.items():
        print(f"\n{category.upper()}:")
        for product in results:
            print(f"Suggestion: {product['suggestion']}")
            print(f"Product: {product['name']}")
            print(f"Score: {product['similarity_score']:.2f}")
finally:
    recommender.close()
```

## How It Works

1. Input Processing:
   - User provides an image and style preferences
   - LLaVA analyzes the image and suggests matching items based on preferences
   - CLIP generates embeddings for suggestions

2. Product Matching:
   - System compares suggestion embeddings with product image embeddings
   - Finds products with similar visual characteristics
   - Returns best matches organized by category

3. Data Storage:
   - Product details stored in MongoDB
   - Image embeddings stored in Qdrant
   - Fast similarity search using vector indexing

## System Components

- `src/recommendation/`
  - `vlm.py`: LLaVA analysis and CLIP embeddings
  - `recommendation_handler.py`: Core recommendation logic
  - `cli.py`: Command-line interface

- `src/database/`
  - `vector_store.py`: Qdrant vector similarity search
  - `db_handler.py`: MongoDB product storage

- `src/scrapers/`
  - `base_scraper.py`: Base scraping functionality
  - Product-specific scrapers (H&M, GOAT)

- `API and Deployment`
  - `src/api.py`: FastAPI application
  - `run_api.py`: Script to run the API server
  - `test_api.py`: Script to test the API
  - `Dockerfile`: Docker container definition
  - `docker-compose.yml`: Multi-container Docker setup

## Troubleshooting

If no recommendations are found:
1. Make your style description more specific
2. Lower the similarity threshold (--threshold)
3. Increase the number of results per category (--limit)

If services aren't connecting:
1. Check if Ollama is running: `ollama run llava`
2. Check if Qdrant is running: `docker ps`
3. Check if MongoDB is running: `mongod`
