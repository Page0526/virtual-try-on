from pydantic import BaseModel, Field
import logging 


logger = logging.getLogger(__name__)

"""
schema cho du lieu 
"""

class WebSearchFunc(BaseModel): 
    query : str = Field(..., description="Search query to look up on the web")

class ProductSearchFunc(BaseModel): 

    query : str = Field(..., description="Search query to look up on the product database")


class ImageAnalyzerFunc(BaseModel): 
    query : str = Field(..., description="Query used to analyze images for product information")
    image : bytes = Field(..., description="Image data to be analyzed")


class ImageGeneratorFunc(BaseModel):

    query: str = Field(..., description="Detailed description of the fashion style or outfit to visualize")
    style: str = Field(default="realistic", description="Visual style preference (realistic, artistic, casual, etc.)")
    occasion: str = Field(default="casual", description="Occasion for the outfit (casual, formal, party, etc.)")


