import 'package:flutter/material.dart';
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
          constraints: const BoxConstraints(maxWidth: 690),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: Column(
              children: [
                const SizedBox(height: 30),
                Container(
                  width: 95,
                  height: 95,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppPalette.mint,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 53,
                    color: AppPalette.ink,
                  ),
                ),
                const SizedBox(height: 23),
                Text('Order placed!',
                    style: TextStyle(
                        fontSize: 33,
                        color: ink,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                Text(
                  'Thanks, ${order.customerName}! Your demo order is confirmed.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: muted, fontSize: 15),
                ),
                const SizedBox(height: 27),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(23),
                  decoration: BoxDecoration(
                    color: AppPalette.panel(context),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('YOUR RECEIPT',
                          style: TextStyle(
                              fontSize: 11,
                              letterSpacing: 1.5,
                              color: AppPalette.accent,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 15),
                      SelectableText(
                        order.receipt,
                        style: TextStyle(
                          color: ink,
                          height: 1.7,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Shipping and payment are not real in this demo.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: muted, fontSize: 12),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () =>
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/shop_page', (_) => false),
                    child: const Text('Back to shop'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
