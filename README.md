# Online Ordering App

A clean architecture-based Flutter e-commerce application integrated with OpenCart 4 custom API backend. Built using BLoC pattern for state management and following SOLID principles for maintainable, scalable code.

## Architecture Overview

This project follows Clean Architecture principles with three main layers:

1. **Presentation Layer**
   - UI components and BLoC state management
   - Platform-independent business logic
   - Dependency injection setup

2. **Domain Layer**
   - Business rules and entities
   - Use case implementations
   - Repository interfaces

3. **Data Layer**
   - API integration
   - Local storage
   - Repository implementations

## Tech Stack

- Flutter SDK (^3.5.4)
- Dart SDK (^3.5.4)
- OpenCart 4.x custom API

### Key Dependencies

- **State Management**
  - flutter_bloc: ^8.1.6
  - get_it: ^8.0.3 (Dependency Injection)

- **Networking & Data**
  - http: ^1.2.2
  - sqflite: ^2.4.1
  - shared_preferences: ^2.3.3

- **UI Components**
  - flutter_spinkit: ^5.2.1
  - carousel_slider: ^5.0.0
  - flutter_widget_from_html_core: ^0.15.2

- **Navigation**
  - go_router: ^14.6.2

- **Utilities**
  - fpdart: ^1.1.1
  - path: ^1.9.0
  - html_unescape: ^2.0.0

## API Integration

Base URL: `https://<server_url>/mobileapi/`

### Available Endpoints

1. **Authentication**
   - `auth|login` - User login
   - `auth|register` - New user registration
   - `auth|logout` - User logout
   - `auth|validateToken` - Token validation
   - `auth|forgotPassword` - Password reset request
   - `auth|resetPassword` - Set new password
   - `auth|deleteAccount` - Account deletion

2. **Product Management**
   - `menu|categories` - Get all categories
   - `menu|category` - Get category details
   - `menu|products` - Get product list
   - `menu|product` - Get product details
   - `menu|lastModified` - Recently updated items
   - `menu|featured` - Featured products

3. **Shopping Cart**
   - `cart|add` - Add to cart
   - `cart|summary` - Cart details
   - `cart|update` - Update quantities 
   - `cart|remove` - Remove items

4. **Checkout Process**
   - `checkout|summary` - Order summary
   - `checkout|setShippingAddress` - Set delivery address
   - `checkout|getShippingMethods` - Available shipping options
   - `checkout|setShippingMethod` - Choose shipping
   - `checkout|fetchPaymentMethods` - Payment options
   - `checkout|setPaymentMethod` - Set payment
   - `checkout|confirmOrder` - Place order
   - `checkout|reviewOrder` - Final review

5. **Address Management**
   - `address|list` - Saved addresses
   - `address|countries` - Available countries
   - `address|country` - Country details
   - `address|save` - Save address
   - `address|delete` - Remove address

## Project Structure

```
lib/
├── core/
│   ├── error/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/
│   │   └── network_info.dart
│   └── utils/
│       └── constants.dart
├── features/
│   ├── auth/
│   ├── products/
│   ├── cart/
│   ├── checkout/
│   └── address/
│       ├── data/
│       │   ├── data_sources/
│       │   │   ├── remote_data_source.dart
│       │   │   └── local_data_source.dart
│       │   ├── models/
│       │   │   └── model.dart
│       │   └── repositories/
│       │       └── repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   │   └── repository.dart
│       │   └── use_cases/
│       └── presentation/
│           ├── blocs/
│           ├── pages/
│           └── widgets/
└── main.dart
```

## Feature Generation

Generate new features using the provided script:

```bash
./generate_feature.sh feature_name
```

## Getting Started

Clone the backend repository:
```bash
git https://github.com/Rahul-C-S/e-commerce

```


```

## API Authentication

- All secured endpoints require a bearer token
- Token is obtained through the login endpoint
- Include token in request headers:
```dart
headers: {
  'Authorization': 'Bearer $token',
  'Content-Type': 'application/json',
}
```


## Building for Production

1. Android:
```bash
flutter build apk --release
```

2. iOS:
```bash
flutter build ios --release
```

## State Management

The app uses BLoC pattern with the following principles:
- Each feature has its own BLoC
- Events trigger state changes
- States are immutable
- Unidirectional data flow

Example BLoC structure:
```dart
// Events
abstract class CartEvent {}
class AddToCartEvent extends CartEvent {}

// States
abstract class CartState {}
class CartLoading extends CartState {}
class CartLoaded extends CartState {}

// BLoC
class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<AddToCartEvent>((event, emit) async {
      // Handle event
    });
  }
}
```
