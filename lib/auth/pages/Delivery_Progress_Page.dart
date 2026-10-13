import 'package:shop_app/auth/components/my_receipt.dart';
import 'package:flutter/material.dart';

class DeliveryProgressPage extends StatelessWidget {
  final String cardHolderName;

  const DeliveryProgressPage({super.key, required this.cardHolderName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Progress'),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false, 
      ),
      body: Column(
        children: [
          const MyReceipt(),
          ElevatedButton(
            onPressed: () {
              
              Navigator.of(context).pushNamedAndRemoveUntil('/shop_page', (route) => false);
            },
            child: const Text('Επιστροφή στο Κατάστημα'),
          ),
        ],
      ),
    );
  }
}
