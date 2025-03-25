from datetime import datetime 
"""


"""

class UserModel: 

    collection_name = "user"
    
    @staticmethod 
    def user_helper(user) -> dict : 
        return {
            "id" : user["_id"],
            "fullname" : user["fullname"],
            "phone" : user["phone"],
            "address" : user["address"], 
            "email" : user["email"],
            "is_admin" : user["is_admin"], 
            "password" : user["password"],
            "avatar" : user["avatar"],
            "created_at" : user["created_at"],
            "updated_at" : user["updated_at"]
        }
    
    @staticmethod 
    def create_user(user_data: dict): 
        now = datetime.now()

        return {
            "fullname" : user_data.get("fullname", ""),
            "phone" : user_data.get("phone", ""),
            "address" : user_data.get("address", ""),
            "email" : user_data["email"],
            "password" : user_data["hash_password"],
            "avatar" : user_data.get("avatar", ""),
            "is_admin" : user_data.get("is_admin", False),
            "created_at" : now,
            "updated_at" : now
        }




    