import 'package:flutter/material.dart';
import 'package:shop_app/auth/components/product_artwork.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/auth/models/product.dart';
import 'package:shop_app/auth/models/shop.dart';
import 'package:shop_app/auth/themes/app_palette.dart';

class ProductPage extends StatefulWidget {
  final Product product;
  const ProductPage({super.key, required this.product});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int quantity = 1;

  void addToBag() {
    for (var i = 0; i < quantity; i++) {
      context.read<Shop>().addToCart(widget.product.id, widget.product);
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text('$quantity × ${widget.product.name} added to your bag'),
        action: SnackBarAction(
          label: 'VIEW BAG',
          onPressed: () => Navigator.pushNamed(context, '/cart_page'),
        ),
      ));
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final shop = context.watch<Shop>();
    final saved = shop.isFavorite(product.id);
    final ink = AppPalette.foreground(context);
    final muted = AppPalette.subdued(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product details'),
        actions: [
          IconButton(
            tooltip: saved ? 'Remove from wishlist' : 'Add to wishlist',
            icon: Icon(saved
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded),
            color: saved ? const Color(0xFFE74C74) : ink,
            onPressed: () => context.read<Shop>().toggleFavorite(product.id),
          ),
          IconButton(
            tooltip: 'Shopping bag',
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () => Navigator.pushNamed(context, '/cart_page'),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth > 760;
          final image = Container(
            height: wide ? 490 : 310,
            width: wide ? 470 : double.infinity,
            padding: const EdgeInsets.all(35),
            decoration: BoxDecoration(
              color: AppPalette.panel(context),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Hero(
              tag: 'product-${product.id}',
              child: ProductArtwork(product: product),
            ),
          );
          final details = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: AppPalette.mint,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Text('THE TECH COLLECTION',
                    style: TextStyle(
                      color: AppPalette.ink,
                      fontSize: 11,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w800,
                    )),
              ),
              const SizedBox(height: 17),
              Text(product.name,
                  style: TextStyle(
                      color: ink,
                      fontSize: wide ? 37 : 30,
                      letterSpacing: -1,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              Text('\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                      color: AppPalette.accent,
                      fontSize: 27,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 25),
              Text('About this product',
                  style: TextStyle(
                      color: ink,
                      fontSize: 17,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 9),
              Text(product.description,
                  style: TextStyle(color: muted, height: 1.65, fontSize: 15)),
              const SizedBox(height: 25),
              Text('Quantity',
                  style:
                      TextStyle(color: ink, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Row(
                children: [
                  IconButton.outlined(
                    onPressed:
                        quantity > 1 ? () => setState(() => quantity--) : null,
                    icon: const Icon(Icons.remove_rounded),
                  ),
                  SizedBox(
                    width: 55,
                    child: Text('$quantity',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: ink,
                            fontWeight: FontWeight.w800,
                            fontSize: 18)),
                  ),
                  IconButton.outlined(
                    onPressed: quantity < 99
                        ? () => setState(() => quantity++)
                        : null,
                    icon: const Icon(Icons.add_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: addToBag,
                  icon: const Icon(Icons.shopping_bag_outlined),
                  label: Text(
                      'Add to bag · \$${(product.price * quantity).toStringAsFixed(2)}'),
                ),
              ),
              const SizedBox(height: 14),
              Text('Demo storefront · No real purchase is made.',
                  style: TextStyle(fontSize: 12, color: muted)),
            ],
          );

          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1080),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: wide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            image,
                            const SizedBox(width: 40),
                            Expanded(child: details),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            image,
                            const SizedBox(height: 28),
                            details,
                          ],
                        ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
