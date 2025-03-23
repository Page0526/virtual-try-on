from pydantic import BaseModel, Field




class CartBase(BaseModel):
    id: str = Field(default=None)
    user_id: str
    product_id: str
    quantity: int
    create_at: str
    update_at: str