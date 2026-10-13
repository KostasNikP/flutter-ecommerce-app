import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/auth/models/user_provider.dart';
import 'package:shop_app/auth/themes/app_palette.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _enterShop({bool guest = false}) {
    if (!guest && !_formKey.currentState!.validate()) return;
    final user = context.read<UserProvider>();
    user.setUsername(guest ? 'Guest' : _name.text.trim());
    user.setEmail('');
    Navigator.pushNamedAndRemoveUntil(
        context, '/shop_page', (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final ink = AppPalette.foreground(context);
    final muted = AppPalette.subdued(context);
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 470),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 42),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 31,
                    backgroundColor: AppPalette.accent,
                    child: Icon(Icons.bolt_rounded,
                        size: 36, color: Colors.white),
                  ),
                  const SizedBox(height: 36),
                  Text('Welcome to NOVA.',
                      style: TextStyle(
                        color: ink,
                        fontWeight: FontWeight.w900,
                        fontSize: 37,
                        letterSpacing: -1.4,
                      )),
                  const SizedBox(height: 10),
                  Text(
                    'Your favorite tech, all in one place. Explore the interactive store demo.',
                    style: TextStyle(color: muted, height: 1.6),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    decoration: BoxDecoration(
                      color: AppPalette.panel(context),
                      borderRadius: BorderRadius.circular(23),
                    ),
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Start exploring',
                            style: TextStyle(
                                color: ink,
                                fontSize: 19,
                                fontWeight: FontWeight.w800)),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _name,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            labelText: 'Your name',
                            prefixIcon: Icon(Icons.person_outline_rounded),
                          ),
                          validator: (value) =>
                              value == null || value.trim().length < 2
                                  ? 'Enter at least two characters'
                                  : null,
                          onFieldSubmitted: (_) => _enterShop(),
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: _enterShop,
                            child: const Text('Enter demo store'),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () => _enterShop(guest: true),
                            child: const Text('Continue as guest'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pushNamed(
                          context, '/registration_page'),
                      child: const Text('Create a demo profile instead'),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: Text(
                      'Portfolio demonstration · No real authentication',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: muted, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
