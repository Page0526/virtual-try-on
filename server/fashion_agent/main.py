import os
import sys
import time
import uuid
import logging
import re
from typing import Dict, Optional
from fastapi import FastAPI, HTTPException, Request, BackgroundTasks
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from pydantic import BaseModel
from dotenv import load_dotenv


sys.path.append(os.path.dirname(os.path.abspath(__file__)))
from chatbot.agent import FashionAgent

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    filename='fashion_api.log'
)
logger = logging.getLogger('fashion_api')

load_dotenv()

# Định nghĩa models cho API
class ChatRequest(BaseModel):
    message: str
    session_id: Optional[str] = None

class ChatResponse(BaseModel):
    response: str
    session_id: str
    

chat_sessions = {}
os.makedirs("static", exist_ok=True)
os.makedirs("templates", exist_ok=True)

# Tạo ứng dụng FastAPI
app = FastAPI(
    title="Fashion Agent API",
    description="API for interacting with a fashion-oriented AI assistant",
    version="1.0.0"
)

# Cấu hình CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
app.mount("/static", StaticFiles(directory="static"), name="static")

# Set up templates
templates = Jinja2Templates(directory="templates")


def get_or_create_session(session_id: Optional[str] = None) -> tuple:
    """
    Tạo hoặc lấy phiên hội thoại dựa trên session_id
    """
    if session_id and session_id in chat_sessions:
        chat_sessions[session_id]["last_access"] = time.time()
        return chat_sessions[session_id]["agent"], session_id
    
    new_session_id = session_id or str(uuid.uuid4())
    try:
        agent = FashionAgent()
        chat_sessions[new_session_id] = {
            "agent": agent,
            "created_at": time.time(),
            "last_access": time.time()
        }
        logger.info(f"Created new session: {new_session_id}")
        return agent, new_session_id
    except Exception as e:
        logger.error(f"Error creating session: {e}")
        raise HTTPException(status_code=500, detail="Could not create chat session")

def cleanup_old_sessions(max_age_hours: int = 2):
    """
    Dọn dẹp các phiên cũ để tránh rò rỉ bộ nhớ
    """
    current_time = time.time()
    sessions_to_remove = []
    
    for session_id, session_data in chat_sessions.items():
        if current_time - session_data["last_access"] > max_age_hours * 3600:
            sessions_to_remove.append(session_id)
    
    for session_id in sessions_to_remove:
        del chat_sessions[session_id]
        logger.info(f"Removed inactive session: {session_id}")

@app.get("/", response_class=HTMLResponse)
async def get_chat_interface(request: Request):
    """
    Trả về giao diện chat
    """
    return templates.TemplateResponse("chat.html", {"request": request})

@app.post("/chat", response_model=ChatResponse)
async def chat(
    request: ChatRequest,
    background_tasks: BackgroundTasks
):
    """
    Endpoint chính để tương tác với Fashion Agent
    """
    try:
        background_tasks.add_task(cleanup_old_sessions)
        agent, session_id = get_or_create_session(request.session_id)
        logger.info(f"Received message from session {session_id}: {request.message[:50]}...")
        
        # Lấy phản hồi từ agent
        start_time = time.time()
        response = agent.get_response(request.message)
        processing_time = time.time() - start_time
        
        logger.info(f"Response generated in {processing_time:.2f}s for session {session_id}")
        
        return ChatResponse(
            response=response,
            session_id=session_id
        )
    
    except Exception as e:
        logger.error(f"Error processing chat request: {e}")
        raise HTTPException(status_code=500, detail=f"Error processing request: {str(e)}")

@app.delete("/sessions/{session_id}")
async def delete_session(session_id: str):
    """
    Xóa một phiên hội thoại
    """
    if session_id in chat_sessions:
        del chat_sessions[session_id]
        logger.info(f"Deleted session: {session_id}")
        return {"message": f"Session {session_id} deleted successfully"}
    else:
        raise HTTPException(status_code=404, detail="Session not found")

@app.get("/sessions")
async def get_sessions():
    """
    Lấy thông tin về các phiên hội thoại (chỉ dùng cho debugging)
    """
    return {
        "active_sessions": len(chat_sessions),
        "sessions": [
            {
                "id": session_id,
                "created_at": session_data["created_at"],
                "last_access": session_data["last_access"],
                "age_seconds": time.time() - session_data["created_at"]
            }
            for session_id, session_data in chat_sessions.items()
        ]
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)