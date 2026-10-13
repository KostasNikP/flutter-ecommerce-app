import 'package:flutter/material.dart';
import 'package:shop_app/auth/themes/app_palette.dart';

/// Reusable responsive entry layout for sign-in and demo-profile creation.
/// A compact header on phones becomes an editorial side panel on desktop.
class AuthLayout extends StatelessWidget {
  final Widget form;
  final String eyebrow;
  final String heading;
  final String description;
  final IconData icon;

  const AuthLayout({
    super.key,
    required this.form,
    required this.eyebrow,
    required this.heading,
    required this.description,
    this.icon = Icons.auto_awesome_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, viewport) {
            final wide = viewport.maxWidth >= 860;
            final padding = wide ? 36.0 : 18.0;
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 1120,
                    minHeight: viewport.maxHeight,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: padding,
                      vertical: wide ? 32 : 20,
                    ),
                    child: wide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(child: _intro(context, wide: true)),
                              const SizedBox(width: 32),
                              SizedBox(width: 430, child: form),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _intro(context, wide: false),
                              const SizedBox(height: 20),
                              form,
                            ],
                          ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _intro(BuildContext context, {required bool wide}) {
    return Container(
      constraints: BoxConstraints(minHeight: wide ? 580 : 205),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(wide ? 32 : 24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF34277A),
            Color(0xFF19182F),
            Color(0xFF111625),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: wide ? -95 : -125,
            right: wide ? -115 : -40,
            child: Container(
              width: wide ? 365 : 280,
              height: wide ? 365 : 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.10),
                  width: 1.5,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: wide ? 10 : -90,
            right: wide ? -45 : -50,
            child: Icon(
              Icons.devices_rounded,
              size: wide ? 280 : 180,
              color: Colors.white.withValues(alpha: 0.055),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(wide ? 38 : 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: wide
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 19,
                      backgroundColor: AppPalette.mint,
                      child: Icon(Icons.bolt_rounded,
                          color: AppPalette.ink, size: 23),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'TECH STORE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    if (wide)
                      const Icon(Icons.north_east_rounded,
                          color: AppPalette.mint),
                  ],
                ),
                SizedBox(height: wide ? 90 : 25),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eyebrow.toUpperCase(),
                      style: const TextStyle(
                        color: AppPalette.mint,
                        letterSpacing: 2.1,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      heading,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: wide ? 43 : 28,
                        height: 1.1,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1.2,
                      ),
                    ),
                    const SizedBox(height: 11),
                    Text(
                      description,
                      style: TextStyle(
                        color: const Color(0xFFD2D0E7),
                        fontSize: wide ? 15 : 13,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
                if (wide) ...[
                  const SizedBox(height: 90),
                  Row(
                    children: [
                      Icon(icon, color: AppPalette.mint, size: 22),
                      const SizedBox(width: 9),
                      const Expanded(
                        child: Text(
                          'A Flutter shopping experience, made for exploring.',
                          style: TextStyle(
                            color: Color(0xFFD6D1E9),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
