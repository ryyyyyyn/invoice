import '../../domain/entities/customer.dart';
import '../datasources/local_storage.dart';

class CustomerRepository {
  final LocalStorage _store = LocalStorage.instance;

  CustomerRepository();

  Future<List<Customer>> getAllCustomers() async => _store.getAllCustomers();

  Future<Customer?> getCustomerById(int id) async => _store.getCustomerById(id);

  Future<List<Customer>> searchCustomers(String query) async {
    final q = query.toLowerCase();
    return _store.customers.where((c) => c.name.toLowerCase().contains(q)).toList();
  }

  Future<void> createCustomer(Customer customer) async {
    customer.createdAt = DateTime.now();
    customer.updatedAt = DateTime.now();
    _store.addCustomer(customer);
  }

  Future<void> updateCustomer(Customer customer) async {
    customer.updatedAt = DateTime.now();
    _store.updateCustomer(customer);
  }

  Future<void> deleteCustomer(int id) async {
    _store.deleteCustomer(id);
  }
}
