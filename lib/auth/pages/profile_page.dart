import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/auth/models/shop.dart';
import 'package:shop_app/auth/models/user_provider.dart';
import 'package:shop_app/auth/themes/app_palette.dart';
import 'package:shop_app/auth/themes/theme_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _editName(BuildContext context, String current) async {
    final controller = TextEditingController(text: current == 'Guest' ? '' : current);
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit your display name'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 35,
          decoration: const InputDecoration(labelText: 'Display name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().length >= 2) {
                Navigator.pop(dialogContext, controller.text.trim());
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    // Complete edits before disposing the controller.
    if (name != null && context.mounted) {
      context.read<UserProvider>().setUsername(name);
    }
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();
    final theme = context.watch<ThemeProvider>();
    final shop = context.watch<Shop>();
    final ink = AppPalette.foreground(context);
    final muted = AppPalette.subdued(context);
    final displayName = user.username.isEmpty ? 'Guest' : user.username;

    return Scaffold(
      appBar: AppBar(title: const Text('My profile')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppPalette.panel(context),
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 39,
                      backgroundColor: AppPalette.accent,
                      child: Icon(Icons.person_rounded,
                          size: 44, color: Colors.white),
                    ),
                    const SizedBox(height: 15),
                    Text(displayName,
                        style: TextStyle(
                          color: ink,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        )),
                    const SizedBox(height: 5),
                    Text(user.email.isEmpty
                            ? 'Local demo session'
                            : user.email,
                        style: TextStyle(color: muted)),
                    const SizedBox(height: 13),
                    OutlinedButton.icon(
                      onPressed: () => _editName(context, displayName),
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Edit name'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text('MY SPACE',
                  style: TextStyle(
                    color: muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                  )),
              const SizedBox(height: 10),
              Card(
                elevation: 0,
                color: AppPalette.panel(context),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.favorite_border_rounded),
                      title: const Text('Saved favorites'),
                      trailing: Text('${shop.favorites.length}  ›'),
                      onTap: () =>
                          Navigator.pushNamed(context, '/favorites_page'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.receipt_long_outlined),
                      title: const Text('Demo order history'),
                      trailing: Text('${shop.orders.length}  ›'),
                      onTap: () =>
                          Navigator.pushNamed(context, '/orders_page'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Text('PREFERENCES',
                  style: TextStyle(
                    color: muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                  )),
              const SizedBox(height: 10),
              Card(
                color: AppPalette.panel(context),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: SwitchListTile(
                  secondary: Icon(theme.isDarkMode
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_outlined),
                  title: const Text('Dark mode'),
                  subtitle: const Text('Each new session starts in dark mode'),
                  value: theme.isDarkMode,
                  onChanged: (_) => context.read<ThemeProvider>().toggleTheme(),
                ),
              ),
              const SizedBox(height: 25),
              Center(
                child: Text(
                  'Demo store · Favorites, bag and orders stay saved. The theme starts dark each session.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: muted, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
