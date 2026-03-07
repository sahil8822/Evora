from fastapi import APIRouter, HTTPException, Query
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from fastapi import Depends

from app.infrastructure.database import get_db
from app.infrastructure.models import Vendor, VendorAvailability, VendorReview

router = APIRouter(tags=["discovery"])


@router.get("/locations/suggest")
async def suggest_locations(q: str = Query(default="", min_length=0)):
    all_locations = ["Mumbai", "Delhi", "Bengaluru", "Pune", "Hyderabad", "Chennai", "Ahmedabad"]
    query = q.strip().lower()
    if not query:
        return all_locations[:5]
    return [city for city in all_locations if query in city.lower()][:8]


@router.get("/event-types")
async def get_event_types():
    return ["Wedding", "Engagement", "Birthday", "Corporate", "Baby Shower", "Anniversary"]


@router.get("/service-categories")
async def get_service_categories():
    return ["Photography", "Decoration", "Catering", "Makeup", "Venue", "Entertainment"]


@router.get("/vendors/featured")
async def get_featured_vendors(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Vendor).where(Vendor.is_featured == 1))
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


@router.get("/vendors")
async def list_vendors(
    location: str | None = None,
    category: str | None = None,
    search: str | None = None,
    page: int = 1,
    limit: int = 20,
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(select(Vendor))
    vendors = result.scalars().all()

    if location:
        vendors = [v for v in vendors if v.city.lower() == location.lower()]
    if category:
        vendors = [v for v in vendors if v.service_category.lower() == category.lower()]
    if search:
        key = search.lower()
        vendors = [v for v in vendors if key in v.name.lower() or key in v.city.lower()]

    start = max(0, (page - 1) * limit)
    end = start + limit
    paged = vendors[start:end]
    return {
        "page": page,
        "limit": limit,
        "total": len(vendors),
        "items": [
            {
                "id": v.id,
                "name": v.name,
                "city": v.city,
                "service_category": v.service_category,
                "rating": v.rating,
                "starting_price": v.starting_price,
                "image_url": v.image_url,
            }
            for v in paged
        ],
    }


@router.get("/vendors/{id}")
async def get_vendor(id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Vendor).where(Vendor.id == id))
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


@router.get("/vendors/{id}/reviews")
async def get_vendor_reviews(id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(VendorReview).where(VendorReview.vendor_id == id))
    reviews = result.scalars().all()
    return [
        {
            "id": r.id,
            "reviewer_name": r.reviewer_name,
            "rating": r.rating,
            "comment": r.comment,
            "created_at": r.created_at,
        }
        for r in reviews
    ]


@router.get("/vendors/{id}/availability")
async def get_vendor_availability(
    id: int,
    date: str | None = None,
    db: AsyncSession = Depends(get_db),
):
    query = select(VendorAvailability).where(VendorAvailability.vendor_id == id)
    if date:
        query = query.where(VendorAvailability.available_date == date)
    result = await db.execute(query)
    rows = result.scalars().all()
    return [
        {
            "date": row.available_date,
            "slots": [slot.strip() for slot in row.slots.split(",") if slot.strip()],
        }
        for row in rows
    ]
