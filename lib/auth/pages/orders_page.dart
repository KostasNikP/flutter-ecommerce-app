import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/auth/models/shop.dart';
import 'package:shop_app/auth/models/shop_order.dart';
import 'package:shop_app/auth/pages/order_receipt_page.dart';
import 'package:shop_app/auth/themes/app_palette.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<Shop>().orders;
    final ink = AppPalette.foreground(context);
    final muted = AppPalette.subdued(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Your orders')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: orders.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.receipt_long_outlined,
                          size: 58, color: AppPalette.accent),
                      const SizedBox(height: 18),
                      Text('No orders yet',
                          style: TextStyle(color: ink,
                              fontSize: 22, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      Text(
                        'Your order history will appear here after checkout.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: muted, height: 1.5),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 30),
                  itemCount: orders.length + 1,
                  separatorBuilder: (_, index) =>
                      SizedBox(height: index == 0 ? 18 : 12),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Order history',
                              style: TextStyle(
                                color: ink,
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.6,
                              )),
                          const SizedBox(height: 5),
                          Text('Review past orders and their receipts.',
                              style: TextStyle(color: muted, fontSize: 13)),
                        ],
                      );
                    }
                    return _OrderCard(order: orders[index - 1]);
                  },
                ),
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final ShopOrder order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final ink = AppPalette.foreground(context);
    final muted = AppPalette.subdued(context);
    final total = NumberFormat.currency(
      locale: 'en_US', symbol: r'$', decimalDigits: 2,
    ).format(order.total);
    final countLabel = order.itemCount == 1
        ? '1 item'
        : '${order.itemCount} items';

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 520;
        final heading = Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 23,
              backgroundColor: Color(0xFFEAE8FF),
              foregroundColor: AppPalette.accent,
              child: Icon(Icons.check_rounded, size: 26),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Order confirmed',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: ink,
                        fontSize: 16,
                        height: 1.25,
                        fontWeight: FontWeight.w800,
                      )),
                  const SizedBox(height: 4),
                  Text(order.dateLabel,
                      maxLines: 2,
                      style: TextStyle(color: muted, fontSize: 12)),
                ],
              ),
            ),
            if (!compact) ...[
              const SizedBox(width: 16),
              Text(total,
                  style: TextStyle(color: ink,
                      fontSize: 21, fontWeight: FontWeight.w800)),
            ],
          ],
        );

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(compact ? 16 : 22),
          decoration: BoxDecoration(
            color: AppPalette.panel(context),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: AppPalette.isDark(context)
                  ? const Color(0xFF303448)
                  : const Color(0xFFE6E8F0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              heading,
              const SizedBox(height: 18),
              if (compact) ...[
                Row(
                  children: [
                    Text('Total',
                        style: TextStyle(color: muted, fontSize: 13)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(total,
                          textAlign: TextAlign.end,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: ink,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          )),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
              Text('$countLabel  ·  Order #${order.shortId}',
                  maxLines: 2,
                  style: TextStyle(color: muted, fontSize: 13)),
              const SizedBox(height: 16),
              SizedBox(
                width: compact ? double.infinity : null,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrderReceiptPage(order: order),
                    ),
                  ),
                  icon: const Icon(Icons.receipt_long_outlined, size: 19),
                  label: const Text('View receipt'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
