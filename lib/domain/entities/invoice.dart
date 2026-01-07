class Invoice {
  int? id;

  late int businessId;
  late int customerId;
  late int templateId;

  late String number; // INV-2025-0001
  late DateTime date;
  DateTime? dueDate;

  late String status; // draft, sent, partial_paid, paid, overdue, cancelled
  
  late double subtotal;
  double discount = 0.0;
  double tax = 0.0;
  double shipping = 0.0;
  late double grandTotal;

  String? notes;
  String? terms;

  // JSON map of custom fields from template
  String? customDataJson;
  String? pdfPath;

  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  Invoice({
    this.id,
    required this.businessId,
    required this.customerId,
    required this.templateId,
    required this.number,
    required this.date,
    this.dueDate,
    required this.status,
    required this.subtotal,
    this.discount = 0.0,
    this.tax = 0.0,
    this.shipping = 0.0,
    required this.grandTotal,
    this.notes,
    this.terms,
    this.customDataJson,
    this.pdfPath,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();
}

class InvoiceItem {
  int? id;

  late int invoiceId;
  late String name;
  late double qty;
  late String unit;
  late double price;
  double discount = 0.0;
  String? note;

  // JSON for future extensibility
  String? metadataJson;

  DateTime createdAt = DateTime.now();

  InvoiceItem({
    this.id,
    required this.invoiceId,
    required this.name,
    required this.qty,
    required this.unit,
    required this.price,
    this.discount = 0.0,
    this.note,
    this.metadataJson,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

class Payment {
  int? id;

  late int invoiceId;
  late String type; // lunas, dp, termin
  late String method; // cash, transfer, other
  late double amount;
  late DateTime paidAt;
  String? note;

  DateTime createdAt = DateTime.now();

  Payment({
    this.id,
    required this.invoiceId,
    required this.type,
    required this.method,
    required this.amount,
    required this.paidAt,
    this.note,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

class PaymentSchedule {
  int? id;

  late int invoiceId;
  late String title; // "Termin 1", "DP", etc
  late DateTime dueDate;
  late double amount;
  late bool isPaid;
  DateTime? paidAt;
  String? note;

  DateTime createdAt = DateTime.now();

  PaymentSchedule({
    this.id,
    required this.invoiceId,
    required this.title,
    required this.dueDate,
    required this.amount,
    required this.isPaid,
    this.paidAt,
    this.note,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
