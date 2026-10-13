import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/auth/models/user_provider.dart';
import 'package:shop_app/auth/themes/app_palette.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  Widget _link(BuildContext context, IconData icon, String title,
      String route) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onTap: () {
        Navigator.pop(context);
        if (route != '/shop_page') {
          Navigator.pushNamed(context, route);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = AppPalette.foreground(context);
    return Drawer(
      backgroundColor: AppPalette.panel(context),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 18, 14, 24),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 25,
                      backgroundColor: AppPalette.accent,
                      child: Icon(Icons.bolt_rounded,
                          color: Colors.white, size: 30),
                    ),
                    const SizedBox(width: 13),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('NOVA.',
                            style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.w900,
                                fontSize: 22)),
                        Text('Your tech store',
                            style: TextStyle(
                                color: AppPalette.subdued(context),
                                fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              _link(context, Icons.storefront_rounded, 'Discover',
                  '/shop_page'),
              _link(context, Icons.favorite_border_rounded, 'Wishlist',
                  '/favorites_page'),
              _link(context, Icons.shopping_bag_outlined, 'Shopping bag',
                  '/cart_page'),
              _link(context, Icons.receipt_long_outlined, 'My orders',
                  '/orders_page'),
              _link(context, Icons.person_outline_rounded, 'Profile',
                  '/profile_page'),
              const Spacer(),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout_rounded),
                title: const Text('Sign out'),
                onTap: () {
                  context.read<UserProvider>().resetUser();
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login_page', (_) => false);
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
