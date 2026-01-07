import 'package:drift/drift.dart';

@DataClassName('PaymentRow')
class Payments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get invoiceId => integer()();
  TextColumn get type => text()();
  TextColumn get method => text()();
  RealColumn get amount => real()();
  DateTimeColumn get paidAt => dateTime()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}
