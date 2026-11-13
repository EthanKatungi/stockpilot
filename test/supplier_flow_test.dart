import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockpilot/core/theme/app_theme.dart';
import 'package:stockpilot/features/suppliers/supplier_form_screen.dart';
import 'package:stockpilot/features/suppliers/supplier_profile_screen.dart';
import 'package:stockpilot/features/suppliers/suppliers_screen.dart';
import 'package:stockpilot/main.dart';

void _phoneSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetViewInsets);
}

Future<void> _openDirectory(WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  await tester.tap(find.text('More'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Suppliers'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('More opens suppliers and distinct profiles', (tester) async {
    _phoneSize(tester);
    await _openDirectory(tester);
    expect(find.byType(SuppliersScreen), findsOneWidget);
    expect(find.text('5 suppliers'), findsOneWidget);

    await tester.tap(find.text('Nile Agricultural Co.'));
    await tester.pumpAndSettle();
    expect(find.byType(SupplierProfileScreen), findsOneWidget);
    expect(find.text('Supplier ID SUP-008'), findsOneWidget);
    expect(find.text('Sarah Mukasa'), findsOneWidget);
    expect(find.text('12'), findsOneWidget);

    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    expect(find.byType(EditSupplierScreen), findsOneWidget);
    expect(
      tester
          .widget<TextFormField>(find.byType(TextFormField).first)
          .controller!
          .text,
      'Nile Agricultural Co.',
    );
    await tester.enterText(
      find.byType(TextFormField).first,
      'Draft supplier name',
    );
    await tester.tap(find.text('Update Supplier'));
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.textContaining('No changes were saved.'), findsOneWidget);
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Nile Agricultural Co.'), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Elgon Coffee Traders'));
    await tester.pumpAndSettle();
    expect(find.text('Supplier ID SUP-009'), findsOneWidget);
    expect(find.text('Daniel Kato'), findsOneWidget);
    expect(find.text('8'), findsOneWidget);

    await tester.ensureVisible(find.text('Create Purchase Order'));
    await tester.tap(find.text('Create Purchase Order'));
    await tester.pump(const Duration(seconds: 1));
    expect(find.textContaining('Phase 4C'), findsOneWidget);
  });

  testWidgets('directory search, status filters and empty state work', (
    tester,
  ) async {
    _phoneSize(tester);
    await _openDirectory(tester);
    await tester.enterText(find.byType(TextField).first, 'Elgon');
    await tester.pumpAndSettle();
    expect(find.text('Elgon Coffee Traders'), findsOneWidget);
    expect(find.text('Nile Agricultural Co.'), findsNothing);

    await tester.tap(find.text('Inactive'));
    await tester.pumpAndSettle();
    expect(find.text('No matching suppliers'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, '');
    await tester.pumpAndSettle();
    expect(find.text('Lake Victoria Supplies'), findsOneWidget);
    expect(find.text('Elgon Coffee Traders'), findsNothing);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Suppliers'), findsOneWidget);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(body: SuppliersScreen(suppliers: [])),
      ),
    );
    expect(find.text('No suppliers yet'), findsOneWidget);
  });

  testWidgets('add supplier validates input and does not save', (tester) async {
    _phoneSize(tester);
    await _openDirectory(tester);
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
    expect(find.byType(AddSupplierScreen), findsOneWidget);

    await tester.tap(find.text('Save Supplier'));
    await tester.pumpAndSettle();
    expect(find.text('This field is required'), findsWidgets);

    await tester.enterText(find.byType(TextFormField).at(0), 'Demo Trading');
    await tester.enterText(find.byType(TextFormField).at(1), 'Maya Demo');
    await tester.enterText(find.byType(TextFormField).at(2), '123');
    await tester.enterText(find.byType(TextFormField).at(3), 'invalid-email');
    await tester.enterText(find.byType(TextFormField).at(4), 'Kampala, Uganda');
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Coffee').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save Supplier'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a valid phone number'), findsOneWidget);
    expect(find.text('Enter a valid email address'), findsOneWidget);

    await tester.enterText(
      find.byType(TextFormField).at(2),
      '+256 700 000 555',
    );
    await tester.enterText(
      find.byType(TextFormField).at(3),
      'maya@example.com',
    );

    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byType(TextFormField).last);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Save Supplier'));
    await tester.pump();
    expect(find.textContaining('No supplier was saved.'), findsOneWidget);
    tester.view.resetViewInsets();
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('5 suppliers'), findsOneWidget);
  });
}
