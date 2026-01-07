import 'package:drift/drift.dart';

@DataClassName('BusinessRow')
class Businesses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get address => text()();
  TextColumn get phone => text()();
  TextColumn get email => text()();
  TextColumn get logoPath => text().nullable()();
  TextColumn get invoicePrefix => text().nullable()();
  IntColumn get invoiceCounter => integer()();
  IntColumn get counterYear => integer()();
  TextColumn get themeColor => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}
