import 'package:drift/drift.dart';

@DataClassName('CatalogItemRow')
class CatalogItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get price => real()();
  TextColumn get unit => text()();
  TextColumn get category => text().nullable()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}
