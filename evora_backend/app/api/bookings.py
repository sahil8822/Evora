from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.api.deps import get_current_user
from app.infrastructure.database import get_db
from app.infrastructure.models import Booking, ChatThread, Vendor
from app.schemas.evora import BookingCreateRequest, BookingQuoteRequest

router = APIRouter(prefix="/bookings", tags=["bookings"])


@router.post("/quote")
async def create_booking_quote(payload: BookingQuoteRequest, db: AsyncSession = Depends(get_db)):
    vendor_result = await db.execute(select(Vendor).where(Vendor.id == payload.vendor_id))
    vendor = vendor_result.scalars().first()
    if not vendor:
        raise HTTPException(status_code=404, detail="Vendor not found")

    estimated = float(vendor.starting_price) + (payload.guest_count * 50)
    return {
        "vendor_id": payload.vendor_id,
        "event_type": payload.event_type,
        "event_date": payload.event_date,
        "guest_count": payload.guest_count,
        "estimated_price": round(estimated, 2),
        "currency": "INR",
    }


@router.post("")
async def create_booking(
    payload: BookingCreateRequest,
    db: AsyncSession = Depends(get_db),
    current_user=Depends(get_current_user),
):
    vendor_result = await db.execute(select(Vendor).where(Vendor.id == payload.vendor_id))
    vendor = vendor_result.scalars().first()
    if not vendor:
        raise HTTPException(status_code=404, detail="Vendor not found")

    quoted_price = float(vendor.starting_price) + (payload.guest_count * 50)
    booking = Booking(
        user_id=current_user.id,
        vendor_id=payload.vendor_id,
        event_type=payload.event_type,
        event_date=payload.event_date,
        guest_count=payload.guest_count,
        notes=payload.notes,
        status="pending",
        quoted_price=quoted_price,
    )
    db.add(booking)
    existing_thread = await db.execute(
        select(ChatThread).where(
            ChatThread.user_id == current_user.id,
            ChatThread.vendor_id == payload.vendor_id,
        )
    )
    if not existing_thread.scalars().first():
        db.add(ChatThread(user_id=current_user.id, vendor_id=payload.vendor_id))
    await db.commit()
    await db.refresh(booking)
    return {
        "id": booking.id,
        "status": booking.status,
        "quoted_price": booking.quoted_price,
        "currency": "INR",
    }


@router.get("")
async def list_bookings(
    db: AsyncSession = Depends(get_db),
    current_user=Depends(get_current_user),
):
    result = await db.execute(select(Booking).where(Booking.user_id == current_user.id))
    bookings = result.scalars().all()
    return [
        {
            "id": b.id,
            "vendor_id": b.vendor_id,
            "event_type": b.event_type,
            "event_date": b.event_date,
            "guest_count": b.guest_count,
            "status": b.status,
            "quoted_price": b.quoted_price,
            "created_at": b.created_at,
        }
        for b in bookings
    ]


@router.get("/{id}")
async def get_booking(
    id: int,
    db: AsyncSession = Depends(get_db),
    current_user=Depends(get_current_user),
):
    result = await db.execute(select(Booking).where(Booking.id == id, Booking.user_id == current_user.id))
    booking = result.scalars().first()
    if not booking:
        raise HTTPException(status_code=404, detail="Booking not found")
    return {
        "id": booking.id,
        "vendor_id": booking.vendor_id,
        "event_type": booking.event_type,
        "event_date": booking.event_date,
        "guest_count": booking.guest_count,
        "notes": booking.notes,
        "status": booking.status,
        "quoted_price": booking.quoted_price,
        "created_at": booking.created_at,
    }


@router.patch("/{id}/cancel")
async def cancel_booking(
    id: int,
    db: AsyncSession = Depends(get_db),
    current_user=Depends(get_current_user),
):
    result = await db.execute(select(Booking).where(Booking.id == id, Booking.user_id == current_user.id))
    booking = result.scalars().first()
    if not booking:
        raise HTTPException(status_code=404, detail="Booking not found")
    if booking.status == "cancelled":
        return {"message": "Booking already cancelled"}

    booking.status = "cancelled"
    db.add(booking)
    await db.commit()
    await db.refresh(booking)
    return {"message": "Booking cancelled", "id": booking.id, "status": booking.status}
