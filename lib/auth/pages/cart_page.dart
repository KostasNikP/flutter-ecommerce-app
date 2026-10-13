import 'package:shop_app/auth/components/my_Button.dart';
import 'package:shop_app/auth/components/my_cart_tile.dart';
import 'package:shop_app/auth/models/shop.dart';
import 'package:shop_app/auth/pages/payment_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Shop>(
      builder: (context, shop, child) {
        final userCart = shop.cart;
        final totalPrice = shop.getTotalPrice();

        return Scaffold(
          appBar: AppBar(
            leading: Container(
              margin: const EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Theme.of(context).colorScheme.surface,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            title: const Text('Cart'),
            backgroundColor: const Color.fromARGB(0, 255, 0, 0),
            foregroundColor: Theme.of(context).colorScheme.inversePrimary,
            actions: [
              IconButton(
                onPressed: userCart.isEmpty ? null : () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      title: Text(
                        "Are you sure",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "cancel",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            shop.clearCart();
                          },
                          child: Text(
                            "Yes",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    userCart.isEmpty
                        ? Expanded(
                            child: Center(
                              child: Text(
                                "Cart is empty...",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: userCart.length,
                              itemBuilder: (context, index) {
                                final cartItem = userCart[index];
                                return MyCartTile(product: cartItem);
                              },
                            ),
                          ),
                  ],
                ),
              ),

              Text(
                'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),

              MyButton(
                onTap: userCart.isEmpty ? null : () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PaymentPage(),
                  ),
                ),
                text: "Go to checkout",
                style: const TextStyle(fontSize: 22),
              ),

              const SizedBox(height: 25),
            ],
          ),
        );
      },
    );
  }
}