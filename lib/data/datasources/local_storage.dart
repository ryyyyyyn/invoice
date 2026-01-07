import '../../domain/entities/business.dart';
import '../../domain/entities/customer.dart';
import '../../domain/entities/catalog_item.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/template.dart';

class LocalStorage {
  LocalStorage._privateConstructor();
  static final LocalStorage instance = LocalStorage._privateConstructor();

  final List<Business> businesses = [];
  final List<Customer> customers = [];
  final List<CatalogItem> catalogItems = [];
  final List<Template> templates = [];
  final List<Invoice> invoices = [];
  final List<InvoiceItem> invoiceItems = [];
  final List<Payment> payments = [];
  final List<PaymentSchedule> paymentSchedules = [];

  int _nextId(String collection) {
    switch (collection) {
      case 'business':
        return (businesses.isEmpty ? 1 : (businesses.last.id ?? 0) + 1);
      case 'customer':
        return (customers.isEmpty ? 1 : (customers.last.id ?? 0) + 1);
      case 'catalog':
        return (catalogItems.isEmpty ? 1 : (catalogItems.last.id ?? 0) + 1);
      case 'template':
        return (templates.isEmpty ? 1 : (templates.last.id ?? 0) + 1);
      case 'invoice':
        return (invoices.isEmpty ? 1 : (invoices.last.id ?? 0) + 1);
      case 'invoiceItem':
        return (invoiceItems.isEmpty ? 1 : (invoiceItems.last.id ?? 0) + 1);
      case 'payment':
        return (payments.isEmpty ? 1 : (payments.last.id ?? 0) + 1);
      case 'paymentSchedule':
        return (paymentSchedules.isEmpty ? 1 : (paymentSchedules.last.id ?? 0) + 1);
      default:
        return 1;
    }
  }

  // Business helpers
  Business createBusiness(Business b) {
    b.id = _nextId('business');
    businesses.add(b);
    return b;
  }

  Business? getFirstBusiness() => businesses.isEmpty ? null : businesses.first;

  void updateBusiness(Business b) {
    final idx = businesses.indexWhere((x) => x.id == b.id);
    if (idx >= 0) businesses[idx] = b;
  }

  // Customers
  List<Customer> getAllCustomers() => List.from(customers);
  Customer? getCustomerById(int id) {
    try {
      return customers.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
  void addCustomer(Customer c) {
    c.id = _nextId('customer');
    customers.add(c);
  }

  void updateCustomer(Customer c) {
    final idx = customers.indexWhere((x) => x.id == c.id);
    if (idx >= 0) customers[idx] = c;
  }

  void deleteCustomer(int id) => customers.removeWhere((c) => c.id == id);

  // Catalog
  List<CatalogItem> getAllItems() => List.from(catalogItems);
  void addCatalogItem(CatalogItem it) {
    it.id = _nextId('catalog');
    catalogItems.add(it);
  }

  void updateCatalogItem(CatalogItem it) {
    final idx = catalogItems.indexWhere((x) => x.id == it.id);
    if (idx >= 0) catalogItems[idx] = it;
  }

  void deleteCatalogItem(int id) => catalogItems.removeWhere((i) => i.id == id);

  // Templates - simple helpers
  List<Template> getAllTemplates() => List.from(templates);
  void addTemplate(Template t) {
    t.id = _nextId('template');
    templates.add(t);
  }

  void updateTemplate(Template t) {
    final idx = templates.indexWhere((x) => x.id == t.id);
    if (idx >= 0) templates[idx] = t;
  }

  // Invoices (basic)
  List<Invoice> getAllInvoices() => List.from(invoices);
  Invoice? getInvoiceById(int id) {
    try {
      return invoices.firstWhere((i) => i.id == id);
    } catch (e) {
      return null;
    }
  }

  void addInvoice(Invoice inv) {
    inv.id = _nextId('invoice');
    invoices.add(inv);
  }

  void updateInvoice(Invoice inv) {
    final idx = invoices.indexWhere((x) => x.id == inv.id);
    if (idx >= 0) invoices[idx] = inv;
  }

  void deleteInvoice(int id) {
    invoiceItems.removeWhere((it) => it.invoiceId == id);
    payments.removeWhere((p) => p.invoiceId == id);
    paymentSchedules.removeWhere((s) => s.invoiceId == id);
    invoices.removeWhere((i) => i.id == id);
  }

  List<InvoiceItem> getInvoiceItems(int invoiceId) => invoiceItems.where((it) => it.invoiceId == invoiceId).toList();
  void addInvoiceItem(InvoiceItem item) {
    item.id = _nextId('invoiceItem');
    invoiceItems.add(item);
  }

  void updateInvoiceItem(InvoiceItem item) {
    final idx = invoiceItems.indexWhere((x) => x.id == item.id);
    if (idx >= 0) invoiceItems[idx] = item;
  }

  void deleteInvoiceItem(int id) => invoiceItems.removeWhere((it) => it.id == id);

  List<Payment> getPayments(int invoiceId) => payments.where((p) => p.invoiceId == invoiceId).toList();
  void addPayment(Payment p) {
    p.id = _nextId('payment');
    payments.add(p);
  }

  List<PaymentSchedule> getPaymentSchedules(int invoiceId) => paymentSchedules.where((s) => s.invoiceId == invoiceId).toList();
  void addPaymentSchedule(PaymentSchedule s) {
    s.id = _nextId('paymentSchedule');
    paymentSchedules.add(s);
  }

  void updatePaymentSchedule(PaymentSchedule s) {
    final idx = paymentSchedules.indexWhere((x) => x.id == s.id);
    if (idx >= 0) paymentSchedules[idx] = s;
  }
}
