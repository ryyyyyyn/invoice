class Business {
  int? id;

  late String name;
  late String address;
  late String phone;
  late String email;
  String? logoPath;
  String? invoicePrefix;
  int invoiceCounter = 0;
  int counterYear = DateTime.now().year;
  String? themeColor; // optional, default using accentNeon

  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  Business({
    this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    this.logoPath,
    this.invoicePrefix,
    this.invoiceCounter = 0,
    this.counterYear = 0,
    this.themeColor,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();
}
