from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.infrastructure.models import Vendor, VendorAvailability, VendorReview


async def seed_reference_data(db: AsyncSession):
    existing = await db.execute(select(Vendor.id).limit(1))
    if existing.first():
        return

    vendors = [
        Vendor(
            name="Royal Events Studio",
            city="Mumbai",
            service_category="Photography",
            rating=4.8,
            starting_price=35000,
            is_featured=1,
            image_url="https://images.example.com/vendors/royal-events.jpg",
        ),
        Vendor(
            name="Bloom & Bliss Decor",
            city="Delhi",
            service_category="Decoration",
            rating=4.6,
            starting_price=50000,
            is_featured=1,
            image_url="https://images.example.com/vendors/bloom-bliss.jpg",
        ),
        Vendor(
            name="Symphony Caterers",
            city="Bengaluru",
            service_category="Catering",
            rating=4.7,
            starting_price=700,
            is_featured=0,
            image_url="https://images.example.com/vendors/symphony-caterers.jpg",
        ),
    ]
    db.add_all(vendors)
    await db.flush()

    reviews = [
        VendorReview(vendor_id=vendors[0].id, reviewer_name="Anita", rating=5.0, comment="Great photos and team."),
        VendorReview(vendor_id=vendors[0].id, reviewer_name="Rahul", rating=4.5, comment="Very professional service."),
        VendorReview(vendor_id=vendors[1].id, reviewer_name="Mia", rating=4.8, comment="Decor was exactly as expected."),
    ]
    db.add_all(reviews)

    availability = [
        VendorAvailability(vendor_id=vendors[0].id, available_date="2026-03-10", slots="10:00,12:00,16:00"),
        VendorAvailability(vendor_id=vendors[0].id, available_date="2026-03-11", slots="11:00,14:00"),
        VendorAvailability(vendor_id=vendors[1].id, available_date="2026-03-10", slots="09:00,15:00,18:00"),
    ]
    db.add_all(availability)

    await db.commit()
