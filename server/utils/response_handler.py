from fastapi import HTTPException, status


class ResponseHandler: 
    """
    Xu ly response toi client
    """

    @staticmethod 
    def success(message: str, data: dict = None):
        return {
            "message": message,
            "data": data
        }

    @staticmethod 
    def create_success(name: str,   data: dict = None):
        message = f"{name} with id created successfully"
        return {
                "message": message,
                "data": data
            }

    @staticmethod 
    def update_success(name: str, id: str, data: dict = None): 
        message = f"{name} with id {id} updated successfully"
        return {
                "message": message,
                "data": data
            } 
    
    @staticmethod 
    def existed(name: str): 
        message = f"{name} already exists"

        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail=message
        )

    @staticmethod 
    def not_found(name: str, id: str): 
        message = f"{name} with id {id} not found"
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=message
        )
    