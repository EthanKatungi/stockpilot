import '../suppliers/suppliers_mock_data.dart';
import 'purchase_order.dart';

/// Fictional, display-only orders. No approval, receipt, or inventory state changes.
class PurchaseOrdersMockData {
  static final orders = <PurchaseOrder>[
    PurchaseOrder(
      id: 'PO-2026-014',
      supplier: SuppliersMockData.suppliers[0],
      status: PurchaseOrderStatus.draft,
      createdAt: '11 Nov 2026',
      expectedAt: '18 Nov 2026',
      currency: 'UGX',
      totalValue: 'UGX 18,750,000',
      items: const [
        PurchaseOrderItem(
          productName: 'Arabica Coffee',
          quantity: '2,000 kg',
          unitPrice: 'UGX 8,750',
          lineTotal: 'UGX 17,500,000',
          shortTotal: '17.5M',
        ),
        PurchaseOrderItem(
          productName: 'Packaging Bags',
          quantity: '500 pcs',
          unitPrice: 'UGX 2,500',
          lineTotal: 'UGX 1,250,000',
          shortTotal: '1.25M',
        ),
      ],
    ),
    PurchaseOrder(
      id: 'PO-2026-013',
      supplier: SuppliersMockData.suppliers[1],
      status: PurchaseOrderStatus.approved,
      createdAt: '10 Nov 2026',
      expectedAt: '17 Nov 2026',
      currency: 'UGX',
      totalValue: 'UGX 11,600,000',
      items: const [
        PurchaseOrderItem(
          productName: 'Robusta Coffee',
          quantity: '1,500 kg',
          unitPrice: 'UGX 6,400',
          lineTotal: 'UGX 9,600,000',
          shortTotal: '9.6M',
        ),
        PurchaseOrderItem(
          productName: 'Jute Sacks',
          quantity: '500 pcs',
          unitPrice: 'UGX 4,000',
          lineTotal: 'UGX 2,000,000',
          shortTotal: '2M',
        ),
      ],
    ),
    PurchaseOrder(
      id: 'PO-2026-012',
      supplier: SuppliersMockData.suppliers[2],
      status: PurchaseOrderStatus.received,
      createdAt: '7 Nov 2026',
      expectedAt: '10 Nov 2026',
      currency: 'UGX',
      totalValue: 'UGX 3,800,000',
      items: const [
        PurchaseOrderItem(
          productName: 'Carton Boxes',
          quantity: '1,000 pcs',
          unitPrice: 'UGX 3,800',
          lineTotal: 'UGX 3,800,000',
          shortTotal: '3.8M',
        ),
      ],
    ),
    PurchaseOrder(
      id: 'PO-2026-011',
      supplier: SuppliersMockData.suppliers[3],
      status: PurchaseOrderStatus.pending,
      createdAt: '6 Nov 2026',
      expectedAt: '15 Nov 2026',
      currency: 'UGX',
      totalValue: 'UGX 9,000,000',
      items: const [
        PurchaseOrderItem(
          productName: 'Sesame Seeds',
          quantity: '2,000 kg',
          unitPrice: 'UGX 4,500',
          lineTotal: 'UGX 9,000,000',
          shortTotal: '9M',
        ),
      ],
    ),
    PurchaseOrder(
      id: 'PO-2026-010',
      supplier: SuppliersMockData.suppliers[0],
      status: PurchaseOrderStatus.approved,
      createdAt: '5 Nov 2026',
      expectedAt: '14 Nov 2026',
      currency: 'UGX',
      totalValue: 'UGX 5,200,000',
      items: const [
        PurchaseOrderItem(
          productName: 'Green Tea',
          quantity: '1,000 kg',
          unitPrice: 'UGX 5,200',
          lineTotal: 'UGX 5,200,000',
          shortTotal: '5.2M',
        ),
      ],
    ),
    PurchaseOrder(
      id: 'PO-2026-009',
      supplier: SuppliersMockData.suppliers[1],
      status: PurchaseOrderStatus.draft,
      createdAt: '4 Nov 2026',
      expectedAt: '13 Nov 2026',
      currency: 'UGX',
      totalValue: 'UGX 7,200,000',
      items: const [
        PurchaseOrderItem(
          productName: 'Ground Arabica',
          quantity: '400 kg',
          unitPrice: 'UGX 18,000',
          lineTotal: 'UGX 7,200,000',
          shortTotal: '7.2M',
        ),
      ],
    ),
    PurchaseOrder(
      id: 'PO-2026-008',
      supplier: SuppliersMockData.suppliers[2],
      status: PurchaseOrderStatus.approved,
      createdAt: '3 Nov 2026',
      expectedAt: '12 Nov 2026',
      currency: 'UGX',
      totalValue: 'UGX 1,800,000',
      items: const [
        PurchaseOrderItem(
          productName: 'Product Labels',
          quantity: '6,000 pcs',
          unitPrice: 'UGX 300',
          lineTotal: 'UGX 1,800,000',
          shortTotal: '1.8M',
        ),
      ],
    ),
    PurchaseOrder(
      id: 'PO-2026-007',
      supplier: SuppliersMockData.suppliers[3],
      status: PurchaseOrderStatus.draft,
      createdAt: '2 Nov 2026',
      expectedAt: '11 Nov 2026',
      currency: 'UGX',
      totalValue: 'UGX 4,800,000',
      items: const [
        PurchaseOrderItem(
          productName: 'Cane Sugar',
          quantity: '1,200 kg',
          unitPrice: 'UGX 4,000',
          lineTotal: 'UGX 4,800,000',
          shortTotal: '4.8M',
        ),
      ],
    ),
    PurchaseOrder(
      id: 'PO-2026-006',
      supplier: SuppliersMockData.suppliers[0],
      status: PurchaseOrderStatus.draft,
      createdAt: '1 Nov 2026',
      expectedAt: '10 Nov 2026',
      currency: 'UGX',
      totalValue: 'UGX 2,400,000',
      items: const [
        PurchaseOrderItem(
          productName: 'Milk Powder',
          quantity: '200 kg',
          unitPrice: 'UGX 12,000',
          lineTotal: 'UGX 2,400,000',
          shortTotal: '2.4M',
        ),
      ],
    ),
  ];
}
