class CatalogItem {
  int? id;

  late String name;
  late double price;
  late String unit; // pieces, hour, meter, etc
  String? category;
  String? description;

  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  CatalogItem({
    this.id,
    required this.name,
    required this.price,
    required this.unit,
    this.category,
    this.description,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();
}
