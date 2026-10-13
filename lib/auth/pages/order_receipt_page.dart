import 'package:flutter/material.dart';
import 'package:shop_app/auth/components/receipt_card.dart';
import 'package:shop_app/auth/models/shop_order.dart';

class OrderReceiptPage extends StatelessWidget {
  final ShopOrder order;
  const OrderReceiptPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Receipt details')),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [
                ReceiptCard(order: order),
                const SizedBox(height: 18),
                FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Back to orders'),
                ),
              ],
            ),
          ),
        ),
      );
}
