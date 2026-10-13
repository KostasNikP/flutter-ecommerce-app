import 'package:flutter/material.dart';
import 'package:shop_app/auth/pages/Registration_Page.dart';
import 'package:shop_app/auth/pages/login_page.dart';

class LoginOrRegiState extends StatefulWidget {
  const LoginOrRegiState({super.key});

  @override
  State<LoginOrRegiState> createState() => _LoginOrRegiStateState();
}

class _LoginOrRegiStateState extends State<LoginOrRegiState> {
  bool showLoginPage = true;

  void togglePages() {
    setState(() => showLoginPage = !showLoginPage);
  }

  @override
  Widget build(BuildContext context) => showLoginPage
      ? LoginPage(onTap: togglePages)
      : RegistrationPage(onTap: togglePages);
}
