from typing import List, Dict, Optional
from .vlm import VLM, UserItem, Suggestion
from ..database.vector_store import VectorStore
import logging

logger = logging.getLogger(__name__)

class RecommendationHandler:
    def __init__(self):
        self.vlm = VLM()
        self.vector_store = VectorStore()

    def get_recommendations(
        self,
        user_item: UserItem,
        limit_per_category: int = 3,
        score_threshold: float = 0.5  # Lower threshold since we're comparing text with text
    ) -> Dict[str, List[Dict]]:
        """
        Get product recommendations based on VLM suggestions.
        
        The workflow:
        1. Get suggestions from LLaVA (via Ollama API) for specific product types
        2. For each suggestion:
           - Search for products in the database with matching category
           - Compare embeddings to find similar items
        3. Return best matching products
        
        Args:
            user_item: User's uploaded item
            limit_per_category: Maximum number of recommendations per category
            score_threshold: Minimum similarity score threshold
            
        Returns:
            Dictionary of recommendations by category
        """
        try:
            # Get VLM suggestions with embeddings
            suggestions = self.vlm.analyze_item(user_item)
            
            # Initialize recommendations
            recommendations = {}
            
            # Process each category
            for category, category_suggestions in suggestions.items():
                category_results = []
                
                # Find matches for each suggestion in the category
                for suggestion in category_suggestions:
                    # Search Qdrant using suggestion embedding
                    # Only search within the same category
                    matches = self.vector_store.search_similar(
                        vector=suggestion.embedding,
                        limit=limit_per_category,
                        score_threshold=score_threshold,
                        category=category
                    )
                    
                    # Add matches to results
                    for match in matches:
                        result = {
                            'name': match['metadata']['name'],
                            'url': match['metadata']['url'],
                            'website': match['metadata']['website'],
                            'similarity_score': match['score']
                        }
                        category_results.append(result)
                
                # Sort by score and take top N unique products
                category_results.sort(key=lambda x: x['similarity_score'], reverse=True)
                
                # Remove duplicates while preserving order
                seen_products = set()
                unique_results = []
                for result in category_results:
                    product_key = (result['name'], result['url'])
                    if product_key not in seen_products:
                        seen_products.add(product_key)
                        unique_results.append(result)
                        if len(unique_results) >= limit_per_category:
                            break
                
                if unique_results:
                    recommendations[category] = unique_results
            
            return recommendations
            
        except Exception as e:
            logger.error(f"Error getting recommendations: {e}")
            return {}

    def close(self):
        """Clean up resources."""
        self.vector_store.close()
