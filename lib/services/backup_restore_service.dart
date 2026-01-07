import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../data/db/app_database.dart';

class BackupRestoreService {
  static const int backupVersion = 1;
  final AppDatabase _db;

  BackupRestoreService(this._db);

  Future<File> exportAndShare() async {
    final payload = await _buildBackupPayload();
    final dir = await getApplicationDocumentsDirectory();
    final fileName = _buildBackupFileName();
    final file = File(p.join(dir.path, fileName));
    await file.writeAsString(jsonEncode(payload));
    await Share.shareXFiles([XFile(file.path)], text: 'Invoice backup');
    return file;
  }

  Future<File?> pickBackupFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result == null || result.files.isEmpty) return null;
    final path = result.files.single.path;
    if (path == null) return null;
    return File(path);
  }

  Future<void> importFromFile(File file, {required bool replace}) async {
    final jsonStr = await file.readAsString();
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;
    final version = data['backupVersion'] as int? ?? 0;
    if (version != backupVersion) {
      throw Exception('Unsupported backup version: $version');
    }

    final businesses = (data['businesses'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
    final customers = (data['customers'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
    final catalogItems = (data['catalogItems'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
    final templates = (data['templates'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
    final invoices = (data['invoices'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
    final invoiceItems = (data['invoiceItems'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
    final payments = (data['payments'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
    final paymentSchedules = (data['paymentSchedules'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();

    await _db.transaction(() async {
      if (replace) {
        await _db.delete(_db.paymentSchedules).go();
        await _db.delete(_db.payments).go();
        await _db.delete(_db.invoiceItems).go();
        await _db.delete(_db.invoices).go();
        await _db.delete(_db.templates).go();
        await _db.delete(_db.catalogItems).go();
        await _db.delete(_db.customers).go();
        await _db.delete(_db.businesses).go();
      }

      await _db.batch((batch) {
        batch.insertAll(
          _db.businesses,
          businesses.map(_businessFromJson).toList(),
          mode: InsertMode.insertOrReplace,
        );
        batch.insertAll(
          _db.customers,
          customers.map(_customerFromJson).toList(),
          mode: InsertMode.insertOrReplace,
        );
        batch.insertAll(
          _db.catalogItems,
          catalogItems.map(_catalogFromJson).toList(),
          mode: InsertMode.insertOrReplace,
        );
        batch.insertAll(
          _db.templates,
          templates.map(_templateFromJson).toList(),
          mode: InsertMode.insertOrReplace,
        );
        batch.insertAll(
          _db.invoices,
          invoices.map(_invoiceFromJson).toList(),
          mode: InsertMode.insertOrReplace,
        );
        batch.insertAll(
          _db.invoiceItems,
          invoiceItems.map(_invoiceItemFromJson).toList(),
          mode: InsertMode.insertOrReplace,
        );
        batch.insertAll(
          _db.payments,
          payments.map(_paymentFromJson).toList(),
          mode: InsertMode.insertOrReplace,
        );
        batch.insertAll(
          _db.paymentSchedules,
          paymentSchedules.map(_scheduleFromJson).toList(),
          mode: InsertMode.insertOrReplace,
        );
      });
    });
  }

  Future<Map<String, dynamic>> _buildBackupPayload() async {
    final businesses = await _db.select(_db.businesses).get();
    final customers = await _db.select(_db.customers).get();
    final catalogItems = await _db.select(_db.catalogItems).get();
    final templates = await _db.select(_db.templates).get();
    final invoices = await _db.select(_db.invoices).get();
    final invoiceItems = await _db.select(_db.invoiceItems).get();
    final payments = await _db.select(_db.payments).get();
    final schedules = await _db.select(_db.paymentSchedules).get();

    return {
      'backupVersion': backupVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'businesses': businesses.map(_businessToJson).toList(),
      'customers': customers.map(_customerToJson).toList(),
      'catalogItems': catalogItems.map(_catalogToJson).toList(),
      'templates': templates.map(_templateToJson).toList(),
      'invoices': invoices.map(_invoiceToJson).toList(),
      'invoiceItems': invoiceItems.map(_invoiceItemToJson).toList(),
      'payments': payments.map(_paymentToJson).toList(),
      'paymentSchedules': schedules.map(_scheduleToJson).toList(),
    };
  }

  String _buildBackupFileName() {
    final stamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    return 'invoice_backup_$stamp.json';
  }

  Map<String, dynamic> _businessToJson(BusinessRow row) => {
        'id': row.id,
        'name': row.name,
        'address': row.address,
        'phone': row.phone,
        'email': row.email,
        'logoPath': row.logoPath,
        'invoicePrefix': row.invoicePrefix,
        'invoiceCounter': row.invoiceCounter,
        'counterYear': row.counterYear,
        'themeColor': row.themeColor,
        'createdAt': row.createdAt.toIso8601String(),
        'updatedAt': row.updatedAt.toIso8601String(),
      };

  Map<String, dynamic> _customerToJson(CustomerRow row) => {
        'id': row.id,
        'name': row.name,
        'address': row.address,
        'whatsapp': row.whatsapp,
        'email': row.email,
        'notes': row.notes,
        'createdAt': row.createdAt.toIso8601String(),
        'updatedAt': row.updatedAt.toIso8601String(),
      };

  Map<String, dynamic> _catalogToJson(CatalogItemRow row) => {
        'id': row.id,
        'name': row.name,
        'price': row.price,
        'unit': row.unit,
        'category': row.category,
        'description': row.description,
        'createdAt': row.createdAt.toIso8601String(),
        'updatedAt': row.updatedAt.toIso8601String(),
      };

  Map<String, dynamic> _templateToJson(TemplateRow row) => {
        'id': row.id,
        'name': row.name,
        'description': row.description,
        'templateLogoPath': row.templateLogoPath,
        'schemaJson': row.schemaJson,
        'createdAt': row.createdAt.toIso8601String(),
        'updatedAt': row.updatedAt.toIso8601String(),
      };

  Map<String, dynamic> _invoiceToJson(InvoiceRow row) => {
        'id': row.id,
        'businessId': row.businessId,
        'customerId': row.customerId,
        'templateId': row.templateId,
        'number': row.number,
        'date': row.date.toIso8601String(),
        'dueDate': row.dueDate?.toIso8601String(),
        'status': row.status,
        'subtotal': row.subtotal,
        'discount': row.discount,
        'tax': row.tax,
        'shipping': row.shipping,
        'grandTotal': row.grandTotal,
        'notes': row.notes,
        'terms': row.terms,
        'customDataJson': row.customDataJson,
        'pdfPath': row.pdfPath,
        'createdAt': row.createdAt.toIso8601String(),
        'updatedAt': row.updatedAt.toIso8601String(),
      };

  Map<String, dynamic> _invoiceItemToJson(InvoiceItemRow row) => {
        'id': row.id,
        'invoiceId': row.invoiceId,
        'name': row.name,
        'qty': row.qty,
        'unit': row.unit,
        'price': row.price,
        'discount': row.discount,
        'note': row.note,
        'metadataJson': row.metadataJson,
        'createdAt': row.createdAt.toIso8601String(),
      };

  Map<String, dynamic> _paymentToJson(PaymentRow row) => {
        'id': row.id,
        'invoiceId': row.invoiceId,
        'type': row.type,
        'method': row.method,
        'amount': row.amount,
        'paidAt': row.paidAt.toIso8601String(),
        'note': row.note,
        'createdAt': row.createdAt.toIso8601String(),
      };

  Map<String, dynamic> _scheduleToJson(PaymentScheduleRow row) => {
        'id': row.id,
        'invoiceId': row.invoiceId,
        'title': row.title,
        'dueDate': row.dueDate.toIso8601String(),
        'amount': row.amount,
        'isPaid': row.isPaid,
        'paidAt': row.paidAt?.toIso8601String(),
        'note': row.note,
        'createdAt': row.createdAt.toIso8601String(),
      };

  BusinessesCompanion _businessFromJson(Map<String, dynamic> map) {
    return BusinessesCompanion(
      id: Value(map['id'] as int),
      name: Value(map['name'] as String),
      address: Value(map['address'] as String),
      phone: Value(map['phone'] as String),
      email: Value(map['email'] as String),
      logoPath: Value(map['logoPath'] as String?),
      invoicePrefix: Value(map['invoicePrefix'] as String?),
      invoiceCounter: Value(map['invoiceCounter'] as int),
      counterYear: Value(map['counterYear'] as int),
      themeColor: Value(map['themeColor'] as String?),
      createdAt: Value(DateTime.parse(map['createdAt'] as String)),
      updatedAt: Value(DateTime.parse(map['updatedAt'] as String)),
    );
  }

  CustomersCompanion _customerFromJson(Map<String, dynamic> map) {
    return CustomersCompanion(
      id: Value(map['id'] as int),
      name: Value(map['name'] as String),
      address: Value(map['address'] as String?),
      whatsapp: Value(map['whatsapp'] as String?),
      email: Value(map['email'] as String?),
      notes: Value(map['notes'] as String?),
      createdAt: Value(DateTime.parse(map['createdAt'] as String)),
      updatedAt: Value(DateTime.parse(map['updatedAt'] as String)),
    );
  }

  CatalogItemsCompanion _catalogFromJson(Map<String, dynamic> map) {
    return CatalogItemsCompanion(
      id: Value(map['id'] as int),
      name: Value(map['name'] as String),
      price: Value((map['price'] as num).toDouble()),
      unit: Value(map['unit'] as String),
      category: Value(map['category'] as String?),
      description: Value(map['description'] as String?),
      createdAt: Value(DateTime.parse(map['createdAt'] as String)),
      updatedAt: Value(DateTime.parse(map['updatedAt'] as String)),
    );
  }

  TemplatesCompanion _templateFromJson(Map<String, dynamic> map) {
    return TemplatesCompanion(
      id: Value(map['id'] as int),
      name: Value(map['name'] as String),
      description: Value(map['description'] as String?),
      templateLogoPath: Value(map['templateLogoPath'] as String?),
      schemaJson: Value(map['schemaJson'] as String),
      createdAt: Value(DateTime.parse(map['createdAt'] as String)),
      updatedAt: Value(DateTime.parse(map['updatedAt'] as String)),
    );
  }

  InvoicesCompanion _invoiceFromJson(Map<String, dynamic> map) {
    return InvoicesCompanion(
      id: Value(map['id'] as int),
      businessId: Value(map['businessId'] as int),
      customerId: Value(map['customerId'] as int),
      templateId: Value(map['templateId'] as int),
      number: Value(map['number'] as String),
      date: Value(DateTime.parse(map['date'] as String)),
      dueDate: Value(map['dueDate'] == null ? null : DateTime.parse(map['dueDate'] as String)),
      status: Value(map['status'] as String),
      subtotal: Value((map['subtotal'] as num).toDouble()),
      discount: Value((map['discount'] as num).toDouble()),
      tax: Value((map['tax'] as num).toDouble()),
      shipping: Value((map['shipping'] as num).toDouble()),
      grandTotal: Value((map['grandTotal'] as num).toDouble()),
      notes: Value(map['notes'] as String?),
      terms: Value(map['terms'] as String?),
      customDataJson: Value(map['customDataJson'] as String?),
      pdfPath: Value(map['pdfPath'] as String?),
      createdAt: Value(DateTime.parse(map['createdAt'] as String)),
      updatedAt: Value(DateTime.parse(map['updatedAt'] as String)),
    );
  }

  InvoiceItemsCompanion _invoiceItemFromJson(Map<String, dynamic> map) {
    return InvoiceItemsCompanion(
      id: Value(map['id'] as int),
      invoiceId: Value(map['invoiceId'] as int),
      name: Value(map['name'] as String),
      qty: Value((map['qty'] as num).toDouble()),
      unit: Value(map['unit'] as String),
      price: Value((map['price'] as num).toDouble()),
      discount: Value((map['discount'] as num).toDouble()),
      note: Value(map['note'] as String?),
      metadataJson: Value(map['metadataJson'] as String?),
      createdAt: Value(DateTime.parse(map['createdAt'] as String)),
    );
  }

  PaymentsCompanion _paymentFromJson(Map<String, dynamic> map) {
    return PaymentsCompanion(
      id: Value(map['id'] as int),
      invoiceId: Value(map['invoiceId'] as int),
      type: Value(map['type'] as String),
      method: Value(map['method'] as String),
      amount: Value((map['amount'] as num).toDouble()),
      paidAt: Value(DateTime.parse(map['paidAt'] as String)),
      note: Value(map['note'] as String?),
      createdAt: Value(DateTime.parse(map['createdAt'] as String)),
    );
  }

  PaymentSchedulesCompanion _scheduleFromJson(Map<String, dynamic> map) {
    return PaymentSchedulesCompanion(
      id: Value(map['id'] as int),
      invoiceId: Value(map['invoiceId'] as int),
      title: Value(map['title'] as String),
      dueDate: Value(DateTime.parse(map['dueDate'] as String)),
      amount: Value((map['amount'] as num).toDouble()),
      isPaid: Value(map['isPaid'] as bool),
      paidAt: Value(map['paidAt'] == null ? null : DateTime.parse(map['paidAt'] as String)),
      note: Value(map['note'] as String?),
      createdAt: Value(DateTime.parse(map['createdAt'] as String)),
    );
  }
}
