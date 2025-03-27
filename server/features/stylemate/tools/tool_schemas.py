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
    category : str = Field(..., description="Category to filter the search results")
    limit : int = Field(default=5, description="Number of results to return")



