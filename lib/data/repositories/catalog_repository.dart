import '../../domain/entities/catalog_item.dart';
import '../datasources/local_storage.dart';

class CatalogRepository {
  final LocalStorage _store = LocalStorage.instance;

  CatalogRepository();

  Future<List<CatalogItem>> getAllItems() async => _store.getAllItems();

  Future<CatalogItem?> getItemById(int id) async {
    try {
      return _store.catalogItems.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<CatalogItem>> getItemsByCategory(String category) async => _store.catalogItems.where((c) => c.category == category).toList();

  Future<void> createItem(CatalogItem item) async {
    item.createdAt = DateTime.now();
    item.updatedAt = DateTime.now();
    _store.addCatalogItem(item);
  }

  Future<void> updateItem(CatalogItem item) async {
    item.updatedAt = DateTime.now();
    _store.updateCatalogItem(item);
  }

  Future<void> deleteItem(int id) async => _store.deleteCatalogItem(id);
}
