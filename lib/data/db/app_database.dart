import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/businesses.dart';
import 'tables/customers.dart';
import 'tables/catalog_items.dart';
import 'tables/templates.dart';
import 'tables/invoices.dart';
import 'tables/invoice_items.dart';
import 'tables/payments.dart';
import 'tables/payment_schedules.dart';

part 'app_database.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'invoice.sqlite'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(
  tables: [
    Businesses,
    Customers,
    CatalogItems,
    Templates,
    Invoices,
    InvoiceItems,
    Payments,
    PaymentSchedules,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(invoices, invoices.pdfPath);
          }
          if (from < 3) {
            await m.addColumn(templates, templates.templateLogoPath);
          }
        },
      );
}
