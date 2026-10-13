import 'package:flutter/material.dart';
import 'package:shop_app/auth/models/product.dart';
import 'package:shop_app/auth/models/product_gallery.dart';
import 'package:shop_app/auth/themes/app_palette.dart';

class ProductArtwork extends StatelessWidget {
  final Product product;
  final String? source;
  const ProductArtwork({super.key, required this.product, this.source});

  static List<String> sourcesFor(Product product) =>
      product.imagePaths.isNotEmpty
          ? product.imagePaths
          : ProductGallery.forId(product.id);

  static String urlFor(String source) {
    final filename = source.substring('commons:'.length).split('#').first;
    return 'https://commons.wikimedia.org/wiki/Special:FilePath/'
        '${Uri.encodeComponent(filename)}?width=800';
  }

  @override
  Widget build(BuildContext context) {
    final sources = sourcesFor(product);
    final selected = source ?? (sources.isEmpty ? '' : sources.first);
    if (selected.startsWith('asset:')) {
      return Image.asset(selected.substring(6), fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => _fallback());
    }
    if (selected.startsWith('commons:')) {
      return Image.network(
        urlFor(selected),
        fit: selected.endsWith('#detail') ? BoxFit.cover : BoxFit.contain,
        alignment: Alignment.center,
        filterQuality: FilterQuality.medium,
        webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
        semanticLabel: product.name + ' photograph',
        errorBuilder: (_, __, ___) => _localFallback(),
        loadingBuilder: (context, child, progress) =>
            progress == null ? child : _localFallback(),
      );
    }
    return _localFallback();
  }

  Widget _localFallback() {
    if (product.id <= 5) {
      return Image.asset(product.imagePath, fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => _fallback());
    }
    return _fallback();
  }

  IconData get _icon {
    switch (product.id) {
      case 6: return Icons.headphones_rounded;
      case 7: return Icons.watch_rounded;
      case 8: return Icons.tablet_mac_rounded;
      case 9: return Icons.laptop_mac_rounded;
      case 10: return Icons.tv_rounded;
      case 11: return Icons.bolt_rounded;
      case 12: return Icons.edit_rounded;
      default: return Icons.devices_other_rounded;
    }
  }

  Widget _fallback() => LayoutBuilder(builder: (_, constraints) {
    final size = constraints.biggest.shortestSide;
    return Center(child: Container(
      width: (size * 0.64).clamp(40.0, 190.0).toDouble(),
      height: (size * 0.64).clamp(40.0, 190.0).toDouble(),
      decoration: BoxDecoration(shape: BoxShape.circle,
          color: AppPalette.accent.withValues(alpha: 0.12)),
      child: Icon(_icon,
          size: (size * 0.34).clamp(28.0, 98.0).toDouble(),
          color: AppPalette.accent),
    ));
  });
}
