import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_app/auth/models/shop_order.dart';
import 'package:shop_app/auth/themes/app_palette.dart';

/// Itemized, responsive receipt shared by confirmation and order history.
class ReceiptCard extends StatelessWidget {
  final ShopOrder order;
  const ReceiptCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final ink = AppPalette.foreground(context);
    final muted = AppPalette.subdued(context);
    final narrow = MediaQuery.sizeOf(context).width < 380;
    String money(double amount) => r'$' + amount.toStringAsFixed(2);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(narrow ? 16 : 24),
      decoration: BoxDecoration(
        color: AppPalette.panel(context),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: AppPalette.mint,
                foregroundColor: AppPalette.ink,
                child: Icon(Icons.receipt_long_rounded),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order receipt',
                        style: TextStyle(fontSize: 19, color: ink,
                            fontWeight: FontWeight.w800)),
                    Text('Order #${order.shortId}',
                        style: TextStyle(fontSize: 12, color: muted)),
                  ],
                ),
              ),
              const Icon(Icons.check_circle_rounded, color: AppPalette.accent),
            ],
          ),
          const SizedBox(height: 22),
          _line('Date', order.dateLabel, muted, ink),
          const SizedBox(height: 9),
          _line('Status', 'Demo confirmed', muted, ink),
          const Divider(height: 30),
          Text('ORDER ITEMS · ${order.itemCount}',
              style: TextStyle(color: muted, letterSpacing: 1,
                  fontWeight: FontWeight.w800, fontSize: 12)),
          const SizedBox(height: 14),
          ...order.items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name,
                          style: TextStyle(color: ink,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text('${item.quantity} × ${money(item.price)}',
                          style: TextStyle(color: muted, fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(width: 9),
                Text(money(item.quantity * item.price),
                    style: TextStyle(color: ink,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          )),
          const Divider(height: 20),
          _line('Subtotal', money(order.subtotal), muted, ink),
          if (order.discount > 0) ...[
            const SizedBox(height: 10),
            _line(
              order.promoCode.isEmpty ? 'Discount' : 'Discount · ${order.promoCode}',
              '-${money(order.discount)}',
              muted,
              AppPalette.accent,
            ),
          ],
          const SizedBox(height: 10),
          _line('Delivery (demo)', money(0), muted, ink),
          const Divider(height: 30),
          _line('TOTAL', money(order.total), ink, ink, large: true),
          const Divider(height: 32),
          Text('DELIVERY & PAYMENT',
              style: TextStyle(color: muted, letterSpacing: 1,
                  fontWeight: FontWeight.w800, fontSize: 12)),
          const SizedBox(height: 12),
          Text(order.customerName,
              style: TextStyle(color: ink, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(order.deliveryAddress, style: TextStyle(color: muted)),
          const SizedBox(height: 10),
          Text('Payment: ${order.paymentMethod} (demo)',
              style: TextStyle(color: muted)),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: order.receipt));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Receipt copied to clipboard')),
                  );
                }
              },
              icon: const Icon(Icons.copy_rounded),
              label: const Text('Copy receipt'),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text('Portfolio demo · No payment or shipping.',
                textAlign: TextAlign.center,
                style: TextStyle(color: muted, fontSize: 11)),
          ),
        ],
      ),
    );
  }

  Widget _line(String label, String value, Color labelColor,
      Color valueColor, {bool large = false}) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: TextStyle(
              color: labelColor,
              fontSize: large ? 15 : 13,
              fontWeight: large ? FontWeight.w800 : FontWeight.w500)),
        ),
        const SizedBox(width: 9),
        Flexible(
          child: Text(value,
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: valueColor,
                  fontSize: large ? 23 : 14,
                  fontWeight: FontWeight.w800)),
        ),
      ],
    );
  }
}
