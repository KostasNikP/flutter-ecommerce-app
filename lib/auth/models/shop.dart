import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/auth/models/product.dart';
import 'package:shop_app/auth/models/product_gallery.dart';
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
      description: "A dependable everyday iPhone with a 6.1-inch Liquid Retina HD display, A13 Bionic chip, and dual 12MP cameras with Night mode and 4K video.",
      imagePath: 'photo/Iphone11.png',
      imagePaths: ProductGallery.forId(1),
      category: 'trend',
    ),
    Product(
      id: 2,
      name: "iPhone 12",
      price: 599.99,
      description: "A lightweight 5G-ready iPhone with a 6.1-inch Super Retina XDR OLED display, A14 Bionic performance, Ceramic Shield, and dual rear cameras.",
      imagePath: 'photo/Iphone12.png',
      imagePaths: ProductGallery.forId(2),
      category: 'trend',
    ),
    Product(
      id: 3,
      name: "iPhone 13",
      price: 699.99,
      description: "Enjoy sharp photos, a vibrant 6.1-inch OLED display, and efficient A15 Bionic performance. The dual-camera system includes sensor-shift stabilization.",
      imagePath: 'photo/Ipone13.png',
      imagePaths: ProductGallery.forId(3),
      category: 'trend',
    ),
    Product(
      id: 4,
      name: "iPhone 14",
      price: 799.99,
      description: "A polished 6.1-inch iPhone with an advanced dual-camera system, Photonic Engine, A15 Bionic chip, Crash Detection, and Emergency SOS via satellite where supported.",
      imagePath: 'photo/Ipone14.png',
      imagePaths: ProductGallery.forId(4),
      category: 'trend',
    ),

    // Discount
    Product(
      id: 5,
      name: "iPhone 15",
      price: 849.99,
      description: "A 6.1-inch Super Retina XDR iPhone with Dynamic Island, a 48MP main camera, USB-C charging, and the A16 Bionic chip.",
      imagePath: 'photo/Iphone15.png',
      imagePaths: ProductGallery.forId(5),
      category: 'discount',
    ),
    Product(
      id: 6,
      name: "AirPods Pro (2nd Gen)",
      price: 199.99,
      description: "Premium in-ear wireless earbuds with Active Noise Cancellation, Adaptive Transparency, personalized Spatial Audio, and a compact charging case.",
      imagePath: 'photo/photo1.jpg',
      imagePaths: ProductGallery.forId(6),
      category: 'discount',
    ),
    Product(
      id: 7,
      name: "Apple Watch SE (2nd Gen)",
      price: 249.99,
      description: "An everyday smartwatch for activity, heart-rate tracking, sleep insights, Crash Detection, and calls and messages when paired with a compatible iPhone.",
      imagePath: 'photo/photo1.jpg',
      imagePaths: ProductGallery.forId(7),
      category: 'discount',
    ),
    Product(
      id: 8,
      name: "iPad Air (5th Gen)",
      price: 599.99,
      description: "A versatile 10.9-inch tablet powered by Apple M1, with a Liquid Retina display, Touch ID, USB-C, and support for Apple Pencil (2nd generation).",
      imagePath: 'photo/photo1.jpg',
      imagePaths: ProductGallery.forId(8),
      category: 'discount',
    ),

    // Other
    Product(
      id: 9,
      name: "MacBook Air 13-inch (M2)",
      price: 1099.99,
      description: "Thin and silent laptop featuring the Apple M2 chip, a 13.6-inch Liquid Retina display, MagSafe charging, and up to 18 hours of video playback.",
      imagePath: 'photo/photo1.jpg',
      imagePaths: ProductGallery.forId(9),
      category: 'other',
    ),
    Product(
      id: 10,
      name: "Apple TV 4K (3rd Gen)",
      price: 129.99,
      description: "Stream films and series in 4K HDR with Dolby Vision, HDR10+, and Dolby Atmos on supported systems. Includes the Siri Remote and A15 Bionic chip.",
      imagePath: 'photo/photo1.jpg',
      imagePaths: ProductGallery.forId(10),
      category: 'other',
    ),
    Product(
      id: 11,
      name: "Apple MagSafe Charger",
      price: 39.99,
      description: "Snap the magnetic charging puck onto a compatible iPhone for easy alignment and wireless charging. A USB-C power adapter is sold separately.",
      imagePath: 'photo/photo1.jpg',
      imagePaths: ProductGallery.forId(11),
      category: 'other',
    ),
    Product(
      id: 12,
      name: "Apple Pencil (2nd Gen)",
      price: 89.99,
      description: "A pressure- and tilt-sensitive stylus for compatible iPad models, with low-latency drawing, wireless magnetic pairing and charging, and double-tap tool switching.",
      imagePath: 'photo/photo1.jpg',
      imagePaths: ProductGallery.forId(12),
      category: 'other',
    ),
  ];

  // Demo state is stored locally and restored on the next launch.
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
                imagePaths: product.imagePaths,
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
                imagePaths: product.imagePaths,
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
      promoCode: discount > 0 ? 'WELCOME10' : '',
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
        'images': product.imagePaths,
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
      imagePaths: (item['images'] as List?)?.whereType<String>().toList() ??
          ProductGallery.forId((item['id'] as num).toInt()),
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
        'promoCode': order.promoCode,
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
      promoCode: item['promoCode'] as String? ?? '',
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
