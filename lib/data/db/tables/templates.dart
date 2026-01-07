import 'package:drift/drift.dart';

@DataClassName('TemplateRow')
class Templates extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get templateLogoPath => text().nullable()();
  TextColumn get schemaJson => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}
