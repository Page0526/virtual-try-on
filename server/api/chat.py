from fastapi import APIRouter, UploadFile, File, Form, Depends, HTTPException, Body
from typing import Optional, Dict, Any
from pydantic import BaseModel

from features.stylemate.agent_service import get_agent_service, MessageRequest, AgentService

router = APIRouter(
    prefix="/chat",
    tags=["chat"],
    responses={404: {"description": "Not found"}},
)


@router.post("/text")
async def chat_text( request: MessageRequest,  service: AgentService = Depends(get_agent_service) ):
    
    response = await service.process_text_message(request)
    return response

@router.post("/image")
async def chat_image( query: str = Form(...), image: UploadFile = File(...), user_id: Optional[str] = Form(None), service: AgentService = Depends(get_agent_service)):

    response = await service.process_message_with_image(query, image)
    return response



@router.post("/reset")
async def reset_chat( user_id: Optional[str] = Body(None), service: AgentService = Depends(get_agent_service) ):
    
    response = service.reset_conversation(user_id)
    return response



# Health check endpoint
@router.get("/health")
async def health_check():
    return {"status": "ok", "service": "StyleMate Chat"}
