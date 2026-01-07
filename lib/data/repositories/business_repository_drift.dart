import 'package:drift/drift.dart';

import '../../domain/entities/business.dart';
import '../db/app_database.dart';

class BusinessRepositoryDrift {
  final AppDatabase _db;

  BusinessRepositoryDrift(this._db);

  Future<Business> getOrCreateBusiness() async {
    final existing = await (_db.select(_db.businesses)..limit(1)).getSingleOrNull();
    if (existing != null) return _mapBusiness(existing);

    final now = DateTime.now();
    final business = Business(
      name: 'My Business',
      address: '',
      phone: '',
      email: '',
      invoicePrefix: 'INV',
      invoiceCounter: 0,
      counterYear: now.year,
      createdAt: now,
      updatedAt: now,
    );

    final id = await _db.into(_db.businesses).insert(BusinessesCompanion.insert(
          name: business.name,
          address: business.address,
          phone: business.phone,
          email: business.email,
          logoPath: Value(business.logoPath),
          invoicePrefix: Value(business.invoicePrefix),
          invoiceCounter: business.invoiceCounter,
          counterYear: business.counterYear,
          themeColor: Value(business.themeColor),
          createdAt: business.createdAt,
          updatedAt: business.updatedAt,
        ));
    business.id = id;
    return business;
  }

  Future<Business?> getFirstBusiness() async {
    final existing = await (_db.select(_db.businesses)..limit(1)).getSingleOrNull();
    return existing == null ? null : _mapBusiness(existing);
  }

  Future<void> updateBusiness(Business business) async {
    business.updatedAt = DateTime.now();
    await (_db.update(_db.businesses)..where((t) => t.id.equals(business.id!))).write(
      BusinessesCompanion(
        name: Value(business.name),
        address: Value(business.address),
        phone: Value(business.phone),
        email: Value(business.email),
        logoPath: Value(business.logoPath),
        invoicePrefix: Value(business.invoicePrefix),
        invoiceCounter: Value(business.invoiceCounter),
        counterYear: Value(business.counterYear),
        themeColor: Value(business.themeColor),
        updatedAt: Value(business.updatedAt),
      ),
    );
  }

  Business _mapBusiness(BusinessRow row) {
    return Business(
      id: row.id,
      name: row.name,
      address: row.address,
      phone: row.phone,
      email: row.email,
      logoPath: row.logoPath,
      invoicePrefix: row.invoicePrefix,
      invoiceCounter: row.invoiceCounter,
      counterYear: row.counterYear,
      themeColor: row.themeColor,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
