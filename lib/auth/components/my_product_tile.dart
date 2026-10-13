import 'package:flutter/material.dart';
import 'package:shop_app/auth/components/product_artwork.dart';
import 'package:shop_app/auth/components/bag_feedback.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/auth/models/product.dart';
import 'package:shop_app/auth/models/shop.dart';
import 'package:shop_app/auth/pages/product_page.dart';
import 'package:shop_app/auth/themes/app_palette.dart';

class MyProductTile extends StatelessWidget {
  final Product product;
  const MyProductTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<Shop>();
    final isSaved = shop.isFavorite(product.id);
    final ink = AppPalette.foreground(context);
    final muted = AppPalette.subdued(context);
    final badge = product.category == 'discount'
        ? 'SPECIAL'
        : product.category == 'trend'
            ? 'POPULAR'
            : 'ESSENTIAL';

    return Material(
      color: AppPalette.panel(context),
      borderRadius: BorderRadius.circular(22),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductPage(product: product),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ProductArtwork(product: product),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppPalette.mint,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          badge,
                          style: const TextStyle(
                            color: AppPalette.ink,
                            fontSize: 9,
                            letterSpacing: 0.7,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: IconButton.filledTonal(
                        tooltip: isSaved
                            ? 'Remove from wishlist'
                            : 'Add to wishlist',
                        onPressed: () =>
                            context.read<Shop>().toggleFavorite(product.id),
                        icon: Icon(
                          isSaved
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size: 19,
                          color: isSaved ? const Color(0xFFE74C74) : ink,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 13),
              Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: ink,
                    fontSize: 15),
              ),
              const SizedBox(height: 4),
              Text(
                product.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: muted, fontSize: 11, height: 1.3),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: ink,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: IconButton.filled(
                      tooltip: 'Add to bag',
                      onPressed: () {
                        context.read<Shop>().addToCart(product.id, product);
                        BagFeedback.show(context);
                      },
                      icon: const Icon(Icons.add_rounded, size: 22),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
