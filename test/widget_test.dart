import 'package:flutter_test/flutter_test.dart';
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
  });
}
