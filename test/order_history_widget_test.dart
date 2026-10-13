import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/auth/models/shop.dart';
import 'package:shop_app/auth/pages/orders_page.dart';

void main() {
  for (final width in <double>[280, 320, 360, 440, 760]) {
    testWidgets(
      'order card fits ' + width.toInt().toString() + 'px and formats total',
      (tester) async {
        tester.view.physicalSize = Size(width, 720);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final shop = Shop();
        final item = shop.shop.first;
        shop.addToCart(item.id, item);
        final order = shop.placeDemoOrder(
          customerName: 'Tester',
          deliveryAddress: '123 Example Road',
          paymentMethod: 'Demo card',
        );

        await tester.pumpWidget(
          ChangeNotifierProvider.value(
            value: shop,
            child: const MaterialApp(home: OrdersPage()),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Order confirmed'), findsOneWidget);
        expect(
          find.text(r'$' + order.total.toStringAsFixed(2)),
          findsOneWidget,
        );
        expect(find.textContaining('toStringAsFixed'), findsNothing);
        expect(find.text('View receipt'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
