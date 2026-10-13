# Flutter E-Commerce — Tech Store Demo

A responsive, polished **Flutter e-commerce portfolio demo** designed for mobile and web. Built with Dart, Material 3 and Provider, with a light/dark theme, search, a wishlist and a complete **simulated** checkout flow.

> **Portfolio demo:** No real account registration, backend, live inventory, card payment, or shipping. Please do not enter sensitive personal or payment information.

## Features

| Area | What works |
| --- | --- |
| Discover | Responsive product grid, category chips, live product search |
| Products | Consistent device illustrations, product details and quantity selection |
| Wishlist | Save/remove favorites, dedicated favorites screen |
| Bag | Add items, update quantities, remove items, clear cart, live totals |
| Checkout | Name/address validation, simulated payment methods, WELCOME10 promo |
| Orders | Confirmation, itemized responsive receipts, copy to clipboard and order history |
| Profile | Demo name/email, edit display name, theme switch, wishlist/orders links |
| Navigation | Side drawer, direct bag access, route handling |

**Persistence:** Shopping bag, favorites and demo orders survive browser refresh using local `shared_preferences`. The app always starts in dark mode; visitors can switch to light during a session. The demo user session resets. No credit-card data is stored.

**Sample offer:** Use `WELCOME10` in checkout for a 10% demo discount. No money changes hands.

## Screenshots / Demo

The existing [demo GIF](demo.gif) was recorded before the current redesign and may show an earlier interface.

The interface deliberately avoids product photos in favor of consistent, device-specific vector icons drawn locally; no image downloads are required.

## Tech stack

- Flutter / Dart — cross-platform UI
- Material Design 3 — styling and accessible controls
- Provider — reactive store, user and theme state
- shared_preferences — local demo store persistence
- intl — order dates and receipts
- flutter_test — cart, favorites and order-state tests

## Getting started

Install Flutter and check your development environment:

```bash
flutter doctor -v
```

Clone the repository:

```bash
git clone https://github.com/KostasNikP/flutter-ecommerce-app.git
cd flutter-ecommerce-app
flutter pub get
```

Run in Chrome:

```bash
flutter run -d chrome
```

Or use an Android emulator:

```bash
flutter run
```

## Product presentation

The photo carousel was removed in favor of an image-free catalog with cohesive illustrated device motifs. The same visual language is used on cards, product details and the bag. Adding to the bag shows a small floating confirmation instead of a large snackbar.

## Mobile experience

- Two-column grids on most phone widths, compact app bar and bottom navigation
- Flexible quantity controls and scrollable, itemized order receipts
- Photo-free product motifs available without network access

## Quality checks

```bash
flutter analyze
flutter test
flutter build web --release
```

GitHub Actions runs analysis, tests and a web release build for the redesign branch.

## Project layout

```text
lib/
  main.dart
  auth/
    models/        # Products, cart, wishlist, order snapshots, demo user
    pages/         # Store, product, favorites, cart, checkout, orders, profile
    components/    # Product artwork, cards, drawer and reusable widgets
    themes/        # Shared storefront palette and light/dark themes
test/
  widget_test.dart # State-model tests
```

## Roadmap

- [x] Persist cart, wishlist, and orders across restarts
- [ ] Firebase Authentication or another real identity provider
- [ ] Backend/database for products and orders
- [ ] Real payment integration using a provider-hosted checkout
- [ ] Accessibility and screen-reader testing
- [ ] Additional widget and integration tests

---

Created by [Konstantinos Nikolakopoulos](https://github.com/KostasNikP) as a Flutter development portfolio project.
