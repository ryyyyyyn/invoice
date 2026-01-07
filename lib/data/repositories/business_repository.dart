import '../../domain/entities/business.dart';
import '../datasources/local_storage.dart';

class BusinessRepository {
  final LocalStorage _store = LocalStorage.instance;

  BusinessRepository();

  Future<Business> getOrCreateBusiness() async {
    final existing = _store.getFirstBusiness();
    if (existing != null) return existing;

    final business = Business(
      name: 'My Business',
      address: '',
      phone: '',
      email: '',
      invoicePrefix: 'INV',
      invoiceCounter: 0,
      counterYear: DateTime.now().year,
    );

    _store.createBusiness(business);
    return business;
  }

  Future<void> updateBusiness(Business business) async {
    business.updatedAt = DateTime.now();
    _store.updateBusiness(business);
  }
}
