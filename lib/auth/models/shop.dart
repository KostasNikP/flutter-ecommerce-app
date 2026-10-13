import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/auth/models/product.dart';
import 'package:shop_app/auth/models/shop_order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Shop extends ChangeNotifier {
  Shop({SharedPreferences? preferences}) : _preferences = preferences {
    _restore();
  }

  static const _storageKey = 'nova.store.v1';
  final SharedPreferences? _preferences;

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
    _notifyAndPersist();
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
    _notifyAndPersist();
  }

  void removeFromCart(Product product) {
    final index = _cart.indexWhere((item) => item.id == product.id);
    if (index < 0) return;
    if (_cart[index].quantity > 1) {
      _cart[index].quantity--;
    } else {
      _cart.removeAt(index);
    }
    _notifyAndPersist();
  }

  void removeProductCompletely(int productId) {
    _cart.removeWhere((item) => item.id == productId);
    _notifyAndPersist();
  }

  double getTotalPrice() =>
      _cart.fold(0.0, (sum, item) => sum + item.price * item.quantity);

  int getTotalItemCount() =>
      _cart.fold(0, (sum, item) => sum + item.quantity);

  void clearCart() {
    _cart.clear();
    _notifyAndPersist();
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
    _notifyAndPersist();
    return order;
  }

  Map<String, dynamic> _productJson(Product product) => {
        'id': product.id,
        'name': product.name,
        'price': product.price,
        'description': product.description,
        'image': product.imagePath,
        'category': product.category,
        'quantity': product.quantity,
      };

  Product _productFromJson(Object? raw) {
    final item = Map<String, dynamic>.from(raw as Map);
    return Product(
      id: (item['id'] as num).toInt(),
      name: item['name'] as String,
      price: (item['price'] as num).toDouble(),
      description: item['description'] as String,
      imagePath: item['image'] as String,
      category: item['category'] as String,
      quantity: (item['quantity'] as num).toInt(),
    );
  }

  Map<String, dynamic> _orderJson(ShopOrder order) => {
        'id': order.id,
        'createdAt': order.createdAt.toIso8601String(),
        'items': order.items.map(_productJson).toList(),
        'subtotal': order.subtotal,
        'discount': order.discount,
        'total': order.total,
        'customerName': order.customerName,
        'deliveryAddress': order.deliveryAddress,
        'paymentMethod': order.paymentMethod,
      };

  ShopOrder _orderFromJson(Object? raw) {
    final item = Map<String, dynamic>.from(raw as Map);
    return ShopOrder(
      id: item['id'] as String,
      createdAt: DateTime.parse(item['createdAt'] as String),
      items: (item['items'] as List)
          .map(_productFromJson)
          .toList(growable: false),
      subtotal: (item['subtotal'] as num).toDouble(),
      discount: (item['discount'] as num).toDouble(),
      total: (item['total'] as num).toDouble(),
      customerName: item['customerName'] as String,
      deliveryAddress: item['deliveryAddress'] as String,
      paymentMethod: item['paymentMethod'] as String,
    );
  }

  void _persist() {
    final prefs = _preferences;
    if (prefs == null) return;
    final payload = <String, dynamic>{
      'favorites': _favorites.toList(),
      'cart': _cart.map(_productJson).toList(),
      'orders': _orders.map(_orderJson).toList(),
    };
    unawaited(prefs.setString(_storageKey, jsonEncode(payload)));
  }

  void _restore() {
    final raw = _preferences?.getString(_storageKey);
    if (raw == null) return;
    try {
      final data = jsonDecode(raw);
      if (data is! Map<String, dynamic>) return;

      final favorites = data['favorites'];
      if (favorites is List) {
        for (final id in favorites) {
          if (id is num && _shop.any((item) => item.id == id.toInt())) {
            _favorites.add(id.toInt());
          }
        }
      }

      final cart = data['cart'];
      if (cart is List) {
        for (final rawProduct in cart) {
          try {
            final product = _productFromJson(rawProduct);
            if (product.quantity >= 1 &&
                product.quantity <= 99 &&
                _shop.any((item) => item.id == product.id)) {
              _cart.add(product);
            }
          } catch (_) {
            // Skip invalid locally saved products.
          }
        }
      }

      final orders = data['orders'];
      if (orders is List) {
        for (final rawOrder in orders) {
          try {
            _orders.add(_orderFromJson(rawOrder));
          } catch (_) {
            // Skip outdated or corrupted records.
          }
        }
      }
    } catch (_) {
      // A damaged local cache should never prevent startup.
    }
  }

  void _notifyAndPersist() {
    _persist();
    notifyListeners();
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
