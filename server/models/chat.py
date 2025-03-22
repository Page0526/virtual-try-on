from datetime import datetime 


class MessageModel: 
    collection_name = "chat_message"

    @staticmethod 
    def message_helper(chat) -> dict: 
        return {
            "id" : str(chat["_id"]),
            "chat_id": chat["chat_id"],
            "user_id" : chat["user_id"],
            "request" : chat["request"],
            "response" : chat["response"],
            "created_at" : chat["created_at"],
        }


    @staticmethod
    def create_message(chat_data) -> dict: 
        now = datetime.now()

        return {
            "chat_id": chat_data.chat_id,
            "user_id" : chat_data.user_id,
            "request" : chat_data.request,
            "response" : chat_data.response,
            "created_at" : now,
        }



class ChatModel: 

    collection_name = "chat_history"

    @staticmethod 
    def chat_history_helper(chat_history) -> dict: 
        return {
            "id" : str(chat_history["_id"]),
            "user_id" : chat_history["user_id"],
            "title": chat_history.get("title", "New Chat") if chat_history.get("title") else "New Chat",
            "last_message" : chat_history["last_message"],
            "created_at" : chat_history["created_at"],
        }
    

    @staticmethod
    def create_chat_history(chat_history_data) -> dict: 
        now = datetime.now()

        return {
            "user_id" : chat_history_data.user_id,
            "title": chat_history_data.title,
            "last_message" : now,
            "created_at" : now,
        }

    @staticmethod 
    def chat_with_message_helper(chat, message): 

        chat_metadata = ChatModel.chat_history_helper(chat)
        chat_metadata['message'] = [ m for m in message ] 
        return chat_metadata




