enum SupplierStatus { active, inactive }

class Supplier {
  const Supplier({
    required this.id,
    required this.businessName,
    required this.contactPerson,
    required this.phone,
    required this.email,
    required this.location,
    required this.category,
    required this.status,
    required this.orderCount,
    required this.pendingDeliveries,
  });

  final String id;
  final String businessName;
  final String contactPerson;
  final String phone;
  final String email;
  final String location;
  final String category;
  final SupplierStatus status;
  final int orderCount;
  final int pendingDeliveries;

  String get city => location.split(',').first.trim();

  String get initials => businessName
      .split(' ')
      .where((part) => part.isNotEmpty)
      .take(2)
      .map((part) => part[0].toUpperCase())
      .join();
}
