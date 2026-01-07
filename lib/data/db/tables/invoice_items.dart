import 'package:drift/drift.dart';

@DataClassName('InvoiceItemRow')
class InvoiceItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get invoiceId => integer()();
  TextColumn get name => text()();
  RealColumn get qty => real()();
  TextColumn get unit => text()();
  RealColumn get price => real()();
  RealColumn get discount => real()();
  TextColumn get note => text().nullable()();
  TextColumn get metadataJson => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}
