import '../suppliers/suppliers_mock_data.dart';
import 'supplier_quotation.dart';

/// Fictional, comparable offers. No quote can create or modify an order yet.
class SupplierQuotationsMockData {
  static final quotations = <SupplierQuotation>[
    SupplierQuotation(
      supplier: SuppliersMockData.suppliers[1],
      productName: 'Arabica Coffee',
      quantity: 2000,
      unit: 'kg',
      unitPrice: 8500,
    ),
    SupplierQuotation(
      supplier: SuppliersMockData.suppliers[0],
      productName: 'Arabica Coffee',
      quantity: 2000,
      unit: 'kg',
      unitPrice: 8750,
    ),
    SupplierQuotation(
      supplier: SuppliersMockData.suppliers[3],
      productName: 'Arabica Coffee',
      quantity: 2000,
      unit: 'kg',
      unitPrice: 9100,
    ),
  ];
}
