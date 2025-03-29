# utils/response_handler.py
from typing import Any, Optional, Dict
from fastapi.responses import JSONResponse
from datetime import datetime

class ResponseHandler:
    @staticmethod
    def success(data: Any, status_code: int = 200) -> JSONResponse:
        return JSONResponse(
            content={"status": "success", "data": data, "timestamp": datetime.utcnow().isoformat()},
            status_code=status_code
        )

    @staticmethod
    def not_found(entity: str, identifier: str, status_code: int = 404) -> JSONResponse:
        return JSONResponse(
            content={"status": "error", "message": f"{entity} với {identifier} không tồn tại", "timestamp": datetime.utcnow().isoformat()},
            status_code=status_code
        )

    @staticmethod
    def error(message: str, status_code: int = 500, details: Optional[dict] = None) -> JSONResponse:
        response = {"status": "error", "message": message, "timestamp": datetime.utcnow().isoformat()}
        if details:
            response["details"] = details
        return JSONResponse(content=response, status_code=status_code)

    @staticmethod
    def created(data: Any, status_code: int = 201) -> JSONResponse:
        return JSONResponse(
            content={"status": "success", "data": data, "message": "Tạo mới thành công", "timestamp": datetime.utcnow().isoformat()},
            status_code=status_code
        )
    
    @staticmethod
    def tryon_success(
        result_url: str, 
        mask_url: Optional[str] = None, 
        densepose_url: Optional[str] = None
    ) -> Dict[str, Any]:
        """Tạo response thành công cho try-on."""
        response = {
            "status": "success",
            "result_url": result_url
        }
        
        # Thêm các URL phụ nếu có
        if mask_url:
            response["mask_url"] = mask_url
        if densepose_url:
            response["densepose_url"] = densepose_url
            
        return response