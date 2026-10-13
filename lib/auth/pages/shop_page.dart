import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/auth/components/my_drawer.dart';
import 'package:shop_app/auth/components/my_product_tile.dart';
import 'package:shop_app/auth/models/product.dart';
import 'package:shop_app/auth/models/shop.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _category = 'all';

  static const Map<String, String> _categories = {
    'all': 'All products',
    'trend': 'Trending',
    'discount': 'Deals',
    'other': 'More tech',
  };

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Product> _visibleProducts(List<Product> products) {
    final query = _searchQuery.trim().toLowerCase();
    return products.where((product) {
      final matchesCategory =
          _category == 'all' || product.category == _category;
      final matchesSearch = query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<Shop>();
    final products = _visibleProducts(shop.shop);
    final isDark =
        Theme.of(context).colorScheme.surface.computeLuminance() < 0.2;
    final background =
        isDark ? const Color(0xFF0D1117) : const Color(0xFFF7F8FA);
    final foreground =
        isDark ? const Color(0xFFF5F7FA) : const Color(0xFF151D29);
    final muted =
        isDark ? const Color(0xFFA7B0BD) : const Color(0xFF677281);
    final fieldColor =
        isDark ? const Color(0xFF1A222C) : Colors.white;
    final stroke =
        isDark ? const Color(0xFF33404D) : const Color(0xFFE4E8EE);

    return Scaffold(
      backgroundColor: background,
      drawer: const MyDrawer(),
      appBar: AppBar(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        foregroundColor: foreground,
        toolbarHeight: 68,
        leading: Builder(
          builder: (context) => IconButton(
            tooltip: 'Open menu',
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          'shop.',
          style: TextStyle(
            color: foreground,
            fontSize: 25,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.3,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Open cart',
            onPressed: () => Navigator.pushNamed(context, '/cart_page'),
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_bag_outlined, size: 26),
                if (shop.getTotalItemCount() > 0)
                  Positioned(
                    top: -8,
                    right: -9,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFF2A9D8F),
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 19,
                        minHeight: 19,
                      ),
                      child: Text(
                        shop.getTotalItemCount() > 99
                            ? '99+'
                            : shop.getTotalItemCount().toString(),
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 620;
          final horizontalPadding = compact ? 18.0 : 32.0;
          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1220),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    12,
                    horizontalPadding,
                    48,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHero(context, compact),
                      const SizedBox(height: 36),
                      Text(
                        'Explore the collection',
                        style: TextStyle(
                          color: foreground,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.8,
                          fontSize: compact ? 24 : 30,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Find your next favorite piece of tech.',
                        style: TextStyle(color: muted, fontSize: 14),
                      ),
                      const SizedBox(height: 23),
                      TextField(
                        controller: _searchController,
                        onChanged: (value) =>
                            setState(() => _searchQuery = value),
                        style: TextStyle(color: foreground),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: fieldColor,
                          hintText: 'Search devices and accessories',
                          hintStyle: TextStyle(color: muted),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: muted,
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  tooltip: 'Clear search',
                                  icon: const Icon(Icons.close_rounded),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                )
                              : null,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 17,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: stroke),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFF2A9D8F),
                              width: 1.6,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Wrap(
                        spacing: 9,
                        runSpacing: 8,
                        children: _categories.entries.map((entry) {
                          final selected = _category == entry.key;
                          return ChoiceChip(
                            label: Text(entry.value),
                            selected: selected,
                            onSelected: (_) =>
                                setState(() => _category = entry.key),
                            backgroundColor: fieldColor,
                            selectedColor: const Color(0xFF213344),
                            side: BorderSide(
                              color: selected
                                  ? const Color(0xFF213344)
                                  : stroke,
                            ),
                            labelStyle: TextStyle(
                              color: selected ? Colors.white : foreground,
                              fontSize: 13,
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                            showCheckmark: false,
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 26),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _category == 'all'
                                  ? 'All products'
                                  : _categories[_category]!,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: foreground,
                              ),
                            ),
                          ),
                          Text(
                            products.length.toString() +
                                (products.length == 1 ? ' item' : ' items'),
                            style: TextStyle(color: muted, fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      if (products.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 52,
                          ),
                          decoration: BoxDecoration(
                            color: fieldColor,
                            border: Border.all(color: stroke),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 40,
                                color: muted,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No matching products',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: foreground,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Try another search or category.',
                                style: TextStyle(color: muted),
                              ),
                            ],
                          ),
                        )
                      else
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: products.length,
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: compact ? 390 : 275,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: compact ? 0.82 : 0.73,
                          ),
                          itemBuilder: (context, index) =>
                              MyProductTile(product: products[index]),
                        ),
                      const SizedBox(height: 32),
                      Divider(color: stroke),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          'Built with Flutter · Portfolio demo',
                          style: TextStyle(color: muted, fontSize: 12),
                        ),
                      ),
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

  Widget _buildHero(BuildContext context, bool compact) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: compact ? 240 : 270),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(compact ? 22 : 28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF182735),
            Color(0xFF0D1723),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: compact ? -62 : 34,
            top: compact ? 22 : 20,
            child: Icon(
              Icons.devices_rounded,
              size: compact ? 190 : 242,
              color: Colors.white.withValues(alpha: 0.065),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(compact ? 25 : 46),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'THE TECH EDIT  /  2026',
                  style: TextStyle(
                    color: Color(0xFF8EDCCF),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 17),
                Text(
                  compact
                      ? 'Good tech.\nSimple shopping.'
                      : 'Good tech. Simple shopping.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: compact ? 31 : 39,
                    fontWeight: FontWeight.w800,
                    height: 1.12,
                    letterSpacing: -1.4,
                  ),
                ),
                const SizedBox(height: 14),
                const ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 420),
                  child: Text(
                    'Discover phones, accessories and everyday essentials — all in one place.',
                    style: TextStyle(
                      color: Color(0xFFC2CBD5),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
