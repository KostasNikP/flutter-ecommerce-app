import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/auth/components/my_cart_tile.dart';
import 'package:shop_app/auth/models/shop.dart';
import 'package:shop_app/auth/pages/payment_page.dart';
import 'package:shop_app/auth/themes/app_palette.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  Future<void> _confirmClear(BuildContext context, Shop shop) async {
    final clear = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Empty your bag?'),
        content: const Text('This will remove every item from your bag.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep items'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear bag'),
          ),
        ],
      ),
    );
    if (clear == true) shop.clearCart();
  }

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<Shop>();
    final cart = shop.cart;
    final ink = AppPalette.foreground(context);
    final muted = AppPalette.subdued(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your bag'),
        actions: [
          if (cart.isNotEmpty)
            TextButton.icon(
              onPressed: () => _confirmClear(context, shop),
              icon: const Icon(Icons.delete_outline_rounded),
              label: const Text('Clear'),
            ),
          const SizedBox(width: 10),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 850),
          child: cart.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_bag_outlined,
                        size: 70, color: AppPalette.accent),
                    const SizedBox(height: 20),
                    Text('Your bag is empty',
                        style: TextStyle(
                            color: ink,
                            fontSize: 23,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    Text('Discover something great in the collection.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: muted)),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Continue shopping'),
                    ),
                  ],
                )
              : ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Text('Shopping bag',
                        style: TextStyle(
                            color: ink,
                            fontWeight: FontWeight.w800,
                            fontSize: 29)),
                    const SizedBox(height: 4),
                    Text(
                        '${shop.getTotalItemCount()} items · Ready when you are',
                        style: TextStyle(color: muted)),
                    const SizedBox(height: 22),
                    ...cart.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: MyCartTile(product: item),
                        )),
                    const SizedBox(height: 14),
                    Container(
                      decoration: BoxDecoration(
                        color: AppPalette.panel(context),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text('Subtotal',
                                  style: TextStyle(color: muted)),
                              const Spacer(),
                              Text(
                                '\$${shop.getTotalPrice().toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: ink,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 19,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text('Demo checkout — no actual charge.',
                              style: TextStyle(color: muted, fontSize: 12)),
                          const SizedBox(height: 17),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const PaymentPage()),
                              ),
                              icon: const Icon(Icons.lock_outline_rounded),
                              label: const Text('Continue to checkout'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
