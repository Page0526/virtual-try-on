from datetime import datetime


class RecommendModel: 

    collection_name = "recommend"

    @staticmethod 
    def recommend_helper(recommend) -> dict: 
        return {
            "id" : str(recommend["_id"]),
            "user_id" : recommend["user_id"],
            "product_ids" : recommend["product_id"],
            "recommend" : recommend["recommend"], # lưu list đường dẫn onlien tới ảnh
            "created_at" : recommend["created_at"],
            "updated_at" : recommend["updated_at"]
        }

    @staticmethod
    def create_recommend(recommend_data) -> dict: 
        now = datetime.now()

        return {
            "user_id" : recommend_data.user_id,
            "product_ids" : recommend_data.product_ids,
            "recommend" : recommend_data.recommend, # lưu list đường dẫn onlien tới ảnh
            "created_at" : now,
            "updated_at" : now
        }



class WardrobeModel : 

    collection_name = "wardrobe"

    @staticmethod
    def wardrobe_helper(wardrobe) -> dict: 
        return {
            "id" : str(wardrobe["_id"]),
            "user_id" : wardrobe["user_id"],
            "image" : wardrobe["image"],   # lưu đường dẫn tới ảnh 
            "type" : wardrobe["type"],

            "created_at" : wardrobe["created_at"],
            "updated_at" : wardrobe["updated_at"]
        }
    

    @staticmethod
    def create_wardrobe(wardrobe_data) -> dict: 
        now = datetime.now()

        return {
            "user_id" : wardrobe_data.user_id,
            "product_id" : wardrobe_data.product_id,
            "created_at" : now,
            "updated_at" : now
        }
    

    @staticmethod
    def create_wardrobe_with_recommend(wardrobe_data, recommend) -> dict: 
        now = datetime.now()
        
        metadata = WardrobeModel.wardrobe_helper(wardrobe_data)
        if metadata["type"] == "recommend":
            metadata["recommend"] = recommend
        else:
            metadata["recommend"] = None
        return metadata