# Flutter E-Commerce

## Demo

![Flutter E-Commerce mobile demo](media/tech_store_portfolio_demo.gif)

[Watch the full mobile demo (MP4)](media/tech_store_portfolio_demo.mp4)

The walkthrough shows browsing the catalog, selecting products, managing the cart, completing a simulated checkout, and reviewing an order receipt.

A responsive tech storefront built with Flutter, Dart, Material 3, and Provider. The project demonstrates a complete shopping flow on desktop and mobile.

## Features

- Searchable catalog with filters, sorting, and responsive grids
- Product details with locally rendered vector artwork and quantity controls
- Wishlist and cart with live totals
- Sample checkout, order confirmation, detailed receipts, and order history
- Local persistence of the cart, favorites, and orders
- Dark theme on launch, with a light-mode option in Profile
- Guest access, a demo account, and email-format entry

## Getting started

Install Flutter and check the development environment:

    flutter doctor

From the project directory:

    flutter pub get
    flutter run -d chrome

Use flutter run to select a connected Android device or emulator.

## Quality checks

    flutter analyze
    flutter test
    flutter build web --release

Tests cover cart state, coupon totals, local storage, entry methods, and responsive layouts, including order history at narrow viewport widths. GitHub Actions verifies the pull request build. Run the commands above before committing updates.

## Project structure

- lib/auth/pages: screens and route handling
- lib/auth/components: shared UI widgets
- lib/auth/models: products, carts, orders, and user sessions
- lib/auth/themes: color palette and light/dark theme
- test: model and widget tests

## Scope

This is a portfolio demo, not a production shop. Products and prices are sample data. Entry methods do not authenticate with a server. Checkout does not process payments or send deliveries. Cart, favorites, and example orders are stored only on the current device. Do not enter real customer or payment details.

A production release would need an authentication service, a backend/database, payment integration, accessibility review, and end-to-end testing.

---

Developed by [Konstantinos Nikolakopoulos](https://github.com/KostasNikP).
