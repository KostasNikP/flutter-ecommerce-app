import 'package:flutter/material.dart';
import 'package:shop_app/auth/models/product.dart';
import 'package:shop_app/auth/themes/app_palette.dart';

/// A unified, locally rendered visual for each product; no external photos.
class ProductArtwork extends StatelessWidget {
  final Product product;
  const ProductArtwork({super.key, required this.product});

  static IconData iconFor(int id) {
    switch (id) {
      case 1:
      case 2:
      case 3:
      case 4:
      case 5:
        return Icons.smartphone_rounded;
      case 6:
        return Icons.headphones_rounded;
      case 7:
        return Icons.watch_rounded;
      case 8:
        return Icons.tablet_mac_rounded;
      case 9:
        return Icons.laptop_mac_rounded;
      case 10:
        return Icons.tv_rounded;
      case 11:
        return Icons.battery_charging_full_rounded;
      case 12:
        return Icons.edit_rounded;
      default:
        return Icons.devices_other_rounded;
    }
  }

  static Color colorFor(int id) {
    switch (id) {
      case 6: return const Color(0xFF91E1D1);
      case 7: return const Color(0xFFA2B8FF);
      case 8: return const Color(0xFFB9A4FF);
      case 9: return const Color(0xFF8BC8F2);
      case 10: return const Color(0xFFAAA5F9);
      case 11: return const Color(0xFFCDFA86);
      case 12: return const Color(0xFFFFC49A);
      default: return const Color(0xFFB9A4FF);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = colorFor(product.id);
    final isDark = AppPalette.isDark(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final shortest = constraints.biggest.shortestSide;
        final iconSize = (shortest * 0.43).clamp(24.0, 125.0).toDouble();

        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? const [Color(0xFF292C44), Color(0xFF181B2D)]
                  : const [Color(0xFFF0F0FA), Color(0xFFE9EBF6)],
            ),
          ),
          child: Center(
            child: Icon(
              iconFor(product.id),
              size: iconSize,
              color: color,
              semanticLabel: product.name,
            ),
          ),
        );
      },
    );
  }
}
