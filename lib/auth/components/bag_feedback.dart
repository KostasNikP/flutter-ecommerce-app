import 'package:flutter/material.dart';
import 'package:shop_app/auth/themes/app_palette.dart';

/// Small toast above phone navigation instead of a full-width snackbar.
class BagFeedback {
  const BagFeedback._();
  static OverlayEntry? _current;

  static void show(BuildContext context, {int quantity = 1}) {
    _current?.remove();
    _current?.dispose();
    final overlay = Overlay.of(context, rootOverlay: true);
    late final OverlayEntry entry;
    entry = OverlayEntry(builder: (context) {
      final compact = MediaQuery.sizeOf(context).width < 620;
      return Positioned(
        bottom: MediaQuery.paddingOf(context).bottom + (compact ? 92 : 24),
        left: 14, right: 14,
        child: IgnorePointer(
          child: Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.9, end: 1),
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              builder: (_, value, child) =>
                  Transform.scale(scale: value, child: child),
              child: Material(
                elevation: 7,
                color: AppPalette.ink,
                borderRadius: BorderRadius.circular(30),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle_rounded,
                          color: AppPalette.mint, size: 20),
                      const SizedBox(width: 9),
                      Text(quantity == 1 ? 'Added to bag'
                              : '${quantity} items added',
                          style: const TextStyle(color: Colors.white,
                              fontSize: 13, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
    _current = entry;
    overlay.insert(entry);
    Future<void>.delayed(const Duration(milliseconds: 1400), () {
      if (!identical(_current, entry)) return;
      entry.remove();
      entry.dispose();
      _current = null;
    });
  }
}
