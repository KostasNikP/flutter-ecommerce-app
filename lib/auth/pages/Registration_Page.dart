import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/auth/components/auth_layout.dart';
import 'package:shop_app/auth/models/user_provider.dart';
import 'package:shop_app/auth/themes/app_palette.dart';

class RegistrationPage extends StatefulWidget {
  final VoidCallback onTap;
  const RegistrationPage({super.key, required this.onTap});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _createProfile() {
    if (!_formKey.currentState!.validate()) return;
    final user = context.read<UserProvider>();
    user.setUsername(_nameController.text.trim());
    user.setEmail(_emailController.text.trim());
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/shop_page',
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ink = AppPalette.foreground(context);
    final muted = AppPalette.subdued(context);
    return AuthLayout(
      eyebrow: 'Your space',
      heading: 'Make it yours.',
      description:
          'Personalize your experience with a simple local demo profile.',
      form: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        decoration: BoxDecoration(
          color: AppPalette.panel(context),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: AppPalette.isDark(context)
                ? const Color(0xFF303448)
                : const Color(0xFFE7E8F0),
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create demo profile',
                style: TextStyle(
                  color: ink,
                  fontSize: 26,
                  letterSpacing: -0.7,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Just a name and an email to customize the experience.',
                style: TextStyle(color: muted, height: 1.5, fontSize: 13),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Display name',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
                validator: (value) =>
                    value == null || value.trim().length < 2
                        ? 'Enter at least two characters'
                        : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Email address',
                  prefixIcon: Icon(Icons.alternate_email_rounded),
                ),
                validator: (value) {
                  final email = value?.trim() ?? '';
                  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                      .hasMatch(email)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
                onFieldSubmitted: (_) => _createProfile(),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _createProfile,
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Create demo profile'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () => Navigator.canPop(context)
                      ? Navigator.pop(context)
                      : Navigator.pushReplacementNamed(context, '/login_page'),
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Back to entry options'),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Local demo only — no password, verification or real account is created.',
                textAlign: TextAlign.center,
                style: TextStyle(color: muted, fontSize: 11, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
