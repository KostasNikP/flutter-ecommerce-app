import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/auth/models/product.dart';
import 'package:shop_app/auth/models/shop.dart';
import 'package:shop_app/auth/themes/app_palette.dart';

class MyCartTile extends StatelessWidget {
  final Product product;
  const MyCartTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final ink = AppPalette.foreground(context);
    final muted = AppPalette.subdued(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppPalette.panel(context),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            width: 90,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppPalette.isDark(context)
                  ? const Color(0xFF2A3043)
                  : const Color(0xFFF0F1F7),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Image.asset(
              product.imagePath,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.devices_other_rounded),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: ink, fontWeight: FontWeight.w800, fontSize: 16)),
                const SizedBox(height: 5),
                Text(
                  '\$${(product.price * product.quantity).toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppPalette.accent,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _quantityButton(
                      Icons.remove_rounded,
                      'Decrease quantity',
                      () => context.read<Shop>().removeFromCart(product),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('${product.quantity}',
                          style: TextStyle(
                            color: ink,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    _quantityButton(
                      Icons.add_rounded,
                      'Increase quantity',
                      () => context.read<Shop>()
                          .addToCart(product.id, product),
                    ),
                    const Spacer(),
                    IconButton(
                      tooltip: 'Remove item',
                      visualDensity: VisualDensity.compact,
                      onPressed: () =>
                          context.read<Shop>().removeProductCompletely(product.id),
                      icon: Icon(Icons.delete_outline_rounded, color: muted),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantityButton(
      IconData icon, String tooltip, VoidCallback onPressed) {
    return SizedBox(
      width: 32,
      height: 32,
      child: IconButton.outlined(
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        iconSize: 16,
        onPressed: onPressed,
        icon: Icon(icon),
      ),
    );
  }
}
