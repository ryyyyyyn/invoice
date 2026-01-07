import 'package:drift/drift.dart';

import '../../domain/entities/customer.dart';
import '../db/app_database.dart';

class CustomerRepositoryDrift {
  final AppDatabase _db;

  CustomerRepositoryDrift(this._db);

  Future<List<Customer>> getAllCustomers() async {
    final rows = await _db.select(_db.customers).get();
    return rows.map(_mapCustomer).toList();
  }

  Future<Customer?> getCustomerById(int id) async {
    final row = await (_db.select(_db.customers)..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : _mapCustomer(row);
  }

  Future<List<Customer>> searchCustomers(String query) async {
    final q = '%${query.toLowerCase()}%';
    final rows = await (_db.select(_db.customers)..where((t) => t.name.lower().like(q))).get();
    return rows.map(_mapCustomer).toList();
  }

  Future<void> createCustomer(Customer customer) async {
    final now = DateTime.now();
    customer.createdAt = now;
    customer.updatedAt = now;
    final id = await _db.into(_db.customers).insert(CustomersCompanion.insert(
          name: customer.name,
          address: Value(customer.address),
          whatsapp: Value(customer.whatsapp),
          email: Value(customer.email),
          notes: Value(customer.notes),
          createdAt: customer.createdAt,
          updatedAt: customer.updatedAt,
        ));
    customer.id = id;
  }

  Future<void> updateCustomer(Customer customer) async {
    customer.updatedAt = DateTime.now();
    await (_db.update(_db.customers)..where((t) => t.id.equals(customer.id!))).write(
      CustomersCompanion(
        name: Value(customer.name),
        address: Value(customer.address),
        whatsapp: Value(customer.whatsapp),
        email: Value(customer.email),
        notes: Value(customer.notes),
        updatedAt: Value(customer.updatedAt),
      ),
    );
  }

  Future<void> deleteCustomer(int id) async {
    await (_db.delete(_db.customers)..where((t) => t.id.equals(id))).go();
  }

  Customer _mapCustomer(CustomerRow row) {
    return Customer(
      id: row.id,
      name: row.name,
      address: row.address,
      whatsapp: row.whatsapp,
      email: row.email,
      notes: row.notes,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
