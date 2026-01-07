import 'package:drift/drift.dart';

import '../../domain/entities/invoice.dart';
import '../db/app_database.dart';

class InvoiceRepositoryDrift {
  final AppDatabase _db;

  InvoiceRepositoryDrift(this._db);

  Future<List<Invoice>> getAllInvoices() async {
    final rows = await _db.select(_db.invoices).get();
    return rows.map(_mapInvoice).toList();
  }

  Future<Invoice?> getInvoiceById(int id) async {
    final row =
        await (_db.select(_db.invoices)..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : _mapInvoice(row);
  }

  Future<List<Invoice>> getInvoicesByStatus(String status) async {
    final rows =
        await (_db.select(_db.invoices)..where((t) => t.status.equals(status))).get();
    return rows.map(_mapInvoice).toList();
  }

  Future<List<Invoice>> getInvoicesByCustomer(int customerId) async {
    final rows = await (_db.select(_db.invoices)
          ..where((t) => t.customerId.equals(customerId)))
        .get();
    return rows.map(_mapInvoice).toList();
  }

  Future<int> getInvoiceCount() async {
    final countExp = _db.invoices.id.count();
    final query = _db.selectOnly(_db.invoices)..addColumns([countExp]);
    final row = await query.getSingle();
    return row.read(countExp) ?? 0;
  }

  Future<void> createInvoice(Invoice invoice) async {
    final now = DateTime.now();
    invoice.createdAt = now;
    invoice.updatedAt = now;
    final id = await _db.into(_db.invoices).insert(InvoicesCompanion.insert(
          businessId: invoice.businessId,
          customerId: invoice.customerId,
          templateId: invoice.templateId,
          number: invoice.number,
          date: invoice.date,
          dueDate: Value(invoice.dueDate),
          status: invoice.status,
          subtotal: invoice.subtotal,
          discount: invoice.discount,
          tax: invoice.tax,
          shipping: invoice.shipping,
          grandTotal: invoice.grandTotal,
          notes: Value(invoice.notes),
          terms: Value(invoice.terms),
          customDataJson: Value(invoice.customDataJson),
          pdfPath: Value(invoice.pdfPath),
          createdAt: invoice.createdAt,
          updatedAt: invoice.updatedAt,
        ));
    invoice.id = id;
  }

  Future<void> updateInvoice(Invoice invoice) async {
    invoice.updatedAt = DateTime.now();
    await (_db.update(_db.invoices)..where((t) => t.id.equals(invoice.id!)))
        .write(
      InvoicesCompanion(
        businessId: Value(invoice.businessId),
        customerId: Value(invoice.customerId),
        templateId: Value(invoice.templateId),
        number: Value(invoice.number),
        date: Value(invoice.date),
        dueDate: Value(invoice.dueDate),
        status: Value(invoice.status),
        subtotal: Value(invoice.subtotal),
        discount: Value(invoice.discount),
        tax: Value(invoice.tax),
        shipping: Value(invoice.shipping),
        grandTotal: Value(invoice.grandTotal),
        notes: Value(invoice.notes),
        terms: Value(invoice.terms),
        customDataJson: Value(invoice.customDataJson),
        pdfPath: Value(invoice.pdfPath),
        updatedAt: Value(invoice.updatedAt),
      ),
    );
  }

  Future<void> deleteInvoice(int id) async {
    await _db.transaction(() async {
      await (_db.delete(_db.invoiceItems)..where((t) => t.invoiceId.equals(id)))
          .go();
      await (_db.delete(_db.payments)..where((t) => t.invoiceId.equals(id))).go();
      await (_db.delete(_db.paymentSchedules)
            ..where((t) => t.invoiceId.equals(id)))
          .go();
      await (_db.delete(_db.invoices)..where((t) => t.id.equals(id))).go();
    });
  }

  Future<List<InvoiceItem>> getInvoiceItems(int invoiceId) async {
    final rows = await (_db.select(_db.invoiceItems)
          ..where((t) => t.invoiceId.equals(invoiceId)))
        .get();
    return rows.map(_mapItem).toList();
  }

  Future<void> addInvoiceItem(InvoiceItem item) async {
    final now = DateTime.now();
    item.createdAt = now;
    final id =
        await _db.into(_db.invoiceItems).insert(InvoiceItemsCompanion.insert(
              invoiceId: item.invoiceId,
              name: item.name,
              qty: item.qty,
              unit: item.unit,
              price: item.price,
              discount: item.discount,
              note: Value(item.note),
              metadataJson: Value(item.metadataJson),
              createdAt: item.createdAt,
            ));
    item.id = id;
  }

  Future<void> updateInvoiceItem(InvoiceItem item) async {
    await (_db.update(_db.invoiceItems)..where((t) => t.id.equals(item.id!)))
        .write(
      InvoiceItemsCompanion(
        name: Value(item.name),
        qty: Value(item.qty),
        unit: Value(item.unit),
        price: Value(item.price),
        discount: Value(item.discount),
        note: Value(item.note),
        metadataJson: Value(item.metadataJson),
      ),
    );
  }

  Future<void> deleteInvoiceItem(int id) async {
    await (_db.delete(_db.invoiceItems)..where((t) => t.id.equals(id))).go();
  }

  Future<List<Payment>> getInvoicePayments(int invoiceId) async {
    final rows =
        await (_db.select(_db.payments)..where((t) => t.invoiceId.equals(invoiceId)))
            .get();
    return rows.map(_mapPayment).toList();
  }

  Future<void> addPayment(Payment payment) async {
    final now = DateTime.now();
    payment.createdAt = now;
    final id = await _db.into(_db.payments).insert(PaymentsCompanion.insert(
          invoiceId: payment.invoiceId,
          type: payment.type,
          method: payment.method,
          amount: payment.amount,
          paidAt: payment.paidAt,
          note: Value(payment.note),
          createdAt: payment.createdAt,
        ));
    payment.id = id;
  }

  Future<List<PaymentSchedule>> getPaymentSchedules(int invoiceId) async {
    final rows = await (_db.select(_db.paymentSchedules)
          ..where((t) => t.invoiceId.equals(invoiceId)))
        .get();
    return rows.map(_mapSchedule).toList();
  }

  Future<void> addPaymentSchedule(PaymentSchedule schedule) async {
    final now = DateTime.now();
    schedule.createdAt = now;
    final id = await _db
        .into(_db.paymentSchedules)
        .insert(PaymentSchedulesCompanion.insert(
          invoiceId: schedule.invoiceId,
          title: schedule.title,
          dueDate: schedule.dueDate,
          amount: schedule.amount,
          isPaid: schedule.isPaid,
          paidAt: Value(schedule.paidAt),
          note: Value(schedule.note),
          createdAt: schedule.createdAt,
        ));
    schedule.id = id;
  }

  Future<void> updatePaymentSchedule(PaymentSchedule schedule) async {
    await (_db.update(_db.paymentSchedules)
          ..where((t) => t.id.equals(schedule.id!)))
        .write(
      PaymentSchedulesCompanion(
        title: Value(schedule.title),
        dueDate: Value(schedule.dueDate),
        amount: Value(schedule.amount),
        isPaid: Value(schedule.isPaid),
        paidAt: Value(schedule.paidAt),
        note: Value(schedule.note),
      ),
    );
  }

  Future<double> getTotalRevenue(
      {DateTime? startDate, DateTime? endDate}) async {
    final rows =
        await (_db.select(_db.invoices)..where((t) => t.status.equals('paid'))).get();
    final filtered = rows.where((inv) {
      if (startDate != null && inv.date.isBefore(startDate)) return false;
      if (endDate != null && inv.date.isAfter(endDate)) return false;
      return true;
    });
    return filtered.fold<double>(0, (sum, inv) => sum + inv.grandTotal);
  }

  Future<int> getUnpaidInvoicesCount() async {
    final rows = await (_db.select(_db.invoices)
          ..where((t) => t.status.isIn(['draft', 'sent', 'partial_paid'])))
        .get();
    return rows.length;
  }

  Future<int> getOverdueInvoicesCount() async {
    final rows =
        await (_db.select(_db.invoices)..where((t) => t.status.equals('overdue')))
            .get();
    return rows.length;
  }

  Invoice _mapInvoice(InvoiceRow row) {
    return Invoice(
      id: row.id,
      businessId: row.businessId,
      customerId: row.customerId,
      templateId: row.templateId,
      number: row.number,
      date: row.date,
      dueDate: row.dueDate,
      status: row.status,
      subtotal: row.subtotal,
      discount: row.discount,
      tax: row.tax,
      shipping: row.shipping,
      grandTotal: row.grandTotal,
      notes: row.notes,
      terms: row.terms,
      customDataJson: row.customDataJson,
      pdfPath: row.pdfPath,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  InvoiceItem _mapItem(InvoiceItemRow row) {
    return InvoiceItem(
      id: row.id,
      invoiceId: row.invoiceId,
      name: row.name,
      qty: row.qty,
      unit: row.unit,
      price: row.price,
      discount: row.discount,
      note: row.note,
      metadataJson: row.metadataJson,
      createdAt: row.createdAt,
    );
  }

  Payment _mapPayment(PaymentRow row) {
    return Payment(
      id: row.id,
      invoiceId: row.invoiceId,
      type: row.type,
      method: row.method,
      amount: row.amount,
      paidAt: row.paidAt,
      note: row.note,
      createdAt: row.createdAt,
    );
  }

  PaymentSchedule _mapSchedule(PaymentScheduleRow row) {
    return PaymentSchedule(
      id: row.id,
      invoiceId: row.invoiceId,
      title: row.title,
      dueDate: row.dueDate,
      amount: row.amount,
      isPaid: row.isPaid,
      paidAt: row.paidAt,
      note: row.note,
      createdAt: row.createdAt,
    );
  }
}
