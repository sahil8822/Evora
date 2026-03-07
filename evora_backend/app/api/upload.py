from fastapi import APIRouter, UploadFile, File, HTTPException
from app.infrastructure.cloudinary_service import CloudinaryService
import shutil
import os

router = APIRouter(prefix="/upload", tags=["upload"])

@router.post("/image")
async def upload_image(file: UploadFile = File(...)):
    if not file.content_type.startswith("image/"):
        raise HTTPException(status_code=400, detail="File must be an image")
    
    # Save temp file
    temp_path = f"temp_{file.filename}"
    with open(temp_path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)
    
    try:
        url = CloudinaryService.upload_image(temp_path)
        if not url:
            raise HTTPException(status_code=500, detail="Failed to upload to Cloudinary")
        return {"url": url}
    finally:
        if os.path.exists(temp_path):
            os.remove(temp_path)
