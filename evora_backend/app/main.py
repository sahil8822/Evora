from fastapi import FastAPI
from app.api.auth import router as auth_router
from app.api.upload import router as upload_router
from app.api.users import router as users_router
from app.api.me import router as me_router
from app.api.discovery import router as discovery_router
from app.api.bookings import router as bookings_router
from app.api.payments import router as payments_router
from app.api.chats import router as chats_router
from app.api.vendor import router as vendor_router
from app.core.config import settings
from app.infrastructure.database import AsyncSessionLocal, Base, engine
from app.infrastructure.seed import seed_reference_data
import asyncio
import sys

if sys.platform == "win32":
    asyncio.set_event_loop_policy(asyncio.WindowsSelectorEventLoopPolicy())

app = FastAPI(title=settings.PROJECT_NAME)

@app.on_event("startup")
async def startup():
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    async with AsyncSessionLocal() as db:
        await seed_reference_data(db)

# Include routers
app.include_router(auth_router)
app.include_router(upload_router)
app.include_router(users_router)
app.include_router(me_router)
app.include_router(discovery_router)
app.include_router(bookings_router)
app.include_router(payments_router)
app.include_router(chats_router)
app.include_router(vendor_router)

@app.get("/")
async def root():
    return {"message": f"Welcome to {settings.PROJECT_NAME} API. Visit /docs for documentation."}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=8000)
