# Shopie – Flutter Login, Product Listing & Cart App

A Flutter app with **Login → Product Listing → Cart** flow, built with
**BLoC** state management and **Clean Architecture**. No backend / Firebase –
all data is local/static.

## Features
- **Login**: email + password fields, live validation, show/hide password,
  Login button enabled only when inputs are valid, local (dummy) authentication.
- **Product listing**: 8 products in reusable cards (image, name, description,
  price, *Add to Cart*), cart icon with live item-count badge.
- **Cart**: image, name, price, quantity stepper (+/−), remove button (with Undo),
  per-item subtotal, total amount, empty-cart message, checkout (demo).
- Cart state lives in a root-level `CartBloc`, so it persists across screens.

## Demo credentials
| Email              | Password   |
|--------------------|------------|
| `test@example.com` | `Test@123` |

## Tech stack
- Flutter (stable) & Dart 3
- `flutter_bloc` – state management
- `equatable` – value equality for states/events/entities

## Project structure (Clean Architecture, feature-first)
```
lib/
├── main.dart / app.dart
├── injection_container.dart        # simple dependency wiring
├── core/                           # shared code
│   ├── constants/  router/  theme/  utils/
│   └── widgets/                    # PrimaryButton, EmptyState, NetworkImageBox
└── features/
    ├── auth/
    │   ├── domain/        (repository contract, LoginUser use case)
    │   ├── data/          (local data source, repository impl)
    │   └── presentation/  (LoginBloc, LoginPage)
    ├── products/
    │   ├── domain/        (Product entity, GetProducts use case)
    │   ├── data/          (ProductModel, static data source, repository impl)
    │   └── presentation/  (ProductBloc, ProductListPage, ProductCard, CartBadgeButton)
    └── cart/
        ├── domain/        (CartItem entity)
        └── presentation/  (CartBloc, CartPage, CartItemTile, QuantityStepper, CartSummary)
```
Dependency rule: `presentation → domain ← data`. The domain layer has no
Flutter or data-layer imports.

## Setup & run
Prerequisite: Flutter SDK installed (`flutter --version`, `flutter doctor`).

```bash
# 1. Get the project
git clone <your-repo-url>
cd flutter_shop_app

# 2. Generate platform folders (android/ios/web...) – only needed once,
#    because this repo ships the Dart source + pubspec.
flutter create . --project-name flutter_shop_app --platforms=android,ios

# 3. Install dependencies
flutter pub get

# 4. Run (emulator / device connected)
flutter run

# Optional: run tests / analyze
flutter test
flutter analyze
```

> Product images load from `picsum.photos`, so an internet connection is needed
> to see pictures. If offline, a placeholder icon is shown instead.
> To use bundled images: add files under `assets/images/`, register them in
> `pubspec.yaml` (`flutter: assets:`) and switch `Image.network` to `Image.asset`.

## State management notes
| Bloc | Scope | Responsibility |
|------|-------|----------------|
| `LoginBloc` | Login route | field values, validation errors, password visibility, submit status |
| `ProductBloc` | Products route | load products (loading / success / failure) |
| `CartBloc` | App root | add, increase, decrease, remove, clear; derived `totalItems` & `totalAmount` |
