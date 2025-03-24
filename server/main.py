from fastapi import FastAPI
from core.database import connect_to_mongo, close_mongo_connection
from api.user import router as user_router


app = FastAPI(
    title = "Easyfit Backend API", 
    description = "API for Easyfit Backend",
    version = "0.0.1",
)


app.add_event_handler("startup", connect_to_mongo)
app.add_event_handler("shutdown", close_mongo_connection)


app.include_router(user_router )

