
import 'dart:io';
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:invoice/domain/entities/business.dart';
import 'package:invoice/domain/entities/customer.dart';
import 'package:invoice/domain/entities/invoice.dart';
import 'package:invoice/domain/entities/template.dart';
import 'package:invoice/utils/template_schema.dart';

class PdfInvoiceService {
  final NumberFormat _currency = NumberFormat('#,##0.00');
  final DateFormat _date = DateFormat('dd MMM yyyy');

  Future<File> generateInvoicePdf({
    required Business business,
    required Customer customer,
    required Template template,
    required Invoice invoice,
    required List<InvoiceItem> items,
    required Map<String, dynamic> customData,
    required List<Payment> payments,
    required List<PaymentSchedule> schedules,
  }) async {
    final bytes = await generateInvoicePdfBytes(
      business: business,
      customer: customer,
      template: template,
      invoice: invoice,
      items: items,
      customData: customData,
      payments: payments,
      schedules: schedules,
    );
    final dir = await getApplicationDocumentsDirectory();
    final fileName = _sanitizeFileName('${invoice.number}.pdf');
    final file = File(p.join(dir.path, fileName));
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<Uint8List> generateInvoicePdfBytes({
    required Business business,
    required Customer customer,
    required Template template,
    required Invoice invoice,
    required List<InvoiceItem> items,
    required Map<String, dynamic> customData,
    required List<Payment> payments,
    required List<PaymentSchedule> schedules,
  }) async {
    final doc = pw.Document();
    final logoImage = await loadLogoFromPaths(template.templateLogoPath, business.logoPath);
    final schema = TemplateSchema.fromJson(template.schemaJson);
    final customRows = _buildCustomRows(schema, customData);

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          _buildHeader(business, logoImage),
          pw.SizedBox(height: 16),
          _buildMetaCustomerRow(invoice, customer),
          if (customRows.isNotEmpty) ...[
            pw.SizedBox(height: 16),
            _sectionTitle('Custom Fields'),
            _buildKeyValueTable(customRows),
          ],
          pw.SizedBox(height: 16),
          _sectionTitle('Items'),
          _buildItemsTable(items),
          pw.SizedBox(height: 16),
          _buildSummary(invoice),
          pw.SizedBox(height: 16),
          _buildPaymentInfo(payments, schedules),
        ],
      ),
    );

    return doc.save();
  }

  Future<void> generateAndShare({
    required Business business,
    required Customer customer,
    required Template template,
    required Invoice invoice,
    required List<InvoiceItem> items,
    required Map<String, dynamic> customData,
    required List<Payment> payments,
    required List<PaymentSchedule> schedules,
  }) async {
    final file = await generateInvoicePdf(
      business: business,
      customer: customer,
      template: template,
      invoice: invoice,
      items: items,
      customData: customData,
      payments: payments,
      schedules: schedules,
    );

    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Invoice ${invoice.number}',
    );
  }

  Future<void> shareExistingFile(File file, String invoiceNumber) async {
    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Invoice $invoiceNumber',
    );
  }

  Future<pw.MemoryImage?> _loadLogo(String? path) async {
    if (path == null || path.isEmpty) return null;
    final file = File(path);
    if (!await file.exists()) return null;
    final bytes = await file.readAsBytes();
    return pw.MemoryImage(bytes);
  }

  Future<pw.MemoryImage?> loadLogoFromPaths(String? templateLogoPath, String? businessLogoPath) async {
    final logo = await _loadLogo(templateLogoPath);
    if (logo != null) return logo;
    return _loadLogo(businessLogoPath);
  }

  pw.Widget _buildHeader(Business business, pw.MemoryImage? logo) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            if (logo != null)
              pw.Container(
                width: 72,
                height: 72,
                margin: const pw.EdgeInsets.only(right: 12),
                child: pw.Image(logo, fit: pw.BoxFit.contain),
              ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(business.name, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 4),
                pw.Text(business.address),
                pw.Text(business.phone),
                pw.Text(business.email),
              ],
            ),
          ],
        ),
        pw.Text('INVOICE', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
      ],
    );
  }

  pw.Widget _buildMetaCustomerRow(Invoice invoice, Customer customer) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Invoice No: ${invoice.number}'),
            pw.Text('Date: ${_date.format(invoice.date)}'),
            pw.Text('Due: ${invoice.dueDate == null ? '-' : _date.format(invoice.dueDate!)}'),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Bill To', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(customer.name),
            if ((customer.address ?? '').isNotEmpty) pw.Text(customer.address!),
            if ((customer.email ?? '').isNotEmpty) pw.Text(customer.email!),
            if ((customer.whatsapp ?? '').isNotEmpty) pw.Text(customer.whatsapp!),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildItemsTable(List<InvoiceItem> items) {
    final headers = ['Item', 'Qty', 'Unit', 'Price', 'Discount', 'Total'];
    final data = items.map((item) {
      final total = (item.qty * item.price) - item.discount;
      return [
        item.name,
        item.qty.toStringAsFixed(2),
        item.unit,
        _currency.format(item.price),
        _currency.format(item.discount),
        _currency.format(total),
      ];
    }).toList();

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      cellStyle: const pw.TextStyle(fontSize: 10),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
      cellAlignment: pw.Alignment.centerLeft,
      columnWidths: {
        0: const pw.FlexColumnWidth(3),
        1: const pw.FlexColumnWidth(1),
        2: const pw.FlexColumnWidth(1),
        3: const pw.FlexColumnWidth(2),
        4: const pw.FlexColumnWidth(2),
        5: const pw.FlexColumnWidth(2),
      },
    );
  }

  pw.Widget _buildSummary(Invoice invoice) {
    return pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.Container(
        width: 220,
        padding: const pw.EdgeInsets.all(8),
        decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey400)),
        child: pw.Column(
          children: [
            _summaryRow('Subtotal', invoice.subtotal),
            _summaryRow('Discount', invoice.discount),
            _summaryRow('Tax', invoice.tax),
            _summaryRow('Shipping', invoice.shipping),
            pw.Divider(),
            _summaryRow('Grand Total', invoice.grandTotal, isBold: true),
          ],
        ),
      ),
    );
  }

  pw.Widget _buildPaymentInfo(List<Payment> payments, List<PaymentSchedule> schedules) {
    final List<pw.Widget> rows = [];
    if (payments.isEmpty && schedules.isEmpty) {
      rows.add(pw.Text('No payment data', style: const pw.TextStyle(fontSize: 10)));
    }
    if (payments.isNotEmpty) {
      rows.add(pw.Text('Payments', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)));
      for (final payment in payments) {
        rows.add(
          pw.Text(
            '${payment.type.toUpperCase()} - ${_currency.format(payment.amount)} (${_date.format(payment.paidAt)})',
            style: const pw.TextStyle(fontSize: 10),
          ),
        );
      }
    }
    if (schedules.isNotEmpty) {
      rows.add(pw.SizedBox(height: 4));
      rows.add(pw.Text('Termin Schedule', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)));
      for (final schedule in schedules) {
        rows.add(
          pw.Text(
            '${schedule.title}: ${_date.format(schedule.dueDate)} - ${_currency.format(schedule.amount)}',
            style: const pw.TextStyle(fontSize: 10),
          ),
        );
      }
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionTitle('Payment Info'),
        pw.SizedBox(height: 6),
        ...rows,
      ],
    );
  }

  pw.Widget _sectionTitle(String text) {
    return pw.Text(text, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold));
  }

  pw.Widget _summaryRow(String label, double value, {bool isBold = false}) {
    final style = pw.TextStyle(fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal);
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label, style: style),
        pw.Text(_currency.format(value), style: style),
      ],
    );
  }

  List<List<String>> _buildCustomRows(TemplateSchema schema, Map<String, dynamic> customData) {
    final rows = <List<String>>[];
    for (final section in schema.sections) {
      for (final field in section.fields) {
        if (!field.showOnPdf) continue;
        final value = _formatCustomValue(customData[field.key]);
        if (value.isEmpty) continue;
        rows.add([field.label, value]);
      }
    }
    return rows;
  }

  pw.Widget _buildKeyValueTable(List<List<String>> rows) {
    return pw.TableHelper.fromTextArray(
      headers: const ['Field', 'Value'],
      data: rows,
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      cellStyle: const pw.TextStyle(fontSize: 10),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
      cellAlignment: pw.Alignment.centerLeft,
      columnWidths: {
        0: const pw.FlexColumnWidth(2),
        1: const pw.FlexColumnWidth(3),
      },
    );
  }

  String _formatCustomValue(dynamic value) {
    if (value == null) return '';
    if (value is Map && value.containsKey('start') && value.containsKey('end')) {
      return '${value['start']} - ${value['end']}';
    }
    if (value is bool) return value ? 'Yes' : 'No';
    return value.toString();
  }

  String _sanitizeFileName(String name) {
    return name.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
  }
}
