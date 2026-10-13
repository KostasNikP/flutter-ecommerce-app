import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/auth/models/shop.dart';
import 'package:shop_app/auth/models/user_provider.dart';
import 'package:shop_app/auth/pages/Delivery_Progress_Page.dart';
import 'package:shop_app/auth/themes/app_palette.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _address = TextEditingController();
  final _coupon = TextEditingController();
  String _paymentMethod = 'Demo card';
  bool _placingOrder = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_name.text.isEmpty) {
      _name.text = context.read<UserProvider>().username;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    _coupon.dispose();
    super.dispose();
  }

  void _placeOrder() {
    if (_placingOrder || !_formKey.currentState!.validate()) return;
    final shop = context.read<Shop>();
    if (shop.cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your bag is empty.')),
      );
      return;
    }
    setState(() => _placingOrder = true);
    final order = shop.placeDemoOrder(
      customerName: _name.text,
      deliveryAddress: _address.text,
      paymentMethod: _paymentMethod,
      promoCode: _coupon.text,
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => DeliveryProgressPage(order: order),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<Shop>();
    final ink = AppPalette.foreground(context);
    final muted = AppPalette.subdued(context);
    final subtotal = shop.getTotalPrice();
    final validCoupon = _coupon.text.trim().toUpperCase() == 'WELCOME10';
    final discount = validCoupon ? subtotal * 0.10 : 0.0;
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Almost yours.',
                      style: TextStyle(
                        color: ink,
                        fontSize: 31,
                        fontWeight: FontWeight.w800,
                      )),
                  const SizedBox(height: 6),
                  Text('Secure-feeling checkout, simulated for this demo.',
                      style: TextStyle(color: muted)),
                  const SizedBox(height: 25),
                  Container(
                    decoration: BoxDecoration(
                      color: AppPalette.panel(context),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Delivery details',
                            style: TextStyle(
                                color: ink,
                                fontSize: 19,
                                fontWeight: FontWeight.w800)),
                        const SizedBox(height: 18),
                        TextFormField(
                          controller: _name,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                              labelText: 'Full name',
                              prefixIcon: Icon(Icons.person_outline_rounded)),
                          validator: (v) => v == null || v.trim().length < 2
                              ? 'Enter your name'
                              : null,
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _address,
                          maxLines: 2,
                          decoration: const InputDecoration(
                              labelText: 'Demo delivery address',
                              prefixIcon: Icon(Icons.location_on_outlined)),
                          validator: (v) => v == null || v.trim().length < 6
                              ? 'Enter an address (at least 6 characters)'
                              : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    decoration: BoxDecoration(
                      color: AppPalette.panel(context),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Payment method',
                            style: TextStyle(
                                color: ink,
                                fontSize: 19,
                                fontWeight: FontWeight.w800)),
                        const SizedBox(height: 8),
                        Text('No card numbers are collected or charged.',
                            style: TextStyle(color: muted, fontSize: 12)),
                        const SizedBox(height: 15),
                        Wrap(
                          spacing: 10,
                          runSpacing: 8,
                          children: [
                            _methodChip('Demo card',
                                Icons.credit_card_outlined),
                            _methodChip('On delivery',
                                Icons.local_shipping_outlined),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    decoration: BoxDecoration(
                      color: AppPalette.panel(context),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Order summary',
                            style: TextStyle(
                                color: ink,
                                fontSize: 19,
                                fontWeight: FontWeight.w800)),
                        const SizedBox(height: 14),
                        TextField(
                          controller: _coupon,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                              hintText: 'Promo code (try WELCOME10)',
                              prefixIcon: Icon(Icons.sell_outlined)),
                        ),
                        if (validCoupon)
                          const Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text('10% demo discount applied!',
                                style: TextStyle(
                                    color: AppPalette.accent,
                                    fontWeight: FontWeight.w700)),
                          ),
                        const SizedBox(height: 18),
                        _summaryRow('Subtotal', subtotal, muted),
                        if (discount > 0) ...[
                          const SizedBox(height: 8),
                          _summaryRow('Discount', -discount, muted),
                        ],
                        const Divider(height: 30),
                        _summaryRow('Total', subtotal - discount, ink,
                            bold: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: shop.cart.isEmpty || _placingOrder
                          ? null
                          : _placeOrder,
                      icon: const Icon(Icons.check_circle_outline_rounded),
                      label: const Text('Place demo order'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'Portfolio demo only · No real payment or shipping',
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

  Widget _methodChip(String title, IconData icon) {
    final selected = _paymentMethod == title;
    return ChoiceChip(
      label: Text(title),
      avatar: Icon(icon, size: 18),
      selected: selected,
      onSelected: (_) => setState(() => _paymentMethod = title),
    );
  }

  Widget _summaryRow(String label, double amount, Color color,
      {bool bold = false}) {
    return Row(
      children: [
        Text(label, style: TextStyle(color: color)),
        const Spacer(),
        Text(
          '${amount < 0 ? '-' : ''}\$${amount.abs().toStringAsFixed(2)}',
          style: TextStyle(
              color: color,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
              fontSize: bold ? 22 : 15),
        ),
      ],
    );
  }
}
