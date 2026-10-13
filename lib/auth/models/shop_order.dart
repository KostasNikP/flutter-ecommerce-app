import 'package:intl/intl.dart';
import 'package:shop_app/auth/models/product.dart';

/// A local demo order. No real payment is processed.
class ShopOrder {
  final String id;
  final DateTime createdAt;
  final List<Product> items;
  final double subtotal;
  final double discount;
  final double total;
  final String customerName;
  final String deliveryAddress;
  final String paymentMethod;
  final String promoCode;

  const ShopOrder({
    required this.id,
    required this.createdAt,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.customerName,
    required this.deliveryAddress,
    required this.paymentMethod,
    this.promoCode = '',
  });

  int get itemCount => items.fold(0, (total, item) => total + item.quantity);

  String get shortId => id.length <= 8 ? id : id.substring(id.length - 8);
  String get dateLabel => DateFormat('dd MMM yyyy, HH:mm').format(createdAt);

  String get receipt {
    final lines = StringBuffer()
      ..writeln('TECH STORE · DEMO RECEIPT')
      ..writeln('Order #$shortId')
      ..writeln('Date: $dateLabel')
      ..writeln('Status: Demo confirmed')
      ..writeln('--------------------------------');
    for (final item in items) {
      lines.writeln(item.name);
      lines.writeln(
        '${item.quantity} × \$${item.price.toStringAsFixed(2)}'
        ' = \$${(item.quantity * item.price).toStringAsFixed(2)}',
      );
    }
    lines
      ..writeln('--------------------------------')
      ..writeln('Subtotal: \$${subtotal.toStringAsFixed(2)}');
    if (discount > 0) {
      if (promoCode.isNotEmpty) lines.writeln('Promo code: $promoCode');
      lines.writeln('Discount: -\$${discount.toStringAsFixed(2)}');
    }
    lines
      ..writeln('Delivery fee (demo): \$0.00')
      ..writeln('TOTAL: \$${total.toStringAsFixed(2)}')
      ..writeln('Customer: $customerName')
      ..writeln('Address (demo): $deliveryAddress')
      ..writeln('Payment method (demo): $paymentMethod')
      ..writeln('Portfolio demo only. No payment or shipping.');
    return lines.toString();
  }
}
