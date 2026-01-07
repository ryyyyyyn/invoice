import '../../domain/entities/invoice.dart';
import '../datasources/local_storage.dart';

class InvoiceRepository {
  final LocalStorage _store = LocalStorage.instance;

  InvoiceRepository();

  Future<List<Invoice>> getAllInvoices() async => _store.getAllInvoices();

  Future<Invoice?> getInvoiceById(int id) async => _store.getInvoiceById(id);

  Future<List<Invoice>> getInvoicesByStatus(String status) async => _store.invoices.where((i) => i.status == status).toList();

  Future<List<Invoice>> getInvoicesByCustomer(int customerId) async => _store.invoices.where((i) => i.customerId == customerId).toList();

  Future<int> getInvoiceCount() async => _store.invoices.length;

  Future<void> createInvoice(Invoice invoice) async {
    invoice.createdAt = DateTime.now();
    invoice.updatedAt = DateTime.now();
    _store.addInvoice(invoice);
  }

  Future<void> updateInvoice(Invoice invoice) async {
    invoice.updatedAt = DateTime.now();
    _store.updateInvoice(invoice);
  }

  Future<void> deleteInvoice(int id) async => _store.deleteInvoice(id);

  Future<List<InvoiceItem>> getInvoiceItems(int invoiceId) async => _store.getInvoiceItems(invoiceId);

  Future<void> addInvoiceItem(InvoiceItem item) async {
    item.createdAt = DateTime.now();
    _store.addInvoiceItem(item);
  }

  Future<void> updateInvoiceItem(InvoiceItem item) async => _store.updateInvoiceItem(item);

  Future<void> deleteInvoiceItem(int id) async => _store.deleteInvoiceItem(id);

  Future<List<Payment>> getInvoicePayments(int invoiceId) async => _store.getPayments(invoiceId);

  Future<void> addPayment(Payment payment) async {
    payment.createdAt = DateTime.now();
    _store.addPayment(payment);
  }

  Future<List<PaymentSchedule>> getPaymentSchedules(int invoiceId) async => _store.getPaymentSchedules(invoiceId);

  Future<void> addPaymentSchedule(PaymentSchedule schedule) async {
    schedule.createdAt = DateTime.now();
    _store.addPaymentSchedule(schedule);
  }

  Future<void> updatePaymentSchedule(PaymentSchedule schedule) async => _store.updatePaymentSchedule(schedule);

  Future<double> getTotalRevenue({DateTime? startDate, DateTime? endDate}) async {
    final invoices = _store.invoices.where((i) => i.status == 'paid');
    final filtered = invoices.where((inv) {
      if (startDate != null && inv.date.isBefore(startDate)) return false;
      if (endDate != null && inv.date.isAfter(endDate)) return false;
      return true;
    });
    return filtered.fold<double>(0, (sum, inv) => sum + inv.grandTotal);
  }

  Future<int> getUnpaidInvoicesCount() async {
    return _store.invoices.where((i) => i.status == 'draft' || i.status == 'sent' || i.status == 'partial_paid').length;
  }

  Future<int> getOverdueInvoicesCount() async => _store.invoices.where((i) => i.status == 'overdue').length;
}
