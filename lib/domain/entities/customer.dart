class Customer {
  int? id;

  late String name;
  String? address;
  String? whatsapp;
  String? email;
  String? notes;

  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  Customer({
    this.id,
    required this.name,
    this.address,
    this.whatsapp,
    this.email,
    this.notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();
}
