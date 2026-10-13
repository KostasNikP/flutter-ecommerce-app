import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/auth/models/shop.dart';
import 'package:shop_app/auth/models/shop_order.dart';
import 'package:shop_app/auth/pages/order_receipt_page.dart';
import 'package:shop_app/auth/themes/app_palette.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  void _showReceipt(BuildContext context, ShopOrder order) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => OrderReceiptPage(order: order)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<Shop>().orders;
    return Scaffold(
      appBar: AppBar(title: const Text('Your orders')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: orders.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.inventory_2_outlined,
                        size: 64, color: AppPalette.accent),
                    const SizedBox(height: 16),
                    const Text('No orders yet',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 21)),
                    const SizedBox(height: 8),
                    Text('Your completed demo orders will appear here.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppPalette.subdued(context))),
                  ],
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(18),
                  itemCount: orders.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: AppPalette.panel(context),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                backgroundColor: Color(0xFFECE9FF),
                                foregroundColor: AppPalette.accent,
                                child: Icon(Icons.check_rounded),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Demo order confirmed',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700)),
                                    Text(
                                      DateFormat('dd MMM yyyy, HH:mm')
                                          .format(order.createdAt),
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: AppPalette.subdued(context)),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '\${order.total.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Text(
                            '${order.itemCount} items · #${order.id.substring(order.id.length - 6)}',
                            style: TextStyle(
                                color: AppPalette.subdued(context)),
                          ),
                          const SizedBox(height: 10),
                          OutlinedButton.icon(
                            onPressed: () => _showReceipt(context, order),
                            icon: const Icon(Icons.receipt_long_rounded),
                            label: const Text('View itemized receipt'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
