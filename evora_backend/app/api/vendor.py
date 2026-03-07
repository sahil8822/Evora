from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.api.deps import get_current_user
from app.infrastructure.database import get_db
from app.infrastructure.models import Vendor, VendorApplication
from app.schemas.evora import VendorApplyRequest

router = APIRouter(prefix="/vendor", tags=["vendor"])


@router.post("/apply")
async def apply_as_vendor(
    payload: VendorApplyRequest,
    db: AsyncSession = Depends(get_db),
    current_user=Depends(get_current_user),
):
    application = VendorApplication(
        user_id=current_user.id,
        business_name=payload.business_name,
        city=payload.city,
        service_category=payload.service_category,
        phone=payload.phone,
        about=payload.about,
        status="submitted",
    )
    db.add(application)
    await db.commit()
    await db.refresh(application)
    return {"id": application.id, "status": application.status}


@router.get("/public/{vendorId}")
async def get_public_vendor(vendorId: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Vendor).where(Vendor.id == vendorId))
    vendor = result.scalars().first()
    if not vendor:
        raise HTTPException(status_code=404, detail="Vendor not found")
    return {
        "id": vendor.id,
        "name": vendor.name,
        "city": vendor.city,
        "service_category": vendor.service_category,
        "rating": vendor.rating,
        "starting_price": vendor.starting_price,
        "image_url": vendor.image_url,
    }
