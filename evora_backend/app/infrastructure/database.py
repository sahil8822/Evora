from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession, async_sessionmaker
from sqlalchemy.orm import DeclarativeBase
from app.core.config import settings

# Neon requires postgresql+psycopg specifically for async work in many cases
# or just postgresql:// if the driver is configured.
# We'll normalize the URL for SQLAlchemy async engine.
DATABASE_URL = settings.DATABASE_URL

if DATABASE_URL:
    # Normalize postgres:// to postgresql:// (common in some platforms)
    if DATABASE_URL.startswith("postgres://"):
        DATABASE_URL = DATABASE_URL.replace("postgres://", "postgresql://", 1)
    
    # Ensure it uses the async driver (psycopg)
    if DATABASE_URL.startswith("postgresql://") and "+psycopg" not in DATABASE_URL:
        DATABASE_URL = DATABASE_URL.replace("postgresql://", "postgresql+psycopg://", 1)

if not DATABASE_URL:
    raise ValueError(
        "DATABASE_URL is not set. Please set it in your environment variables. "
        "On Render, go to Environment > Add Environment Variable."
    )

engine = create_async_engine(DATABASE_URL, echo=True)

AsyncSessionLocal = async_sessionmaker(
    bind=engine,
    class_=AsyncSession,
    expire_on_commit=False,
)

class Base(DeclarativeBase):
    pass

async def get_db():
    async with AsyncSessionLocal() as session:
        yield session
