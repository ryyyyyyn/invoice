import 'package:drift/drift.dart';

@DataClassName('InvoiceRow')
class Invoices extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get businessId => integer()();
  IntColumn get customerId => integer()();
  IntColumn get templateId => integer()();
  TextColumn get number => text()();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get dueDate => dateTime().nullable()();
  TextColumn get status => text()();
  RealColumn get subtotal => real()();
  RealColumn get discount => real()();
  RealColumn get tax => real()();
  RealColumn get shipping => real()();
  RealColumn get grandTotal => real()();
  TextColumn get notes => text().nullable()();
  TextColumn get terms => text().nullable()();
  TextColumn get customDataJson => text().nullable()();
  TextColumn get pdfPath => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}
