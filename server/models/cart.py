from datetime import datetime

class CartModel : 
    collection_name = "cart"


    @staticmethod 
    def cart_helper(cart) -> dict: 
        return {
            "id" : str(cart["_id"]),
            "user_id" : cart["user_id"],
            "items" : cart["items"],
            "total_price" : cart["total_price"],
            "total_items" : cart["total_items"],
            "created_at" : cart["created_at"],
            "updated_at" : cart["updated_at"]
        }
    

    @staticmethod 
    def create_cart(cart_data) -> dict: 
        now = datetime.now()

        return {
            "user_id" : cart_data.user_id,
            "items" : [],
            "total_price" : cart_data.total_price,
            "total_items" : 0,
            "created_at" : now,
            "updated_at" : now
        }
    

    @staticmethod
    def add_product_to_cart(cart, product_data, quantity) -> dict: 
        now = datetime.now()
        cart_item = cart.get("items", [])

        if str(product_data["id"]) not in [str(item["product_id"]) for item in cart_item]:
            cart_item.append({
                "product_id": product_data["id"],
                "quantity": quantity,
                "price": product_data["price"]
            })
        else:
            for item in cart_item:
                if str(item["product_id"]) == str(product_data["id"]):
                    item["quantity"] += quantity
                    break
        cart["items"] = cart_item
        cart["total_price"] = sum(item["price"] * item["quantity"] for item in cart_item)
        cart["total_items"] = sum(item["quantity"] for item in cart_item)
        cart["updated_at"] = now

      
        return cart 


    @staticmethod 
    def remove_product_from_cart(cart, product_id) -> dict: 
        now = datetime.now()

        cart_items = [item for item in cart["items"] if str(item["product_id"]) != str(product_id)]
        cart["items"] = cart_items

        cart["total_price"] = sum(item["price"] * item["quantity"] for item in cart_items)
        cart["total_items"] = sum(item["quantity"] for item in cart_items)
        cart["updated_at"] = now
        

    @staticmethod 
    def update_cart(cart, product_id, quantity) -> dict: 
        now = datetime.now()

        for item in cart["items"]:
            if str(item["product_id"]) == str(product_id):
                item["quantity"] = quantity
                break

        cart["total_price"] = sum(item["price"] * item["quantity"] for item in cart["items"])
        cart["total_items"] = sum(item["quantity"] for item in cart["items"])
        cart["updated_at"] = now
        return cart


