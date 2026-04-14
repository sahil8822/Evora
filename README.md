# Evora Flutter Apps (User + Partner)

This repo contains **two separate Flutter applications**:

- **`evora_user_app/`**: customer-facing app
- **`evora_partner_app/`**: vendor/partner-facing app

## Run

From the repo root:

```bash
cd evora_user_app
flutter pub get
flutter run
```

```bash
cd evora_partner_app
flutter pub get
flutter run
```

## Folder map (both apps)

Inside each app, the most important folders are:

- **`lib/core/`**: app-wide setup (router, theme, services)
- **`lib/screens/`**: UI screens grouped by feature (auth, home, booking, messages, services, profile, etc.)
- **`lib/components/`**: shared reusable UI widgets (buttons, text fields, etc.)
- **`lib/providers/`**: `provider` state objects
- **`assets/`**: images + icons (declared in `pubspec.yaml`)

## Recent structure fixes

- Renamed the typo folder **`bottom_nave` → `bottom_nav`** in both apps.

