import os
import shutil

from fastapi import APIRouter, Depends, File, HTTPException, UploadFile
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.api.deps import get_current_user
from app.infrastructure.cloudinary_service import CloudinaryService
from app.infrastructure.database import get_db
from app.infrastructure.models import ChatMessage, ChatThread
from app.schemas.evora import SendMessageRequest

router = APIRouter(prefix="/chats", tags=["chats"])


@router.get("/threads")
async def list_threads(db: AsyncSession = Depends(get_db), current_user=Depends(get_current_user)):
    result = await db.execute(select(ChatThread).where(ChatThread.user_id == current_user.id))
    threads = result.scalars().all()
    return [
        {
            "id": t.id,
            "vendor_id": t.vendor_id,
            "created_at": t.created_at,
            "last_message_at": t.last_message_at,
        }
        for t in threads
    ]


@router.get("/threads/{id}/messages")
async def list_thread_messages(
    id: int,
    db: AsyncSession = Depends(get_db),
    current_user=Depends(get_current_user),
):
    thread_result = await db.execute(select(ChatThread).where(ChatThread.id == id, ChatThread.user_id == current_user.id))
    thread = thread_result.scalars().first()
    if not thread:
        raise HTTPException(status_code=404, detail="Thread not found")

    result = await db.execute(select(ChatMessage).where(ChatMessage.thread_id == id))
    messages = result.scalars().all()
    return [
        {
            "id": m.id,
            "thread_id": m.thread_id,
            "sender_type": m.sender_type,
            "body": m.body,
            "attachment_url": m.attachment_url,
            "created_at": m.created_at,
        }
        for m in messages
    ]


@router.post("/threads/{id}/messages")
async def send_message(
    id: int,
    payload: SendMessageRequest,
    db: AsyncSession = Depends(get_db),
    current_user=Depends(get_current_user),
):
    thread_result = await db.execute(select(ChatThread).where(ChatThread.id == id, ChatThread.user_id == current_user.id))
    thread = thread_result.scalars().first()
    if not thread:
        raise HTTPException(status_code=404, detail="Thread not found")

    if not payload.body and not payload.attachment_url:
        raise HTTPException(status_code=400, detail="Message body or attachment_url is required")

    message = ChatMessage(
        thread_id=id,
        sender_type="customer",
        body=payload.body,
        attachment_url=payload.attachment_url,
    )
    db.add(message)
    db.add(thread)
    await db.commit()
    await db.refresh(message)
    return {
        "id": message.id,
        "thread_id": message.thread_id,
        "sender_type": message.sender_type,
        "body": message.body,
        "attachment_url": message.attachment_url,
        "created_at": message.created_at,
    }


@router.post("/upload")
async def upload_chat_file(file: UploadFile = File(...)):
    temp_path = f"temp_chat_{file.filename}"
    with open(temp_path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    try:
        url = CloudinaryService.upload_image(temp_path)
        if not url:
            # Fallback for local dev when Cloudinary is not configured
            return {"url": f"https://files.evora.local/{file.filename}"}
        return {"url": url}
    finally:
        if os.path.exists(temp_path):
            os.remove(temp_path)
