import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/auth/components/my_product_tile.dart';
import 'package:shop_app/auth/models/shop.dart';
import 'package:shop_app/auth/themes/app_palette.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<Shop>().favorites;
    return Scaffold(
      appBar: AppBar(title: const Text('Saved favorites')),
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your wishlist',
                        style: TextStyle(
                          color: AppPalette.foreground(context),
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        )),
                    const SizedBox(height: 8),
                    Text('Keep the products you love close.',
                        style: TextStyle(
                            color: AppPalette.subdued(context))),
                    const SizedBox(height: 28),
                    if (favorites.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 72),
                          child: Column(
                            children: [
                              const Icon(Icons.favorite_border_rounded,
                                  size: 70, color: AppPalette.accent),
                              const SizedBox(height: 20),
                              const Text('Nothing saved yet',
                                  style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w700)),
                              const SizedBox(height: 8),
                              Text('Tap a heart on any product to save it.',
                                  style: TextStyle(
                                      color: AppPalette.subdued(context))),
                              const SizedBox(height: 22),
                              FilledButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Explore products'),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: favorites.length,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: constraints.maxWidth < 650 ? 210 : 275,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: constraints.maxWidth < 650 ? 0.66 : 0.73,
                        ),
                        itemBuilder: (context, index) =>
                            MyProductTile(product: favorites[index]),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
