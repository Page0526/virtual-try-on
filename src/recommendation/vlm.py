import requests
import base64
from PIL import Image
from io import BytesIO
from dataclasses import dataclass
from typing import List, Dict, Optional, Union
from transformers import CLIPProcessor, CLIPModel
import torch
import numpy
import logging
import re

logger = logging.getLogger(__name__)

@dataclass
class UserItem:
    image: Union[str, bytes, Image.Image]  # File path, bytes, or PIL Image
    description: str  # User's style preferences and context
    category: Optional[str] = None

@dataclass
class Suggestion:
    text: str
    embedding: List[float]
    category: str

class VLM:
    def __init__(self):
        self.device = "cuda" if torch.cuda.is_available() else "cpu"
        # CLIP for generating embeddings
        self.clip_model = CLIPModel.from_pretrained("openai/clip-vit-base-patch32").to(self.device)
        self.clip_processor = CLIPProcessor.from_pretrained("openai/clip-vit-base-patch32")
        
        # Ollama API endpoint
        self.ollama_url = "http://localhost:11434/api/generate"
        self.model = "llava"
        
        # Detailed clothing categories
        self.category_keywords = {
            't-shirt': ['t-shirt', 'tee', 'tshirt'],
            'shirt': ['shirt', 'button-up', 'button-down', 'polo'],
            'sweater': ['sweater', 'sweatshirt', 'pullover'],
            'hoodie': ['hoodie', 'hooded'],
            'jacket': ['jacket', 'blazer', 'coat'],
            'jeans': ['jeans', 'denim'],
            'pants': ['pants', 'trousers', 'chinos', 'slacks'],
            'shorts': ['shorts', 'short'],
            'skirt': ['skirt', 'dress'],
            'sneakers': ['sneakers', 'sneaker', 'trainers'],
            'boots': ['boots', 'boot'],
            'sandals': ['sandals', 'sandal', 'slides'],
            'hat': ['hat', 'cap', 'beanie'],
            'bag': ['bag', 'backpack', 'tote'],
            'accessories': ['watch', 'sunglasses', 'belt', 'scarf', 'gloves']
        }

    def analyze_item(self, item: UserItem) -> Dict[str, List[Suggestion]]:
        """
        Analyze clothing item and generate suggestions with embeddings.
        
        Args:
            item: UserItem containing:
                - image: The clothing item image
                - description: User's style preferences and context
                - category: Optional item category
        """
        try:
            # Load and encode image
            if isinstance(item.image, str):
                image = Image.open(item.image)
            elif isinstance(item.image, bytes):
                image = Image.open(BytesIO(item.image))
            else:
                image = item.image
            
            # Convert to RGB if needed
            if image.mode in ('RGBA', 'LA') or (image.mode == 'P' and 'transparency' in image.info):
                background = Image.new('RGB', image.size, (255, 255, 255))
                if image.mode == 'RGBA':
                    background.paste(image, mask=image.split()[3])
                else:
                    background.paste(image)
                image = background
            elif image.mode != 'RGB':
                image = image.convert('RGB')
            
            # Convert image to base64
            buffered = BytesIO()
            image.save(buffered, format="JPEG", quality=95)
            img_str = base64.b64encode(buffered.getvalue()).decode()

            # Prepare prompt for LLaVA
            prompt = f"""Looking at this {item.category or 'clothing item'}.
Style Context: {item.description}

Based on the user's context, suggest specific clothing items (e.g: black baggy jeans, harrington jacket)(only items name) that would complement this item and match the desired style."""

            # Call Ollama API
            response = requests.post(
                self.ollama_url,
                json={
                    "model": self.model,
                    "prompt": prompt,
                    "images": [img_str],
                    "stream": False
                }
            )
            response.raise_for_status()
            
            # Parse suggestions and generate embeddings
            suggestions_text = response.json()["response"]
            print(suggestions_text)
            logger.info(f"LLaVA Response:\n{suggestions_text}")
            return self._parse_suggestions(suggestions_text)

        except Exception as e:
            logger.error(f"Error analyzing item: {e}")
            return {}

    def _parse_suggestions(self, response: str) -> Dict[str, List[Suggestion]]:
        """Parse VLM response and generate embeddings for suggestions."""
        suggestions = {}
        
        try:
            # Split response into lines and process each one
            lines = response.lower().split('\n')
            
            for line in lines:
                line = line.strip()
                if not line:
                    continue
                
                # Look for clothing items in the line
                for category, keywords in self.category_keywords.items():
                    for keyword in keywords:
                        if keyword in line:
                            # Extract the full item description
                            # Find any descriptive text around the keyword
                            pattern = r'(?:[a-z-]+ )*' + keyword + r'(?: [a-z-]+)*'
                            matches = re.findall(pattern, line)
                            
                            for match in matches:
                                suggestion_text = match.strip()
                                if suggestion_text:
                                    # Generate embedding for suggestion
                                    embedding = self._generate_text_embedding(suggestion_text)
                                    if embedding:
                                        # Apply additional normalization
                                        embedding = numpy.array(embedding)
                                        embedding = embedding / numpy.linalg.norm(embedding)
                                        # Scale to match product name embeddings
                                        embedding = embedding * 100
                                        
                                        suggestion = Suggestion(
                                            text=suggestion_text,
                                            embedding=embedding.tolist(),
                                            category=category
                                        )
                                        
                                        if category not in suggestions:
                                            suggestions[category] = []
                                        suggestions[category].append(suggestion)
                                        logger.info(f"Added suggestion: {suggestion_text} ({category})")
            
            return suggestions
            
        except Exception as e:
            logger.error(f"Error parsing suggestions: {e}")
            return {}

    def _generate_text_embedding(self, text: str) -> Optional[List[float]]:
        """Generate CLIP embedding for text."""
        try:
            inputs = self.clip_processor(
                text=text,
                return_tensors="pt",
                padding=True
            ).to(self.device)
            
            with torch.no_grad():
                text_features = self.clip_model.get_text_features(**inputs)
                
            # Normalize and convert to list
            embedding = text_features[0].cpu().numpy()
            embedding = embedding / numpy.linalg.norm(embedding)
            return embedding.tolist()
            
        except Exception as e:
            logger.error(f"Error generating text embedding: {e}")
            return None
