import 'package:flutter/material.dart';
import 'package:shop_app/auth/themes/app_palette.dart';

class AuthLayout extends StatelessWidget {
  final Widget form;
  final String eyebrow;
  final String heading;
  final String description;

  const AuthLayout({
    super.key,
    required this.form,
    required this.eyebrow,
    required this.heading,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, viewport) {
            final wide = viewport.maxWidth >= 860;
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
                      horizontal: wide ? 36 : 18,
                      vertical: wide ? 32 : 20,
                    ),
                    child: wide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(child: _intro(wide: true)),
                              const SizedBox(width: 32),
                              SizedBox(width: 430, child: form),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _intro(wide: false),
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

  Widget _intro({required bool wide}) {
    return Container(
      constraints: BoxConstraints(minHeight: wide ? 580 : 200),
      padding: EdgeInsets.all(wide ? 40 : 25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(wide ? 30 : 24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF30246D),
            Color(0xFF19182F),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: wide
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.start,
        children: [
          const Text(
            'TECH STORE',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              letterSpacing: 1.4,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (wide) const SizedBox(height: 110),
          if (!wide) const SizedBox(height: 28),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eyebrow.toUpperCase(),
                style: const TextStyle(
                  color: AppPalette.mint,
                  letterSpacing: 1.5,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                heading,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: wide ? 42 : 28,
                  height: 1.14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.9,
                ),
              ),
              const SizedBox(height: 12),
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
          if (wide) const SizedBox(height: 110),
        ],
      ),
    );
  }
}
