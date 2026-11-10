enum ProductCategory { coffee, packaging, others }

class MockProduct {
  const MockProduct({
    required this.name,
    required this.category,
    required this.categoryLabel,
    required this.sku,
    required this.quantity,
    required this.initials,
  });

  final String name;
  final ProductCategory category;
  final String categoryLabel;
  final String sku;
  final String quantity;
  final String initials;
}

/// Display-only inventory used until product storage is implemented.
class ProductsMockData {
  static const products = <MockProduct>[
    MockProduct(
      name: 'Arabica Coffee',
      category: ProductCategory.coffee,
      categoryLabel: 'Coffee',
      sku: 'ARA-001',
      quantity: '42,000 kg',
      initials: 'AR',
    ),
    MockProduct(
      name: 'Robusta Coffee',
      category: ProductCategory.coffee,
      categoryLabel: 'Coffee',
      sku: 'ROB-002',
      quantity: '58,500 kg',
      initials: 'RO',
    ),
    MockProduct(
      name: 'Packaging Bags',
      category: ProductCategory.packaging,
      categoryLabel: 'Packaging',
      sku: 'BAG-011',
      quantity: '8,200 pcs',
      initials: 'PB',
    ),
    MockProduct(
      name: 'Jute Sacks',
      category: ProductCategory.packaging,
      categoryLabel: 'Packaging',
      sku: 'SAC-014',
      quantity: '3,500 pcs',
      initials: 'JS',
    ),
    MockProduct(
      name: 'Sesame Seeds',
      category: ProductCategory.others,
      categoryLabel: 'Commodity',
      sku: 'SES-003',
      quantity: '20,000 kg',
      initials: 'SE',
    ),
    MockProduct(
      name: 'Sunflower Oil',
      category: ProductCategory.others,
      categoryLabel: 'Commodity',
      sku: 'OIL-005',
      quantity: '1,250 L',
      initials: 'SO',
    ),
    MockProduct(
      name: 'Carton Boxes',
      category: ProductCategory.packaging,
      categoryLabel: 'Packaging',
      sku: 'BOX-012',
      quantity: '4,400 pcs',
      initials: 'CB',
    ),
    MockProduct(
      name: 'Green Tea',
      category: ProductCategory.others,
      categoryLabel: 'Commodity',
      sku: 'TEA-004',
      quantity: '12,800 kg',
      initials: 'GT',
    ),
    MockProduct(
      name: 'Product Labels',
      category: ProductCategory.packaging,
      categoryLabel: 'Packaging',
      sku: 'LAB-016',
      quantity: '15,000 pcs',
      initials: 'PL',
    ),
    MockProduct(
      name: 'Cane Sugar',
      category: ProductCategory.others,
      categoryLabel: 'Commodity',
      sku: 'SUG-006',
      quantity: '9,600 kg',
      initials: 'CS',
    ),
    MockProduct(
      name: 'Milk Powder',
      category: ProductCategory.others,
      categoryLabel: 'Commodity',
      sku: 'MIL-007',
      quantity: '1,300 kg',
      initials: 'MP',
    ),
    MockProduct(
      name: 'Cocoa Beans',
      category: ProductCategory.others,
      categoryLabel: 'Commodity',
      sku: 'COC-008',
      quantity: '7,400 kg',
      initials: 'CO',
    ),
    MockProduct(
      name: 'White Rice',
      category: ProductCategory.others,
      categoryLabel: 'Commodity',
      sku: 'RIC-009',
      quantity: '16,200 kg',
      initials: 'WR',
    ),
    MockProduct(
      name: 'Dried Mango',
      category: ProductCategory.others,
      categoryLabel: 'Commodity',
      sku: 'MAN-010',
      quantity: '2,100 kg',
      initials: 'DM',
    ),
    MockProduct(
      name: 'Coffee Filters',
      category: ProductCategory.packaging,
      categoryLabel: 'Packaging',
      sku: 'FIL-017',
      quantity: '6,000 pcs',
      initials: 'CF',
    ),
    MockProduct(
      name: 'Ground Arabica',
      category: ProductCategory.coffee,
      categoryLabel: 'Coffee',
      sku: 'GRA-018',
      quantity: '1,750 kg',
      initials: 'GA',
    ),
    MockProduct(
      name: 'Roasted Robusta',
      category: ProductCategory.coffee,
      categoryLabel: 'Coffee',
      sku: 'RRO-019',
      quantity: '2,250 kg',
      initials: 'RR',
    ),
    MockProduct(
      name: 'Wooden Pallets',
      category: ProductCategory.packaging,
      categoryLabel: 'Packaging',
      sku: 'PAL-020',
      quantity: '420 pcs',
      initials: 'WP',
    ),
  ];
}
