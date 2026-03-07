from typing import Optional
from pydantic import BaseModel


class BookingQuoteRequest(BaseModel):
    vendor_id: int
    event_type: str
    event_date: str
    guest_count: int


class BookingCreateRequest(BaseModel):
    vendor_id: int
    event_type: str
    event_date: str
    guest_count: int
    notes: Optional[str] = None


class PaymentIntentRequest(BaseModel):
    booking_id: int
    amount: float


class PaymentVerifyRequest(BaseModel):
    booking_id: int
    payment_intent_id: str
    razorpay_payment_id: Optional[str] = None
    razorpay_signature: Optional[str] = None


class SendMessageRequest(BaseModel):
    body: Optional[str] = None
    attachment_url: Optional[str] = None


class VendorApplyRequest(BaseModel):
    business_name: str
    city: str
    service_category: str
    phone: str
    about: Optional[str] = None
