import base64
import io
from langchain_core.tools import BaseTool
import logging 
from typing import Dict, Any, List, Union
import sys 
import os 
import asyncio
from langchain_community.utilities.google_search import GoogleSearchAPIWrapper
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain_core.messages import HumanMessage
import json 
from PIL import Image


# Add parent directory to sys.path to allow importing from parent modules
sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))))


from tools.tool_schemas import ProductSearchFunc, WebSearchFunc, ImageAnalyzerFunc, ImageGeneratorFunc
from services.product import ProductService
from core.qdrant import get_qdrant_db
from config.setting  import settings
logger = logging.getLogger(__name__)

class CustomTool(BaseTool): 

    name : str
    description : str 


    def _log_action(self, action: str, details: Dict[str, Any]) -> None:
        """Ghi lại hành động vào log."""
        if details : 

            logger.debug(f"Action: {action}, Details: {details}")
        else:
            logger.debug(f"Action: {action}")


def tools_format(tools: List[BaseTool])  -> List[Dict[str, Any]]:
    """
    openai function format 
    """
    return [
        {
            "name": tool.name,
            "description": tool.description,
            "parameters": tool.args_schema.schema() if hasattr(tool, "args_schema") else {},
        }
        for tool in tools
    ]


class ProductSearchTool(CustomTool): 

    name : str = "product_search"
    description : str = "Search for products in the database"
    args_schema : type = ProductSearchFunc


    def _run(self, query: str): 
        """
        Thực hiện tìm kiếm sản phẩm trong cơ sở dữ liệu
        """
        logger.info(f"Running product search with query: {query}")
        try:
            qdrant = get_qdrant_db()
            results = ProductService.search_products(query, qdrant, limit = 3)
 
            filtered_results = "Here is information about some products you are looking to search for: \n"
            for product in results:
    
                product_str = ""
                for key, value in product.items():
                    if key in ['name', 'description', 'price', 'brand'] and value:
                        product_str += f"{key.capitalize()}: {value}\n"
                filtered_product = product_str.strip()
                filtered_results += f"{filtered_product}\n\n"
            
            self._log_action("Product Search", {"query": query, "results": filtered_results})
            return filtered_results
        except Exception as e:
            logger.error(f"Error during product search: {str(e)}")
            raise

   


class WebsearchTool(CustomTool): 

    name : str = "web_search"
    description : str = "Tìm kiếm thông t"
    args_schema : type = WebSearchFunc

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        self.search = GoogleSearchAPIWrapper(
            google_api_key= settings.GOOGLE_API_KEY,
            google_cse_id= settings.GOOGLE_CSE_ID,
            num_results=5,
            search_type="web",
        )

    def _run(self, query: str): 
        """
        Thực hiện tìm kiếm sản phẩm trên web
        """
        
        logger.info(f"Running web search with query: {query}")
        
        try: 
            search_result = self.search.run(query, num_results  = 5)
            if not search_result: 
                logger.warning("No search results found.")
                return []
            
            final_results = []
            for idx, result in enumerate(search_result):
                title = result.get("title", "")
                snippet = result.get("snippet", "")
                link = result.get("link", "")
                final_results.append(f"{idx + 1}. {title} - {snippet} - {link}") 

            self._log_action("Web Search", {"query": query, "results": final_results})
            return "This is the result of web search: " + "\n".join(final_results)
        
        except Exception as e:
            logger.error(f"Error during web search: {str(e)}")
            raise



    async def _arun(self, query: str): 
        """
        Thực hiện tìm kiếm sản phẩm trên web
        """
        logger.info(f"Running web search with query: {query}")
        # Implement web search logic here
        pass




