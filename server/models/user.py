from datetime import datetime 


class UserModel: 

    collection_name = "users"
    
    @staticmethod 
    def user_helper(user) -> dict : 
        return {
            "id" : str(user["_id"]),
            "username" : user["username"],
            "fullname" : user["fullname"],
            "phone" : user["phone"],
            "address" : user["address"], 
            "email" : user["email"],
            "password" : user["password"],
            "created_at" : user["created_at"],
            "updated_at" : user["updated_at"]
        }
    

    def create_user(user_data): 
        now = datetime.now()

        return {
            "username" : user_data.username, 
            "fullname" : user_data.fullname,
            "phone" : user_data.phone,
            "address" : user_data.address,
            "email" : user_data.email,
            "password" : user_data.password,
            "created_at" : now,
            "updated_at" : now
        }




    