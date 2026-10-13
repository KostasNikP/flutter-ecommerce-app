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
  });

  int get itemCount => items.fold(0, (total, item) => total + item.quantity);

  String get receipt {
    final lines = StringBuffer()
      ..writeln('NOVA / Demo order #$id')
      ..writeln(DateFormat('dd MMM yyyy, HH:mm').format(createdAt))
      ..writeln('--------------------------------');
    for (final item in items) {
      lines.writeln('${item.quantity} x ${item.name}  \$${(item.price * item.quantity).toStringAsFixed(2)}');
    }
    lines
      ..writeln('--------------------------------')
      ..writeln('Subtotal: \$${subtotal.toStringAsFixed(2)}');
    if (discount > 0) {
      lines.writeln('Discount: -\$${discount.toStringAsFixed(2)}');
    }
    lines
      ..writeln('Total: \$${total.toStringAsFixed(2)}')
      ..writeln('Status: Demo order confirmed');
    return lines.toString();
  }
}
