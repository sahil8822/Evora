from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import delete, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.api.deps import get_current_user
from app.infrastructure.database import get_db
from app.infrastructure.models import SavedVendor, Vendor
from app.schemas.user import UserProfileUpdate, UserResponse

router = APIRouter(tags=["me"])


@router.get("/me", response_model=UserResponse)
async def get_me(current_user=Depends(get_current_user)):
    return current_user


@router.patch("/me", response_model=UserResponse)
async def patch_me(
    payload: UserProfileUpdate,
    db: AsyncSession = Depends(get_db),
    current_user=Depends(get_current_user),
):
    update_data = payload.model_dump(exclude_unset=True)
    if not update_data:
        raise HTTPException(status_code=400, detail="No profile fields provided")

    for key, value in update_data.items():
        setattr(current_user, key, value)

    db.add(current_user)
    await db.commit()
    await db.refresh(current_user)
    return current_user


@router.get("/me/saved-vendors")
async def get_saved_vendors(
    db: AsyncSession = Depends(get_db),
    current_user=Depends(get_current_user),
):
    stmt = (
        select(Vendor)
        .join(SavedVendor, SavedVendor.vendor_id == Vendor.id)
        .where(SavedVendor.user_id == current_user.id)
    )
    result = await db.execute(stmt)
    vendors = result.scalars().all()
    return [
        {
            "id": v.id,
            "name": v.name,
            "city": v.city,
            "service_category": v.service_category,
            "rating": v.rating,
            "starting_price": v.starting_price,
            "image_url": v.image_url,
        }
        for v in vendors
    ]


@router.post("/me/saved-vendors/{vendorId}")
async def save_vendor(
    vendorId: int,
    db: AsyncSession = Depends(get_db),
    current_user=Depends(get_current_user),
):
    vendor_result = await db.execute(select(Vendor).where(Vendor.id == vendorId))
    vendor = vendor_result.scalars().first()
    if not vendor:
        raise HTTPException(status_code=404, detail="Vendor not found")

    existing = await db.execute(
        select(SavedVendor).where(
            SavedVendor.user_id == current_user.id,
            SavedVendor.vendor_id == vendorId,
        )
    )
    if existing.scalars().first():
        return {"message": "Vendor already saved"}

    db.add(SavedVendor(user_id=current_user.id, vendor_id=vendorId))
    await db.commit()
    return {"message": "Vendor saved"}


@router.delete("/me/saved-vendors/{vendorId}")
async def unsave_vendor(
    vendorId: int,
    db: AsyncSession = Depends(get_db),
    current_user=Depends(get_current_user),
):
    await db.execute(
        delete(SavedVendor).where(
            SavedVendor.user_id == current_user.id,
            SavedVendor.vendor_id == vendorId,
        )
    )
    await db.commit()
    return {"message": "Vendor removed from saved list"}
