from fastapi import FastAPI, UploadFile, File, Form, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from typing import Optional, Dict, List
import io
from PIL import Image
import logging
import uvicorn
from dotenv import load_dotenv

from src.recommendation.vlm import UserItem
from src.recommendation.recommendation_handler import RecommendationHandler

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
)
logger = logging.getLogger(__name__)

# Load environment variables
load_dotenv()

# Create FastAPI app
app = FastAPI(
    title="Virtual Try-On Recommendation API",
    description="API for getting outfit recommendations based on clothing items",
    version="1.0.0",
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)

@app.get("/")
async def root():
    """Root endpoint to check if API is running."""
    return {"message": "Virtual Try-On Recommendation API is running"}

@app.get("/health")
async def health_check():
    """Health check endpoint."""
    return {"status": "healthy"}

@app.post("/recommendations")
async def get_recommendations(
    image: UploadFile = File(...),
    description: str = Form(...),
    category: Optional[str] = Form(None),
    threshold: Optional[float] = Form(0.5),
    limit_per_category: Optional[int] = Form(3),
):
    """
    Get outfit recommendations based on an uploaded clothing item.
    
    Args:
        image: The clothing item image
        description: User's style preferences and context
        category: Optional item category
        threshold: Minimum similarity score (0-1)
        limit_per_category: Maximum number of recommendations per category
        
    Returns:
        JSON response with recommendations by category
    """
    try:
        # Initialize recommendation handler
        handler = RecommendationHandler()
        
        try:
            # Read and validate image
            contents = await image.read()
            try:
                img = Image.open(io.BytesIO(contents))
                img.verify()  # Verify it's a valid image
            except Exception as e:
                raise HTTPException(status_code=400, detail=f"Invalid image: {str(e)}")
            
            # Create user item
            user_item = UserItem(
                image=contents,
                description=description,
                category=category
            )
            
            # Get recommendations
            recommendations = handler.get_recommendations(
                user_item=user_item,
                score_threshold=threshold,
                limit_per_category=limit_per_category
            )
            
            # Return recommendations
            if not recommendations:
                return JSONResponse(
                    status_code=404,
                    content={"message": "No matching products found"}
                )
                
            return {"recommendations": recommendations}
            
        except Exception as e:
            logger.error(f"Error processing recommendation: {e}")
            raise HTTPException(status_code=500, detail=str(e))
        
        finally:
            handler.close()
            
    except Exception as e:
        logger.error(f"Error initializing recommendation handler: {e}")
        raise HTTPException(status_code=500, detail=str(e))

def start():
    """Run the API server using uvicorn."""
    uvicorn.run("src.api:app", host="0.0.0.0", port=8000, reload=True)

if __name__ == "__main__":
    start()
