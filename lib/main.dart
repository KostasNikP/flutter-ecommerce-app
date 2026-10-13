import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/auth/login_or_regidter.dart';
import 'package:shop_app/auth/models/shop.dart';
import 'package:shop_app/auth/models/user_provider.dart';
import 'package:shop_app/auth/pages/Registration_Page.dart';
import 'package:shop_app/auth/pages/cart_page.dart';
import 'package:shop_app/auth/pages/favorites_page.dart';
import 'package:shop_app/auth/pages/login_page.dart';
import 'package:shop_app/auth/pages/orders_page.dart';
import 'package:shop_app/auth/pages/profile_page.dart';
import 'package:shop_app/auth/pages/shop_page.dart';
import 'package:shop_app/auth/themes/theme_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Shop()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NOVA · Tech Store Demo',
      debugShowCheckedModeBanner: false,
      theme: context.watch<ThemeProvider>().themeData,
      initialRoute: '/',
      routes: {
        '/': (_) => const LoginOrRegiState(),
        '/login_page': (_) => LoginPage(onTap: () {}),
        '/registration_page': (_) => RegistrationPage(onTap: () {}),
        '/shop_page': (_) => const ShopPage(),
        '/cart_page': (_) => const CartPage(),
        '/favorites_page': (_) => const FavoritesPage(),
        '/orders_page': (_) => const OrdersPage(),
        '/profile_page': (_) => const ProfilePage(),
      },
    );
  }
}
