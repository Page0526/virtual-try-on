from datetime  import datetime



class ProductModel : 

    collection_name = "product"

    @staticmethod 
    def product_helper(product) -> dict: 

        return {
            "id" : str(product["_id"]),
            "name" : product["name"],
            "brand" : product["brand"],
            "description" : product["description"],
            "price" : product["price"],
            "quantity" : product["quantity"],
            "category" : product["category"],
            "image": product["image"],      # lưu list đường dẫn onlien tới ảnh 
            "created_at" : product["created_at"],
            "updated_at" : product["updated_at"]
        }
    

    @staticmethod 
    def create_product(product_data) -> dict: 

        now = datetime.now()
        return {
            "name" : product_data.name,
            "brand" : product_data.brand,
            "description" : product_data.description,
            "price" : product_data.price,
            "quantity" : product_data.quantity,
            "category" : product_data.category,
            "image": product_data.image,      # lưu list đường dẫn onlien tới ảnh 
            "created_at" : now,
            "updated_at" : now
        }
    




    

