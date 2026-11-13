import 'supplier.dart';

/// Fictional display records. Supplier forms do not mutate this list.
class SuppliersMockData {
  static const suppliers = <Supplier>[
    Supplier(
      id: 'SUP-008',
      businessName: 'Nile Agricultural Co.',
      contactPerson: 'Sarah Mukasa',
      phone: '+256 700 000 000',
      email: 'hello@example.com',
      location: 'Kampala, Uganda',
      category: 'Agricultural commodities',
      status: SupplierStatus.active,
      orderCount: 12,
      pendingDeliveries: 2,
    ),
    Supplier(
      id: 'SUP-009',
      businessName: 'Elgon Coffee Traders',
      contactPerson: 'Daniel Kato',
      phone: '+256 700 000 101',
      email: 'elgon@example.com',
      location: 'Mbale, Uganda',
      category: 'Coffee',
      status: SupplierStatus.active,
      orderCount: 8,
      pendingDeliveries: 1,
    ),
    Supplier(
      id: 'SUP-010',
      businessName: 'Green Valley Packaging',
      contactPerson: 'Amina Nansubuga',
      phone: '+256 700 000 202',
      email: 'greenvalley@example.com',
      location: 'Jinja, Uganda',
      category: 'Packaging supplies',
      status: SupplierStatus.active,
      orderCount: 5,
      pendingDeliveries: 0,
    ),
    Supplier(
      id: 'SUP-011',
      businessName: 'Rwenzori Produce',
      contactPerson: 'Joseph Baluku',
      phone: '+256 700 000 303',
      email: 'rwenzori@example.com',
      location: 'Kasese, Uganda',
      category: 'Agricultural commodities',
      status: SupplierStatus.active,
      orderCount: 3,
      pendingDeliveries: 1,
    ),
    Supplier(
      id: 'SUP-012',
      businessName: 'Lake Victoria Supplies',
      contactPerson: 'Grace Namuli',
      phone: '+256 700 000 404',
      email: 'lakevictoria@example.com',
      location: 'Entebbe, Uganda',
      category: 'General supplies',
      status: SupplierStatus.inactive,
      orderCount: 2,
      pendingDeliveries: 0,
    ),
  ];

  static const categories = <String>[
    'Agricultural commodities',
    'Coffee',
    'Packaging supplies',
    'General supplies',
  ];
}
