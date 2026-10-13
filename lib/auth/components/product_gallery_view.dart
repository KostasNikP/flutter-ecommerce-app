import 'package:flutter/material.dart';
import 'package:shop_app/auth/components/product_artwork.dart';
import 'package:shop_app/auth/models/product.dart';
import 'package:shop_app/auth/themes/app_palette.dart';

/// Swipeable product gallery with thumbnails, counter and image zoom.
class ProductGalleryView extends StatefulWidget {
  final Product product;
  final bool wide;

  const ProductGalleryView({
    super.key,
    required this.product,
    this.wide = false,
  });

  @override
  State<ProductGalleryView> createState() => _ProductGalleryViewState();
}

class _ProductGalleryViewState extends State<ProductGalleryView> {
  final PageController _controller = PageController();
  int _index = 0;

  List<String> get _sources => ProductArtwork.sourcesFor(widget.product);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goTo(int index) {
    if (index < 0 || index >= _sources.length) return;
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  void _openFullscreen() {
    final source = _sources[_index];
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(12),
        backgroundColor: AppPalette.panel(context),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860, maxHeight: 720),
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.96,
            height: MediaQuery.sizeOf(context).height * 0.75,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 8, 8, 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(widget.product.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700)),
                      ),
                      IconButton(
                        tooltip: 'Close image',
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: InteractiveViewer(
                    minScale: 0.8,
                    maxScale: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: ProductArtwork(
                        product: widget.product,
                        source: source,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text('Pinch to zoom or drag the image',
                      style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sources = _sources;
    if (sources.isEmpty) {
      return SizedBox(
        height: widget.wide ? 440 : 290,
        child: ProductArtwork(product: widget.product),
      );
    }

    final dark = AppPalette.isDark(context);
    final border = dark ? const Color(0xFF32384D) : const Color(0xFFE2E5EE);
    return Column(
      children: [
        Container(
          height: widget.wide ? 430 : 310,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppPalette.panel(context),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Stack(
            children: [
              PageView.builder(
                controller: _controller,
                itemCount: sources.length,
                onPageChanged: (index) => setState(() => _index = index),
                itemBuilder: (context, index) => InkWell(
                  onTap: _openFullscreen,
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: ProductArtwork(
                      product: widget.product,
                      source: sources[index],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 14,
                top: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(
                    color: dark ? const Color(0xFF293047) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text('${_index + 1} / ${sources.length}',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w700)),
                ),
              ),
              if (sources[_index].endsWith('#detail'))
                Positioned(
                  bottom: 15,
                  left: 15,
                  child: Text(
                    'DETAIL CROP',
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                      color: AppPalette.subdued(context),
                    ),
                  ),
                ),
              Positioned(
                top: 10,
                right: 12,
                child: IconButton.filledTonal(
                  tooltip: 'View larger image',
                  onPressed: _openFullscreen,
                  icon: const Icon(Icons.zoom_out_map_rounded, size: 20),
                ),
              ),
              if (widget.wide && sources.length > 1) ...[
                Positioned(
                  left: 10, bottom: 16,
                  child: IconButton.filledTonal(
                    tooltip: 'Previous photo',
                    onPressed: _index == 0 ? null : () => _goTo(_index - 1),
                    icon: const Icon(Icons.chevron_left_rounded),
                  ),
                ),
                Positioned(
                  right: 10, bottom: 16,
                  child: IconButton.filledTonal(
                    tooltip: 'Next photo',
                    onPressed: _index == sources.length - 1
                        ? null : () => _goTo(_index + 1),
                    icon: const Icon(Icons.chevron_right_rounded),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 13),
        SizedBox(
          height: 73,
          child: Center(
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: sources.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) => Material(
                color: AppPalette.panel(context),
                borderRadius: BorderRadius.circular(13),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => _goTo(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 73,
                    height: 73,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _index == index ? AppPalette.accent : border,
                        width: _index == index ? 2.2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: ProductArtwork(
                      product: widget.product,
                      source: sources[index],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 7),
        Text('Swipe photos · Tap to enlarge',
            style: TextStyle(
                fontSize: 12, color: AppPalette.subdued(context))),
      ],
    );
  }
}
