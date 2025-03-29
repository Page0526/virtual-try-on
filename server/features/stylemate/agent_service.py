from typing import Optional, Dict, Any
import io
from fastapi import HTTPException, UploadFile
from pydantic import BaseModel

from .chatbot.agent import StyleMate

class MessageRequest(BaseModel):
    query: str
    user_id: Optional[str] = None


class AgentService:
    """Service to handle interactions with StyleMate agent"""
    _instance = None

    def __new__(cls):
        """Implement singleton pattern for agent service"""
        if cls._instance is None:
            cls._instance = super(AgentService, cls).__new__(cls)
            cls._instance._agent = None
        return cls._instance

    @property
    def agent(self) -> StyleMate:
        """Lazy initialization of the StyleMate agent"""
        if self._agent is None:
            try:
                self._agent = StyleMate()
            except Exception as e:
                raise HTTPException(status_code=500, detail=f"Failed to initialize StyleMate agent: {str(e)}")
        return self._agent
    
     
    async def process_text_message(self, request: MessageRequest) -> Dict[str, Any]:
        """Process a text message from the user"""
        try:
            response = self.agent.process_message(request.query)
            return {
                "response": response,
                "success": True
            }
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Error processing message: {str(e)}")

    async def process_message_with_image(self, query: str, image_file: UploadFile) -> Dict[str, Any]:
        try:
            image_bytes = await image_file.read()
            response = self.agent.process_message(query, image=image_bytes)
            
            return {
                "response": response,
                "success": True
            }
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Error processing message with image: {str(e)}")

    def reset_conversation(self, user_id: Optional[str] = None) -> Dict[str, Any]:
        try:
            
            self.agent.memory.clear()
            return {
                "message": "Conversation history cleared successfully",
                "success": True
            }
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Failed to reset conversation: {str(e)}")


def get_agent_service():
    return AgentService()