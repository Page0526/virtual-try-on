from langchain_core.tools import BaseTool
import logging 
from typing import Dict, Any, List
from server.features.stylemate.tools.tool_schemas import ProductSearchFunc
from server.services.product import ProductService



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
            "type": "function", 
            "function": {
                "name": tool.name,
                "description": tool.description,
                "parameters": tool.args_schema.schema() if hasattr(tool, "args_schema") else {},
            }
        
        }
        for tool in tools
    ]


# cai dat tools 
class ProductSearchTool(CustomTool): 

    name = "product_search"
    description = "Search for products in the database"
    args_schema = ProductSearchFunc


    def _run(self, query: str): 
        """
        Thực hiện tìm kiếm sản phẩm trong cơ sở dữ liệu
        """
        logger.info(f"Running product search with query: {query}")
        try:
            results = ProductService.search_products(query)
            self._log_action("Product Search", {"query": query, "results": results})
            return results
        except Exception as e:
            logger.error(f"Error during product search: {str(e)}")
            raise

    async def _arun(self, query: str): 

        """
        Thực hiện tìm kiếm sản phẩm trong cơ sở dữ liệu
        """
        logger.info(f"Running product search with query: {query}")
        try:
            results = await ProductService.search_products(query)
            self._log_action("Product Search", {"query": query, "results": results})
            return results
        except Exception as e:
            logger.error(f"Error during product search: {str(e)}")
            raise





def get_tools() -> List[Dict[str, Any]]:
    """
    Trả về danh sách các tools đã được định nghĩa
    """
    tools = [
        ProductSearchTool()
    ]
    return tools_format(tools)




