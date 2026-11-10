import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockpilot/features/products/add_product_screen.dart';
import 'package:stockpilot/features/products/product_detail_screen.dart';
import 'package:stockpilot/features/products/products_screen.dart';
import 'package:stockpilot/main.dart';

void main() {
  testWidgets(
    'selected products open distinct details and return to the list',
    (tester) async {
      tester.view.physicalSize = const Size(393, 852);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text('Products'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Arabica Coffee'));
      await tester.pumpAndSettle();
      expect(find.byType(ProductDetailScreen), findsOneWidget);
      expect(find.text('42,000 kg'), findsOneWidget);
      expect(find.text('UGX 367,500,000'), findsOneWidget);

      await tester.tap(find.byTooltip('Back to products'));
      await tester.pumpAndSettle();
      expect(find.byType(ProductsScreen), findsOneWidget);

      await tester.tap(find.text('Robusta Coffee'));
      await tester.pumpAndSettle();
      expect(find.text('58,500 kg'), findsOneWidget);
      expect(find.text('UGX 362,700,000'), findsOneWidget);

      await tester.tap(find.byTooltip('Back to products'));
      await tester.pumpAndSettle();
      expect(find.byType(ProductsScreen), findsOneWidget);
      expect(find.text('18 inventory items'), findsOneWidget);

      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(find.text('Good morning, Ethan'), findsOneWidget);
      await tester.tap(find.text('Products'));
      await tester.pumpAndSettle();
      expect(find.text('18 inventory items'), findsOneWidget);
    },
  );

  testWidgets('add form accepts input with keyboard inset and does not save', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetViewInsets);

    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Products'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.byType(AddProductScreen), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'Test Coffee');
    await tester.enterText(find.byType(TextFormField).at(1), 'TST-001');
    await tester.tap(find.byType(DropdownButtonFormField<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Coffee').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(2), '8,750');

    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byType(TextFormField).at(3));
    await tester.enterText(find.byType(TextFormField).at(3), '1,000');
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Save product'));
    await tester.pump();
    expect(
      find.text('Product saving will be implemented in Module 2.'),
      findsOneWidget,
    );

    tester.view.resetViewInsets();
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Close add product'));
    await tester.pumpAndSettle();
    expect(find.byType(ProductsScreen), findsOneWidget);
  });
}
