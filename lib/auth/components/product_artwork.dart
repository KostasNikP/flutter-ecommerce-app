import 'package:flutter/material.dart';
import 'package:shop_app/auth/models/product.dart';
import 'package:shop_app/auth/themes/app_palette.dart';

/// Correctly matched photographs for each demo product.
/// The first five iPhones use bundled assets. Other photos are served by
/// Wikimedia Commons under the licenses detailed in IMAGE_CREDITS.md.
/// A product-specific illustration is shown offline or on a network failure.
class ProductArtwork extends StatelessWidget {
  final Product product;

  const ProductArtwork({super.key, required this.product});

  static const Map<int, String> _commonsFiles = {
    6: 'AirPods Pro (2nd generation).jpg',
    7: 'Watch SE (2nd generation).jpg',
    8: 'IPad Air 5th Generation 2024.jpg',
    9: 'M2 Macbook Air Starlight model.jpg',
    10: 'Apple TV 4K (3rd Generation, 2022) with Siri Remote (cropped).jpg',
    11: 'MagSafe and USB-C Cable Charger for iPhone.jpg',
    12: 'Apple Pencil Second Generation - 2.jpg',
  };

  static String? photoUrlFor(int id) {
    final file = _commonsFiles[id];
    if (file == null) return null;
    return 'https://commons.wikimedia.org/wiki/Special:FilePath/'
        '${Uri.encodeComponent(file)}?width=640';
  }

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

    final photoUrl = photoUrlFor(product.id);
    if (photoUrl == null) return _illustration();

    return Image.network(
      photoUrl,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
      semanticLabel: 'Photograph of ${product.name}',
      errorBuilder: (_, __, ___) => _illustration(),
      loadingBuilder: (context, child, progress) {
        return progress == null ? child : _illustration();
      },
    );
  }

  Widget _illustration() => LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.biggest.shortestSide;
          final diameter = (size * 0.64).clamp(40.0, 190.0).toDouble();
          final iconSize = (size * 0.34).clamp(28.0, 98.0).toDouble();
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
