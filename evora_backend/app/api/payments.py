import uuid
from datetime import datetime, timezone

from fastapi import APIRouter, Depends, HTTPException, Request
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.api.deps import get_current_user
from app.infrastructure.database import get_db
from app.infrastructure.models import Booking, Payment
from app.schemas.evora import PaymentIntentRequest, PaymentVerifyRequest

router = APIRouter(tags=["payments"])


@router.post("/payments/create-intent")
async def create_payment_intent(
    payload: PaymentIntentRequest,
    db: AsyncSession = Depends(get_db),
    current_user=Depends(get_current_user),
):
    booking_result = await db.execute(
        select(Booking).where(Booking.id == payload.booking_id, Booking.user_id == current_user.id)
    )
    booking = booking_result.scalars().first()
    if not booking:
        raise HTTPException(status_code=404, detail="Booking not found")

    intent_id = f"rpay_intent_{uuid.uuid4().hex[:16]}"
    payment = Payment(
        booking_id=payload.booking_id,
        payment_intent_id=intent_id,
        amount=payload.amount,
        status="created",
        provider="razorpay",
    )
    db.add(payment)
    await db.commit()
    await db.refresh(payment)
    return {"payment_intent_id": intent_id, "amount": payload.amount, "currency": "INR", "status": payment.status}


@router.post("/payments/verify")
async def verify_payment(
    payload: PaymentVerifyRequest,
    db: AsyncSession = Depends(get_db),
    current_user=Depends(get_current_user),
):
    booking_result = await db.execute(
        select(Booking).where(Booking.id == payload.booking_id, Booking.user_id == current_user.id)
    )
    booking = booking_result.scalars().first()
    if not booking:
        raise HTTPException(status_code=404, detail="Booking not found")

    payment_result = await db.execute(
        select(Payment).where(
            Payment.booking_id == payload.booking_id,
            Payment.payment_intent_id == payload.payment_intent_id,
        )
    )
    payment = payment_result.scalars().first()
    if not payment:
        raise HTTPException(status_code=404, detail="Payment intent not found")

    payment.status = "verified"
    payment.verified_at = datetime.now(timezone.utc)
    booking.status = "confirmed"
    db.add(payment)
    db.add(booking)
    await db.commit()
    return {"message": "Payment verified", "booking_id": booking.id, "payment_status": payment.status}


@router.get("/payments/{bookingId}")
async def get_booking_payments(
    bookingId: int,
    db: AsyncSession = Depends(get_db),
    current_user=Depends(get_current_user),
):
    booking_result = await db.execute(select(Booking).where(Booking.id == bookingId, Booking.user_id == current_user.id))
    booking = booking_result.scalars().first()
    if not booking:
        raise HTTPException(status_code=404, detail="Booking not found")

    result = await db.execute(select(Payment).where(Payment.booking_id == bookingId))
    payments = result.scalars().all()
    return [
        {
            "id": p.id,
            "payment_intent_id": p.payment_intent_id,
            "amount": p.amount,
            "status": p.status,
            "provider": p.provider,
            "created_at": p.created_at,
            "verified_at": p.verified_at,
        }
        for p in payments
    ]


@router.post("/webhooks/razorpay")
async def razorpay_webhook(request: Request):
    payload = await request.body()
    return {"message": "Webhook received", "payload_size": len(payload)}
