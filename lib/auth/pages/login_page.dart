import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/auth/components/auth_layout.dart';
import 'package:shop_app/auth/models/user_provider.dart';
import 'package:shop_app/auth/themes/app_palette.dart';

/// Entry choices operate entirely within a local demo session.
/// None of these buttons perform real email, Google, or Apple authentication.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String _displayNameFromEmail(String email) {
    final localPart = email.split('@').first
        .replaceAll(RegExp(r'[._-]+'), ' ')
        .trim();
    if (localPart.isEmpty) return 'Shopper';
    return localPart[0].toUpperCase() + localPart.substring(1);
  }

  void _startSession({required String name, String email = ''}) {
    final user = context.read<UserProvider>();
    user.setUsername(name);
    user.setEmail(email);
    Navigator.pushNamedAndRemoveUntil(context, '/shop_page', (_) => false);
  }

  void _continueWithEmail() {
    if (!_formKey.currentState!.validate()) return;
    final email = _emailController.text.trim();
    _startSession(name: _displayNameFromEmail(email), email: email);
  }

  @override
  Widget build(BuildContext context) {
    final ink = AppPalette.foreground(context);
    final muted = AppPalette.subdued(context);

    return AuthLayout(
      eyebrow: 'Welcome',
      heading: 'Find your next favorite.',
      description:
          'Discover thoughtful tech essentials in a beautifully simple store.',
      form: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
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
              const Icon(Icons.lock_outline_rounded,
                  color: AppPalette.accent, size: 25),
              const SizedBox(height: 13),
              Text(
                'Start exploring',
                style: TextStyle(
                  color: ink,
                  fontSize: 27,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.7,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                'Choose how you want to enter the demo store.',
                style: TextStyle(
                  color: muted,
                  height: 1.4,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'YOUR EMAIL',
                style: TextStyle(
                  color: muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                key: const Key('demoEmailField'),
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.go,
                autofillHints: const [AutofillHints.email],
                decoration: const InputDecoration(
                  hintText: 'you@example.com',
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
                onFieldSubmitted: (_) => _continueWithEmail(),
              ),
              const SizedBox(height: 13),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  key: const Key('continueEmailButton'),
                  onPressed: _continueWithEmail,
                  icon: const Icon(Icons.arrow_forward_rounded, size: 20),
                  label: const Text('Continue with email'),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(child: Divider(color: muted.withValues(alpha: 0.22))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('OR EXPLORE INSTANTLY',
                        style: TextStyle(
                            color: muted,
                            fontSize: 10,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w700)),
                  ),
                  Expanded(child: Divider(color: muted.withValues(alpha: 0.22))),
                ],
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  key: const Key('demoAccountButton'),
                  onPressed: () => _startSession(
                    name: 'Demo Shopper',
                    email: 'demo@techstore.example',
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 52),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  icon: const Icon(Icons.person_rounded),
                  label: const Text('Try demo account'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  key: const Key('guestButton'),
                  onPressed: () => _startSession(name: 'Guest'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 52),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  icon: const Icon(Icons.explore_outlined),
                  label: const Text('Continue as guest'),
                ),
              ),
              const SizedBox(height: 21),
              Center(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  children: [
                    Text('Want a custom demo profile?',
                        style: TextStyle(color: muted, fontSize: 12)),
                    TextButton(
                      key: const Key('createProfileLink'),
                      onPressed: () => Navigator.pushNamed(
                          context, '/registration_page'),
                      child: const Text('Create one'),
                    ),
                  ],
                ),
              ),
              Divider(color: muted.withValues(alpha: 0.18)),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline_rounded,
                      color: muted, size: 16),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      'Portfolio demo only. Email is not verified, no real account is created, and no password is needed.',
                      style: TextStyle(
                        color: muted,
                        fontSize: 11,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
