import 'package:drift/drift.dart';

@DataClassName('PaymentScheduleRow')
class PaymentSchedules extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get invoiceId => integer()();
  TextColumn get title => text()();
  DateTimeColumn get dueDate => dateTime()();
  RealColumn get amount => real()();
  BoolColumn get isPaid => boolean()();
  DateTimeColumn get paidAt => dateTime().nullable()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}
