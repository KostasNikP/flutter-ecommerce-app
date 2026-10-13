import 'package:flutter/material.dart';
import 'package:shop_app/auth/components/receipt_card.dart';
import 'package:shop_app/auth/models/shop_order.dart';
import 'package:shop_app/auth/themes/app_palette.dart';

class DeliveryProgressPage extends StatelessWidget {
  final ShopOrder order;
  const DeliveryProgressPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final ink = AppPalette.foreground(context);
    final muted = AppPalette.subdued(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order confirmed'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 32),
            children: [
              const SizedBox(height: 12),
              const CircleAvatar(
                radius: 39,
                backgroundColor: AppPalette.mint,
                child: Icon(Icons.check_rounded,
                    color: AppPalette.ink, size: 44),
              ),
              const SizedBox(height: 18),
              Text('Order placed!', textAlign: TextAlign.center,
                  style: TextStyle(color: ink, fontSize: 30,
                      fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              Text('Thanks, ' + order.customerName + '! Your demo order is confirmed.',
                  textAlign: TextAlign.center, style: TextStyle(color: muted)),
              const SizedBox(height: 26),
              ReceiptCard(order: order),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, '/shop_page', (_) => false),
                icon: const Icon(Icons.storefront_rounded),
                label: const Text('Continue shopping'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/orders_page'),
                icon: const Icon(Icons.history_rounded),
                label: const Text('Order history'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
