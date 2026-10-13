import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/auth/components/receipt_card.dart';
import 'package:shop_app/auth/models/shop.dart';
import 'package:shop_app/auth/pages/cart_page.dart';
import 'package:shop_app/auth/components/product_gallery_view.dart';

void main() {
  Future<void> usePhoneSize(WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('empty bag is readable and actionable on a phone',
      (tester) async {
    await usePhoneSize(tester);
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => Shop(),
        child: const MaterialApp(home: CartPage()),
      ),
    );
    await tester.pump();
    expect(find.text('Your bag is empty'), findsOneWidget);
    expect(find.text('Continue shopping'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('itemized receipt fits a narrow mobile viewport',
      (tester) async {
    await usePhoneSize(tester);
    final shop = Shop();
    final product = shop.shop.first;
    shop.addToCart(product.id, product);
    final order = shop.placeDemoOrder(
      customerName: 'Demo Customer',
      deliveryAddress: '123 Example Street',
      paymentMethod: 'Demo card',
      promoCode: 'WELCOME10',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: ReceiptCard(order: order),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Order receipt'), findsOneWidget);
    expect(find.text('Copy receipt'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('gallery shows thumbnails and supports swiping on phone',
      (tester) async {
    await usePhoneSize(tester);
    final product = Shop().shop.first;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView(
            children: [
              ProductGalleryView(product: product),
            ],
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('1 / 2'), findsOneWidget);
    expect(find.byType(PageView), findsOneWidget);
    await tester.drag(find.byType(PageView), const Offset(-300, 0));
    await tester.pumpAndSettle();
    expect(find.text('2 / 2'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

}
