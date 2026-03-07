import os
from dotenv import load_dotenv

load_dotenv()

class Settings:
    PROJECT_NAME: str = "Evora Backend"
    
    CLOUDINARY_CLOUD_NAME = os.getenv("CLOUDINARY_CLOUD_NAME")
    CLOUDINARY_API_KEY = os.getenv("CLOUDINARY_API_KEY")
    CLOUDINARY_API_SECRET = os.getenv("CLOUDINARY_API_SECRET")
    
    SECRET_KEY = os.getenv("SECRET_KEY", "yoursecretkeyhere")
    ALGORITHM = os.getenv("ALGORITHM", "HS256")
    ACCESS_TOKEN_EXPIRE_MINUTES = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", 30))
    
    DATABASE_URL = os.getenv("DATABASE_URL")
    if not DATABASE_URL:
        # In a real production app, you might want to raise an error here
        # raise ValueError("DATABASE_URL environment variable is not set")
        print("WARNING: DATABASE_URL environment variable is not set. Database connection will fail.")

settings = Settings()
