import 'package:shop_app/auth/models/product.dart';
import 'package:shop_app/auth/models/shop_order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Shop extends ChangeNotifier {
  // Products for sale
  final List<Product> _shop = [
    // Trend
    Product(
      id: 1,
      name: "iPhone 11",
      price: 499.99,
      description: "6.1-inch Liquid Retina display, A13 Bionic chip, dual 12MP camera system.",
      imagePath: 'photo/Iphone11.png',
      category: 'trend',
    ),
    Product(
      id: 2,
      name: "iPhone 12",
      price: 599.99,
      description: "5G capable, Super Retina XDR display, Ceramic Shield front cover.",
      imagePath: 'photo/Iphone12.png',
      category: 'trend',
    ),
    Product(
      id: 3,
      name: "iPhone 13",
      price: 699.99,
      description: "Advanced dual-camera system, A15 Bionic chip, all-day battery life.",
      imagePath: 'photo/Ipone13.png',
      category: 'trend',
    ),
    Product(
      id: 4,
      name: "iPhone 14",
      price: 799.99,
      description: "Crash Detection, Emergency SOS via satellite, 48MP main camera.",
      imagePath: 'photo/Ipone14.png',
      category: 'trend',
    ),

    // Discount
    Product(
      id: 5,
      name: "iPhone 15",
      price: 849.99,
      description: "USB-C connector, Dynamic Island, 48MP main camera with 2x Telephoto.",
      imagePath: 'photo/Iphone15.png',
      category: 'discount',
    ),
    Product(
      id: 6,
      name: "AirPods Pro",
      price: 199.99,
      description: "Active Noise Cancellation, Adaptive Transparency, Personalised Spatial Audio.",
      imagePath: 'photo/Iphone15.png',
      category: 'discount',
    ),
    Product(
      id: 7,
      name: "Apple Watch SE",
      price: 249.99,
      description: "Heart rate notifications, Emergency SOS, crash detection, 18h battery.",
      imagePath: 'photo/Iphone15.png',
      category: 'discount',
    ),
    Product(
      id: 8,
      name: "iPad Air",
      price: 599.99,
      description: "M1 chip, 10.9-inch Liquid Retina display, Touch ID, 5G connectivity.",
      imagePath: 'photo/Iphone15.png',
      category: 'discount',
    ),

    // Other
    Product(
      id: 9,
      name: "MacBook Air M2",
      price: 1099.99,
      description: "M2 chip, 13.6-inch Liquid Retina display, 18-hour battery, fanless design.",
      imagePath: 'photo/photo2.jpg',
      category: 'other',
    ),
    Product(
      id: 10,
      name: "Apple TV 4K",
      price: 129.99,
      description: "A15 Bionic chip, 4K HDR with Dolby Vision, HDR10+, thread networking.",
      imagePath: 'photo/photo2.jpg',
      category: 'other',
    ),
    Product(
      id: 11,
      name: "MagSafe Charger",
      price: 39.99,
      description: "Perfectly aligned magnetic charging up to 15W for iPhone 12 and later.",
      imagePath: 'photo/photo2.jpg',
      category: 'other',
    ),
    Product(
      id: 12,
      name: "Apple Pencil 2nd Gen",
      price: 89.99,
      description: "Pixel-perfect precision, low latency, magnetic attachment and wireless charging.",
      imagePath: 'photo/photo2.jpg',
      category: 'other',
    ),
  ];

  // In-memory demo state (reset on application restart).
  final List<Product> _cart = [];
  final Set<int> _favorites = <int>{};
  final List<ShopOrder> _orders = [];

  List<Product> get shop => List.unmodifiable(_shop);
  List<Product> get cart => List.unmodifiable(_cart);
  List<ShopOrder> get orders => List.unmodifiable(_orders);
  List<Product> get favorites =>
      _shop.where((product) => _favorites.contains(product.id)).toList();

  List<Product> getByCategory(String category) =>
      _shop.where((product) => product.category == category).toList();

  bool isFavorite(int productId) => _favorites.contains(productId);

  void toggleFavorite(int productId) {
    if (!_favorites.add(productId)) {
      _favorites.remove(productId);
    }
    notifyListeners();
  }

  void addToCart(int id, Product product) {
    final index = _cart.indexWhere((item) => item.id == id);
    if (index >= 0) {
      _cart[index].quantity++;
    } else {
      _cart.add(Product(
        id: product.id,
        name: product.name,
        price: product.price,
        description: product.description,
        imagePath: product.imagePath,
        category: product.category,
      ));
    }
    notifyListeners();
  }

  void removeFromCart(Product product) {
    final index = _cart.indexWhere((item) => item.id == product.id);
    if (index < 0) return;
    if (_cart[index].quantity > 1) {
      _cart[index].quantity--;
    } else {
      _cart.removeAt(index);
    }
    notifyListeners();
  }

  void removeProductCompletely(int productId) {
    _cart.removeWhere((item) => item.id == productId);
    notifyListeners();
  }

  double getTotalPrice() =>
      _cart.fold(0.0, (sum, item) => sum + item.price * item.quantity);

  int getTotalItemCount() =>
      _cart.fold(0, (sum, item) => sum + item.quantity);

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  /// Creates a local demo order; there is no payment gateway or backend.
  ShopOrder placeDemoOrder({
    required String customerName,
    required String deliveryAddress,
    required String paymentMethod,
    String promoCode = '',
  }) {
    if (_cart.isEmpty) {
      throw StateError('Cannot check out with an empty cart.');
    }
    final subtotal = getTotalPrice();
    final discount = promoCode.trim().toUpperCase() == 'WELCOME10'
        ? subtotal * 0.10
        : 0.0;
    final now = DateTime.now();
    final order = ShopOrder(
      id: now.microsecondsSinceEpoch.toString(),
      createdAt: now,
      items: _cart
          .map((product) => Product(
                id: product.id,
                name: product.name,
                price: product.price,
                description: product.description,
                imagePath: product.imagePath,
                category: product.category,
                quantity: product.quantity,
              ))
          .toList(growable: false),
      subtotal: subtotal,
      discount: discount,
      total: subtotal - discount,
      customerName: customerName.trim(),
      deliveryAddress: deliveryAddress.trim(),
      paymentMethod: paymentMethod,
    );
    _orders.insert(0, order);
    _cart.clear();
    notifyListeners();
    return order;
  }

  String displayCartReceipt() {
    final receipt = StringBuffer()
      ..writeln("Here's your cart summary.")
      ..writeln(DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now()))
      ..writeln();
    for (final product in _cart) {
      receipt.writeln(
        '${product.quantity}x ${product.name} — \$${(product.price * product.quantity).toStringAsFixed(2)}',
      );
    }
    receipt.writeln('Total: \$${getTotalPrice().toStringAsFixed(2)}');
    return receipt.toString();
  }
}
