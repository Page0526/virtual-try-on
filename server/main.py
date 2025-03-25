from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware
from core.database import connect_to_mongo, close_mongo_connection
from api.user import router as user_router


app = FastAPI(
    title = "Easyfit Backend API", 
    description = "API for Easyfit Backend",
    version = "0.0.1",
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, replace with your frontend URL
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.add_event_handler("startup", connect_to_mongo)
app.add_event_handler("shutdown", close_mongo_connection)


app.include_router(user_router)

# Mount static files for React app
app.mount("/api-test", StaticFiles(directory="static/react", html=True), name="react_app")




