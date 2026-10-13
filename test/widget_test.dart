import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/auth/themes/theme_provider.dart';
import 'package:shop_app/auth/models/shop.dart';

void main() {
  group('Shop cart', () {
    late Shop shop;

    setUp(() {
      shop = Shop();
    });

    test('starts empty', () {
      expect(shop.cart, isEmpty);
      expect(shop.getTotalPrice(), 0);
      expect(shop.getTotalItemCount(), 0);
    });

    test('adding the same product updates quantity and total', () {
      final product = shop.shop.first;
      shop.addToCart(product.id, product);
      shop.addToCart(product.id, product);

      expect(shop.cart.length, 1);
      expect(shop.getTotalItemCount(), 2);
      expect(shop.getTotalPrice(), closeTo(product.price * 2, 0.001));
    });

    test('removing items reduces quantity then removes product', () {
      final product = shop.shop.first;
      shop.addToCart(product.id, product);
      shop.addToCart(product.id, product);
      shop.removeFromCart(shop.cart.first);

      expect(shop.getTotalItemCount(), 1);
      shop.removeFromCart(shop.cart.first);
      expect(shop.cart, isEmpty);
    });

    test('clearing the cart resets totals', () {
      final product = shop.shop.first;
      shop.addToCart(product.id, product);
      shop.clearCart();

      expect(shop.cart, isEmpty);
      expect(shop.getTotalPrice(), 0);
    });

    test('category filtering uses product category', () {
      final trending = shop.getByCategory('trend');
      expect(trending, isNotEmpty);
      expect(trending.every((product) => product.category == 'trend'), isTrue);
    });


    test('wishlist toggles without duplicates', () {
      final first = shop.shop.first;
      shop.toggleFavorite(first.id);
      expect(shop.isFavorite(first.id), isTrue);
      expect(shop.favorites.length, 1);
      shop.toggleFavorite(first.id);
      expect(shop.isFavorite(first.id), isFalse);
      expect(shop.favorites, isEmpty);
    });

    test('complete removal clears all quantities for a product', () {
      final item = shop.shop.first;
      shop.addToCart(item.id, item);
      shop.addToCart(item.id, item);
      shop.removeProductCompletely(item.id);
      expect(shop.cart, isEmpty);
    });

    test('demo order creates snapshot, applies coupon, clears cart', () {
      final item = shop.shop.first;
      shop.addToCart(item.id, item);
      shop.addToCart(item.id, item);
      final order = shop.placeDemoOrder(
        customerName: 'Test User',
        deliveryAddress: '123 Demo Street',
        paymentMethod: 'Demo card',
        promoCode: 'welcome10',
      );

      expect(order.itemCount, 2);
      expect(order.subtotal, closeTo(item.price * 2, 0.001));
      expect(order.discount, closeTo(item.price * 0.2, 0.001));
      expect(order.total, closeTo(item.price * 1.8, 0.001));
      expect(shop.cart, isEmpty);
      expect(shop.orders.single.id, order.id);
      expect(order.receipt, contains('Tech Store / Demo order'));
      expect(order.receipt, contains('Test User'));
      expect(order.receipt, contains('WELCOME10'));
      expect(order.promoCode, 'WELCOME10');

      // A new cart must not alter a completed order's item snapshot.
      shop.addToCart(item.id, item);
      expect(order.items.single.quantity, 2);
      expect(shop.getTotalItemCount(), 1);
    });

    test('checking out with an empty cart is rejected', () {
      expect(
        () => shop.placeDemoOrder(
          customerName: 'Test',
          deliveryAddress: 'Demo address',
          paymentMethod: 'Demo card',
        ),
        throwsStateError,
      );
    });
  });
  group('Local persistence', () {
    test('favorites, orders and bag survive a restart', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final shop = Shop(preferences: prefs);
      final product = shop.shop.first;

      shop.toggleFavorite(product.id);
      shop.addToCart(product.id, product);
      shop.placeDemoOrder(
        customerName: 'Demo Customer',
        deliveryAddress: '123 Example Street',
        paymentMethod: 'Demo card',
      );
      shop.addToCart(product.id, product);

      await Future<void>.delayed(const Duration(milliseconds: 30));
      final restored = Shop(preferences: prefs);
      expect(restored.isFavorite(product.id), isTrue);
      expect(restored.getTotalItemCount(), 1);
      expect(restored.orders.single.itemCount, 1);
      expect(restored.orders.single.total, closeTo(product.price, 0.001));
    });

    test('theme preference survives a restart', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final theme = ThemeProvider(preferences: prefs);
      theme.toggleTheme();
      await Future<void>.delayed(const Duration(milliseconds: 30));
      expect(ThemeProvider(preferences: prefs).isDarkMode, isTrue);
    });
  });

}
