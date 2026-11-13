import '../products/products_mock_data.dart';

enum MovementType { receipt, issue, adjustment }

class MockMovement {
  const MockMovement({
    required this.id,
    required this.type,
    required this.product,
    required this.quantity,
    required this.dateLabel,
    required this.occurredAt,
    required this.reference,
    required this.recordedBy,
    required this.notes,
    required this.previousStock,
    required this.newStock,
  });

  final String id;
  final MovementType type;
  final MockProduct product;
  final String quantity;
  final String dateLabel;
  final String occurredAt;
  final String reference;
  final String recordedBy;
  final String notes;
  final String previousStock;
  final String newStock;
}

/// Display-only history. Form submissions never modify these records.
class MovementsMockData {
  static const receivedThisWeek = '12,450 kg';
  static const issuedThisWeek = '4,200 kg';

  static final movements = <MockMovement>[
    MockMovement(
      id: 'MOV-1042',
      type: MovementType.receipt,
      product: ProductsMockData.products[0],
      quantity: '+2,000 kg',
      dateLabel: 'Today',
      occurredAt: '11 Nov 2026',
      reference: 'DEL-2026-042',
      recordedBy: 'Warehouse team',
      notes: 'From collection center – Masaka.',
      previousStock: '40,000 kg',
      newStock: '42,000 kg',
    ),
    MockMovement(
      id: 'MOV-1039',
      type: MovementType.issue,
      product: ProductsMockData.products[2],
      quantity: '−500 pcs',
      dateLabel: '10 Nov',
      occurredAt: '10 Nov 2026',
      reference: 'ISS-2026-019',
      recordedBy: 'Jane A.',
      notes: 'Issued to the packaging line.',
      previousStock: '8,700 pcs',
      newStock: '8,200 pcs',
    ),
    MockMovement(
      id: 'MOV-1038',
      type: MovementType.receipt,
      product: ProductsMockData.products[1],
      quantity: '+850 kg',
      dateLabel: '9 Nov',
      occurredAt: '9 Nov 2026',
      reference: 'RCV-1027',
      recordedBy: 'Ethan Katungi',
      notes: 'Inbound lot inspected and accepted.',
      previousStock: '57,650 kg',
      newStock: '58,500 kg',
    ),
    MockMovement(
      id: 'MOV-1037',
      type: MovementType.adjustment,
      product: ProductsMockData.products[4],
      quantity: '−35 kg',
      dateLabel: '8 Nov',
      occurredAt: '8 Nov 2026',
      reference: 'ADJ-0014',
      recordedBy: 'Grace N.',
      notes: 'Physical count correction.',
      previousStock: '20,035 kg',
      newStock: '20,000 kg',
    ),
    MockMovement(
      id: 'MOV-1036',
      type: MovementType.issue,
      product: ProductsMockData.products[3],
      quantity: '−250 pcs',
      dateLabel: '09 Nov · 10:35',
      occurredAt: '09 Nov 2026 · 10:35',
      reference: 'ISS-1004',
      recordedBy: 'Jane A.',
      notes: 'Issued for dispatch.',
      previousStock: '3,750 pcs',
      newStock: '3,500 pcs',
    ),
    MockMovement(
      id: 'MOV-1035',
      type: MovementType.receipt,
      product: ProductsMockData.products[5],
      quantity: '+80 L',
      dateLabel: '08 Nov · 15:50',
      occurredAt: '08 Nov 2026 · 15:50',
      reference: 'RCV-1026',
      recordedBy: 'Ethan Katungi',
      notes: 'Supplier delivery received.',
      previousStock: '40 L',
      newStock: '120 L',
    ),
    MockMovement(
      id: 'MOV-1034',
      type: MovementType.issue,
      product: ProductsMockData.products[6],
      quantity: '−100 pcs',
      dateLabel: '08 Nov · 09:15',
      occurredAt: '08 Nov 2026 · 09:15',
      reference: 'ISS-1003',
      recordedBy: 'Grace N.',
      notes: 'Issued to fulfil an order.',
      previousStock: '4,500 pcs',
      newStock: '4,400 pcs',
    ),
    MockMovement(
      id: 'MOV-1033',
      type: MovementType.receipt,
      product: ProductsMockData.products[7],
      quantity: '+500 kg',
      dateLabel: '07 Nov · 13:05',
      occurredAt: '07 Nov 2026 · 13:05',
      reference: 'RCV-1025',
      recordedBy: 'Ethan Katungi',
      notes: 'Inbound delivery verified.',
      previousStock: '280 kg',
      newStock: '780 kg',
    ),
  ];
}
