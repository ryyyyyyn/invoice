import 'package:drift/drift.dart';

import '../../domain/entities/catalog_item.dart';
import '../db/app_database.dart';

class CatalogRepositoryDrift {
  final AppDatabase _db;

  CatalogRepositoryDrift(this._db);

  Future<List<CatalogItem>> getAllItems() async {
    final rows = await _db.select(_db.catalogItems).get();
    return rows.map(_mapItem).toList();
  }

  Future<CatalogItem?> getItemById(int id) async {
    final row = await (_db.select(_db.catalogItems)..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : _mapItem(row);
  }

  Future<List<CatalogItem>> getItemsByCategory(String category) async {
    final rows = await (_db.select(_db.catalogItems)..where((t) => t.category.equals(category))).get();
    return rows.map(_mapItem).toList();
  }

  Future<void> createItem(CatalogItem item) async {
    final now = DateTime.now();
    item.createdAt = now;
    item.updatedAt = now;
    final id = await _db.into(_db.catalogItems).insert(CatalogItemsCompanion.insert(
          name: item.name,
          price: item.price,
          unit: item.unit,
          category: Value(item.category),
          description: Value(item.description),
          createdAt: item.createdAt,
          updatedAt: item.updatedAt,
        ));
    item.id = id;
  }

  Future<void> updateItem(CatalogItem item) async {
    item.updatedAt = DateTime.now();
    await (_db.update(_db.catalogItems)..where((t) => t.id.equals(item.id!))).write(
      CatalogItemsCompanion(
        name: Value(item.name),
        price: Value(item.price),
        unit: Value(item.unit),
        category: Value(item.category),
        description: Value(item.description),
        updatedAt: Value(item.updatedAt),
      ),
    );
  }

  Future<void> deleteItem(int id) async {
    await (_db.delete(_db.catalogItems)..where((t) => t.id.equals(id))).go();
  }

  CatalogItem _mapItem(CatalogItemRow row) {
    return CatalogItem(
      id: row.id,
      name: row.name,
      price: row.price,
      unit: row.unit,
      category: row.category,
      description: row.description,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
