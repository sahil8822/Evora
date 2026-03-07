import random
from datetime import datetime, timedelta, timezone

from fastapi import APIRouter, Depends, HTTPException, status
from jose import JWTError, jwt
from sqlalchemy import or_, select
from sqlalchemy.ext.asyncio import AsyncSession
from app.schemas.auth import (
    LogoutRequest,
    OTPRequest,
    OTPVerify,
    RefreshTokenRequest,
    SocialLoginRequest,
    Token,
    TokenPair,
    UserCreate,
    UserLogin,
)
from app.core.config import settings
from app.infrastructure.models import User
from app.services.auth_service import AuthService
from app.infrastructure.database import get_db

router = APIRouter(prefix="/auth", tags=["auth"])
_otp_store: dict[str, dict[str, str]] = {}


def _create_refresh_token(email: str) -> str:
    expire = datetime.now(timezone.utc) + timedelta(days=30)
    payload = {"sub": email, "type": "refresh", "exp": expire}
    return jwt.encode(payload, settings.SECRET_KEY, algorithm=settings.ALGORITHM)


def _create_token_pair(email: str) -> TokenPair:
    access_token = AuthService.create_access_token(data={"sub": email, "type": "access"})
    refresh_token = _create_refresh_token(email)
    return TokenPair(access_token=access_token, refresh_token=refresh_token)


async def _get_or_create_user_from_phone(db: AsyncSession, phone: str, **profile_fields):
    email = f"{phone}@phone.evora.local"
    query = select(User).where(or_(User.phone == phone, User.email == email))
    result = await db.execute(query)
    user = result.scalars().first()

    if user:
        if user.phone is None:
            user.phone = phone
        for field, value in profile_fields.items():
            if value is not None:
                setattr(user, field, value)
        db.add(user)
        await db.commit()
        await db.refresh(user)
        return user

    hashed_password = AuthService.get_password_hash(f"{phone}-otp-login")
    user_data = {
        "email": email,
        "phone": phone,
        "first_name": profile_fields.get("first_name"),
        "last_name": profile_fields.get("last_name"),
        "image_url": profile_fields.get("image_url"),
        "hashed_password": hashed_password,
    }
    return await AuthService.create_user(db, user_data)

@router.post("/signup", response_model=Token)
async def signup(user: UserCreate, db: AsyncSession = Depends(get_db)):
    db_user = await AuthService.get_user_by_email(db, user.email)
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    
    if user.password != user.confirm_password:
        raise HTTPException(status_code=400, detail="Passwords do not match")
    
    hashed_password = AuthService.get_password_hash(user.password)
    new_user_data = {
        "email": user.email,
        "first_name": user.first_name,
        "last_name": user.last_name,
        "hashed_password": hashed_password,
        "image_url": user.image_url
    }
    
    await AuthService.create_user(db, new_user_data)
    
    access_token = AuthService.create_access_token(data={"sub": user.email})
    return {"access_token": access_token, "token_type": "bearer"}

@router.post("/login", response_model=Token)
async def login(user_data: UserLogin, db: AsyncSession = Depends(get_db)):
    user = await AuthService.get_user_by_email(db, user_data.email)
    if not user or not AuthService.verify_password(user_data.password, user.hashed_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    access_token = AuthService.create_access_token(data={"sub": user_data.email})
    return {"access_token": access_token, "token_type": "bearer"}


@router.post("/otp/request")
async def request_otp(payload: OTPRequest):
    otp = f"{random.randint(100000, 999999)}"
    _otp_store[payload.phone] = {"otp": otp}
    return {"message": "OTP sent successfully", "dev_otp": otp}


@router.post("/otp/verify", response_model=TokenPair)
async def verify_otp(payload: OTPVerify, db: AsyncSession = Depends(get_db)):
    entry = _otp_store.get(payload.phone)
    if not entry or entry.get("otp") != payload.otp:
        raise HTTPException(status_code=400, detail="Invalid OTP")

    user = await _get_or_create_user_from_phone(
        db,
        payload.phone,
        first_name=payload.first_name,
        last_name=payload.last_name,
        image_url=payload.image_url,
    )
    _otp_store.pop(payload.phone, None)
    return _create_token_pair(user.email)


@router.post("/google", response_model=TokenPair)
async def google_login(payload: SocialLoginRequest, db: AsyncSession = Depends(get_db)):
    user = await AuthService.get_user_by_email(db, payload.email)
    if not user:
        user_data = {
            "email": payload.email,
            "first_name": payload.first_name,
            "last_name": payload.last_name,
            "image_url": payload.image_url,
            "hashed_password": AuthService.get_password_hash("social-login"),
        }
        user = await AuthService.create_user(db, user_data)
    return _create_token_pair(user.email)


@router.post("/apple", response_model=TokenPair)
async def apple_login(payload: SocialLoginRequest, db: AsyncSession = Depends(get_db)):
    user = await AuthService.get_user_by_email(db, payload.email)
    if not user:
        user_data = {
            "email": payload.email,
            "first_name": payload.first_name,
            "last_name": payload.last_name,
            "image_url": payload.image_url,
            "hashed_password": AuthService.get_password_hash("social-login"),
        }
        user = await AuthService.create_user(db, user_data)
    return _create_token_pair(user.email)


@router.post("/refresh", response_model=TokenPair)
async def refresh_token(payload: RefreshTokenRequest):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Invalid refresh token",
    )
    try:
        token_payload = jwt.decode(
            payload.refresh_token,
            settings.SECRET_KEY,
            algorithms=[settings.ALGORITHM],
        )
        email = token_payload.get("sub")
        token_type = token_payload.get("type")
        if not email or token_type != "refresh":
            raise credentials_exception
    except JWTError:
        raise credentials_exception

    return _create_token_pair(email)


@router.post("/logout")
async def logout(_: LogoutRequest):
    return {"message": "Logged out successfully"}