class ImageAnalyzerTool(CustomTool): 

    name : str = "image_analyzer"
    description : str = "Analyze fashion images and provide style assessment, outfit recommendations, and fashion advice based on the image"
    args_schema : type = ImageAnalyzerFunc

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        self.vision_model = ChatGoogleGenerativeAI( 
            model = settings.GEMINI_APIKEY, 
            temperature = 0.4, 
            gooogle_api_key = settings.GOOGLE_API_KEY,

        )

    def _analysis_prompt(self, query: str) -> str:
        """
        Tạo prompt cho phân tích hình ảnh
        """

        prompt = f"""
        # Professional Fashion Analysis

        ## User uploaded image
        Please thoroughly analyze this fashion image and answer the user's question: "{query}"

        ## Detailed Analysis
        1. **Overview description**: Describe all items, colors, and styles
        2. **Fashion style**: Identify the style (casual, formal, streetwear, vintage, minimalist, etc.)
        3. **Colors & patterns**: Analyze the color palette and color coordination
        4. **Materials**: Identify materials if possible
        5. **Overall assessment**: Evaluate harmony, suitability, and fashion sense
        
        ## Comments & Suggestions
        1. **Strengths**: Mention 2-3 best aspects of this outfit
        2. **Improvement suggestions**: Suggest 1-2 things that could be adjusted or improved
        3. **Outfit recommendations**: Suggest 2-3 additional items or accessories to complete the outfit
        4. **Suitable occasions**: Mention occasions appropriate for this outfit
        
        ## Specific Answer
        Directly answer the user's question: "{query}"

        """
        return prompt
    



    def _run(self, input_data : Union[str, Dict]): 
        """
        Thực hiện phân tích hình ảnh
        """
        try : 


            # xu ly anh dau vao 
            if isinstance(input_data, str):
                try : 
                    data = json.loads(input_data)
                except json.JSONDecodeError:
                    raise ValueError("Invalid JSON string")
            
            else : data = input_data 

            image = data.get("image")
            query = data.get("query", "Analyze fashion style in this image")

            if not image or image == None : 
                raise ValueError("Image data is required for analysis")

            
            if isinstance(image, str)  and not image == None: 
                if "base64" in image: 
                    image = image.split("base64, ")[1]
                
                try : 
                    image_bytes = base64.b64decode(image)
                except Exception as e:
                    logger.error(f"Error decoding base64 image: {str(e)}")

            elif isinstance(image, bytes):
                image_bytes = image


            try : 
                image = Image.open(io.BytesIO(image_bytes))
            except Exception as e:
                logger.error(f"Error opening image: {str(e)}")
                raise ValueError("Invalid image data")
            

            prompt = self._analysis_prompt(query)
            
            message = HumanMessage(
                content=[
                    {"type": "text", "text": prompt},
                    {"type": "image_url", "image_url": {"url": image}}
                ]
            )
            
            # Generate analysis with LangChain's model
            response = self.vision_model.invoke([message])
            analysis_result = response.content
            
            self._log_action("Image Analysis", {"query": query, "analysis_length": len(analysis_result)})
            
            return analysis_result

        except Exception as e:
            logger.error(f"Error during image analysis: {str(e)}")
            raise ValueError(f"Error during image analysis: {str(e)}")


    async def _arun(self, query: str): 
        logger.info(f"Running image analysis with query: {query}")
        pass




class ImageGenerationTool(CustomTool): 

    name : str = "image_generation"
    description : str = "Generate visual concepts and detailed descriptions of fashion outfits, styles, and clothing combinations"
    args_schema : type = ImageGeneratorFunc


    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        self.image_model = ChatGoogleGenerativeAI( 
            model = settings.VISION_GEMINI, 
            temperature = 0.4, 
            gooogle_api_key = settings.GOOGLE_API_KEY,
        )

    def _generation_prompt(self, query: str, style: str, occasion: str ) -> str:

        prompt = f""" 
        # Detailed Fashion Description
        
        Create a detailed and vivid description of a fashion outfit based on the following requirements:
        
        ## User Requirements
        {query}
        
        ## Visual Style: {style}
        ## Occasion: {occasion}
        
        Please describe in detail:
        
        1. **Clothing Details**: Describe each item in the outfit in detail (style, color, material, pattern)
        2. **Outfit Coordination**: How the items are combined together
        3. **Accessories**: Accompanying accessories such as shoes, bags, jewelry
        4. **Hair and Makeup**: If appropriate for the requirements
        5. **Context**: Environment or situation suitable for this outfit
        
        Create a vivid description so readers can clearly imagine the outfit, as if they are looking at an actual fashion photograph.
        """       
        return prompt


    def _run(self, input_data : Union[str, Dict]) -> str: 
        
        try : 

            if isinstance(input_data, str): 
                try : 
                    data = json.loads(input_data)
                except json.JSONDecodeError:
                    raise ValueError("Invalid JSON string")
                
            else : data = input_data


            query = data.get("query", "Create a fashion outfit")
            style = data.get("style", "realistic")
            occasion = data.get("occasion", "casual")


            if not query or query == None : 
                raise ValueError("Query is required for image generation")
            

            prompt = self._generation_prompt(query, style, occasion)

            message = HumanMessage(
                content=[
                    {"type": "text", "text": prompt}
                ]
            )

            response = self.image_model.invoke([message])
            generation_result = response.content

            self._log_action("Fashion Concept Generation", {"prompt": prompt, "style": style, "occasion": occasion})
           
            return generation_result 


        except Exception as e:
            logger.error(f"Error during image generation: {str(e)}")
            raise ValueError(f"Error during image generation: {str(e)}")




    async def _arun(self, query: str): 
        """
        Thực hiện tạo hình ảnh
        """
        logger.info(f"Running image generation with query: {query}")
        # Implement image generation logic here
        pass







def get_tools() -> List[Dict[str, Any]]:
    """
    Trả về danh sách các tools đã được định nghĩa
    """
    tools = [
        ProductSearchTool(), 
        # WebsearchTool(),
        # ImageAnalyzerTool(),    
        # ImageGenerationTool()
    ]
    return tools




