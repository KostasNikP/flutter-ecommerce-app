import 'package:flutter/material.dart';
import 'package:shop_app/auth/models/product.dart';
import 'package:shop_app/auth/themes/app_palette.dart';

/// Uses real bundled images where available, meaningful illustrations otherwise.
class ProductArtwork extends StatelessWidget {
  final Product product;
  const ProductArtwork({super.key, required this.product});

  IconData get _fallbackIcon {
    switch (product.id) {
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
        return Icons.bolt_rounded;
      case 12:
        return Icons.edit_rounded;
      default:
        return Icons.devices_other_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (product.id <= 5) {
      return Image.asset(
        product.imagePath,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _illustration(),
      );
    }
    return _illustration();
  }

  Widget _illustration() => LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.biggest.shortestSide;
          final diameter = (size * 0.64).clamp(40.0, 190.0);
          final iconSize = (size * 0.34).clamp(28.0, 98.0);
          return Center(
            child: Container(
              width: diameter,
              height: diameter,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppPalette.accent.withValues(alpha: 0.12),
              ),
              child: Icon(
                _fallbackIcon,
                size: iconSize,
                color: AppPalette.accent,
              ),
            ),
          );
        },
      );
}
