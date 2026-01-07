
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:invoice/core/widgets/neon_card.dart';
import 'package:invoice/core/widgets/neon_text_field.dart';
import 'package:invoice/core/widgets/neon_button.dart';
import 'package:invoice/application/providers/providers.dart';
import 'package:invoice/domain/entities/invoice.dart';
import 'package:invoice/domain/entities/business.dart';
import 'package:invoice/domain/entities/customer.dart';
import 'package:invoice/domain/entities/catalog_item.dart';
import 'package:invoice/domain/entities/template.dart';
import 'package:invoice/services/pdf_invoice_service.dart';
import 'package:invoice/utils/invoice_number_generator.dart';
import 'package:invoice/utils/template_schema.dart';
import 'package:invoice/presentation/utils/pro_access_guard.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

final customersProviderCreate = FutureProvider.autoDispose((ref) async {
  final repo = ref.read(customerRepositoryProvider);
  return await repo.getAllCustomers();
});

final catalogItemsProviderCreate = FutureProvider.autoDispose((ref) async {
  final repo = ref.read(catalogRepositoryProvider);
  return await repo.getAllItems();
});

final templatesProviderCreate = FutureProvider.autoDispose((ref) async {
  final repo = ref.read(templateRepositoryProvider);
  return await repo.getAllTemplates();
});

class InvoiceCreateScreen extends ConsumerStatefulWidget {
  const InvoiceCreateScreen({super.key});

  @override
  ConsumerState<InvoiceCreateScreen> createState() => _InvoiceCreateScreenState();
}

class _InvoiceCreateScreenState extends ConsumerState<InvoiceCreateScreen> {
  int _currentStep = 0;
  Template? _selectedTemplate;
  Customer? _selectedCustomer;
  TemplateSchema _schema = TemplateSchema(sections: []);
  final Map<String, TextEditingController> _fieldControllers = {};
  final Map<String, DateTime?> _dateValues = {};
  final Map<String, DateTimeRange?> _dateRangeValues = {};
  final Map<String, bool> _checkboxValues = {};
  final Map<String, String?> _dropdownValues = {};

  final List<InvoiceLineItem> _lineItems = [];
  final _notesCtrl = TextEditingController();
  final _termsCtrl = TextEditingController();
  final _discountCtrl = TextEditingController(text: '0');
  final _taxCtrl = TextEditingController(text: '0');
  final _shippingCtrl = TextEditingController(text: '0');
  final _dpValueCtrl = TextEditingController();
  DateTime _invoiceDate = DateTime.now();
  DateTime? _dueDate;
  String _paymentMode = 'lunas';
  String _dpType = 'nominal';
  bool _autoShareAfterSave = false;
  final List<PaymentScheduleDraft> _scheduleDrafts = [];
  Uint8List? _pdfBytesCache;
  String? _previewPdfPath;
  String? _previewInvoiceNumber;
  bool _pdfBusy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureAccessOnOpen());
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    _termsCtrl.dispose();
    _discountCtrl.dispose();
    _taxCtrl.dispose();
    _shippingCtrl.dispose();
    _dpValueCtrl.dispose();
    for (final ctrl in _fieldControllers.values) {
      ctrl.dispose();
    }
    super.dispose();
  }

  Future<void> _ensureAccessOnOpen() async {
    final allowed = await ensureProForInvoiceCreation(
      context: context,
      ref: ref,
    );
    if (!allowed && mounted) {
      context.pop();
    }
  }

  double _calculateSubtotal() {
    return _lineItems.fold<double>(0, (sum, item) => sum + item.lineTotal);
  }

  double _calculateGrandTotal() {
    final subtotal = _calculateSubtotal();
    final discount = double.tryParse(_discountCtrl.text) ?? 0;
    final tax = double.tryParse(_taxCtrl.text) ?? 0;
    final shipping = double.tryParse(_shippingCtrl.text) ?? 0;
    return subtotal - discount + tax + shipping;
  }

  Future<Uint8List> _generatePdfBytesOnce() async {
    if (_pdfBytesCache != null) return _pdfBytesCache!;
    if (_selectedCustomer == null || _selectedTemplate == null) {
      throw Exception('Select customer and template first');
    }

    if (mounted) setState(() => _pdfBusy = true);
    try {
      final businessRepo = ref.read(businessRepositoryProvider);
      final business = await businessRepo.getOrCreateBusiness();
      final previewNumber = _previewInvoiceNumber ?? _buildPreviewNumber(business);
      _previewInvoiceNumber = previewNumber;

      final subtotal = _calculateSubtotal();
      final discount = double.tryParse(_discountCtrl.text) ?? 0;
      final tax = double.tryParse(_taxCtrl.text) ?? 0;
      final shipping = double.tryParse(_shippingCtrl.text) ?? 0;
      final grandTotal = subtotal - discount + tax + shipping;
      final customData = _collectCustomData();

      final invoice = Invoice(
        businessId: business.id ?? 1,
        customerId: _selectedCustomer!.id ?? 1,
        templateId: _selectedTemplate!.id ?? 1,
        number: previewNumber,
        date: _invoiceDate,
        dueDate: _dueDate,
        status: 'draft',
        subtotal: subtotal,
        discount: discount,
        tax: tax,
        shipping: shipping,
        grandTotal: grandTotal,
        notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
        terms: _termsCtrl.text.trim().isEmpty ? null : _termsCtrl.text.trim(),
        customDataJson: jsonEncode(customData),
      );

      final items = _lineItems
          .map(
            (item) => InvoiceItem(
              invoiceId: 0,
              name: item.name,
              qty: item.qty,
              unit: item.unit,
              price: item.price,
              discount: item.discount,
              note: item.note,
            ),
          )
          .toList();

      final payments = <Payment>[];
      if (_paymentMode == 'lunas') {
        payments.add(Payment(
          invoiceId: 0,
          type: 'lunas',
          method: 'other',
          amount: grandTotal,
          paidAt: DateTime.now(),
        ));
      }
      if (_paymentMode == 'dp') {
        final dpValue = double.tryParse(_dpValueCtrl.text) ?? 0;
        final dpAmount = _dpType == 'percent' ? (grandTotal * (dpValue / 100)) : dpValue;
        if (dpAmount > 0) {
          payments.add(Payment(
            invoiceId: 0,
            type: 'dp',
            method: 'other',
            amount: dpAmount,
            paidAt: DateTime.now(),
          ));
        }
      }

      final schedules = _scheduleDrafts
          .map(
            (s) => PaymentSchedule(
              invoiceId: 0,
              title: s.title,
              dueDate: s.dueDate,
              amount: s.amount,
              isPaid: false,
            ),
          )
          .toList();

      final pdfService = PdfInvoiceService();
      _pdfBytesCache = await pdfService.generateInvoicePdfBytes(
        business: business,
        customer: _selectedCustomer!,
        template: _selectedTemplate!,
        invoice: invoice,
        items: items,
        customData: customData,
        payments: payments,
        schedules: schedules,
      );
      return _pdfBytesCache!;
    } finally {
      if (mounted) setState(() => _pdfBusy = false);
    }
  }

  String _buildPreviewNumber(Business business) {
    final prefix = business.invoicePrefix ?? 'INV';
    final year = DateTime.now().year;
    return '$prefix-$year-PREVIEW';
  }

  Future<File> _ensurePdfFile() async {
    if (_previewPdfPath != null) {
      final existing = File(_previewPdfPath!);
      if (await existing.exists()) return existing;
    }
    final bytes = await _generatePdfBytesOnce();
    final dir = await getApplicationDocumentsDirectory();
    final number = _previewInvoiceNumber ?? 'invoice_preview';
    final fileName = _sanitizeFileName('$number.pdf');
    final file = File(p.join(dir.path, fileName));
    await file.writeAsBytes(bytes);
    _previewPdfPath = file.path;
    return file;
  }

  String _sanitizeFileName(String name) {
    return name.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
  }

  void _resetCustomFields(Template template) {
    for (final ctrl in _fieldControllers.values) {
      ctrl.dispose();
    }
    _fieldControllers.clear();
    _dateValues.clear();
    _dateRangeValues.clear();
    _checkboxValues.clear();
    _dropdownValues.clear();
    _schema = TemplateSchema.fromJson(template.schemaJson);
    for (final section in _schema.sections) {
      for (final field in section.fields) {
        if (_isTextType(field.type)) {
          _fieldControllers[field.key] = TextEditingController();
        } else if (field.type == 'checkbox') {
          _checkboxValues[field.key] = false;
        } else if (field.type == 'dropdown') {
          _dropdownValues[field.key] = field.options?.isNotEmpty == true ? field.options!.first : null;
        } else if (field.type == 'date') {
          _dateValues[field.key] = null;
        } else if (field.type == 'dateRange') {
          _dateRangeValues[field.key] = null;
        }
      }
    }
  }

  bool _isTextType(String type) {
    return type == 'text' || type == 'multiline' || type == 'number' || type == 'currency';
  }

  Map<String, dynamic> _collectCustomData() {
    final Map<String, dynamic> data = {};
    for (final section in _schema.sections) {
      for (final field in section.fields) {
        if (_isTextType(field.type)) {
          data[field.key] = _fieldControllers[field.key]?.text.trim();
        } else if (field.type == 'dropdown') {
          data[field.key] = _dropdownValues[field.key];
        } else if (field.type == 'checkbox') {
          data[field.key] = _checkboxValues[field.key] ?? false;
        } else if (field.type == 'date') {
          final date = _dateValues[field.key];
          data[field.key] = date == null ? null : DateFormat('yyyy-MM-dd').format(date);
        } else if (field.type == 'dateRange') {
          final range = _dateRangeValues[field.key];
          data[field.key] = range == null
              ? null
              : {
                  'start': DateFormat('yyyy-MM-dd').format(range.start),
                  'end': DateFormat('yyyy-MM-dd').format(range.end),
                };
        }
      }
    }
    return data;
  }
  void _addLineItemDialog(List<CatalogItem> catalogItems) {
    CatalogItem? selectedItem;
    final qtyCtrl = TextEditingController(text: '1');
    final priceCtrl = TextEditingController();
    final nameCtrl = TextEditingController();
    final unitCtrl = TextEditingController();
    final discountCtrl = TextEditingController(text: '0');
    final noteCtrl = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Line Item'),
        content: StatefulBuilder(
          builder: (ctx, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<CatalogItem>(
                value: selectedItem,
                hint: const Text('Select catalog item (optional)'),
                items: catalogItems.map((item) => DropdownMenuItem(value: item, child: Text(item.name))).toList(),
                onChanged: (item) {
                  setState(() {
                    selectedItem = item;
                    nameCtrl.text = item?.name ?? '';
                    unitCtrl.text = item?.unit ?? '';
                    priceCtrl.text = item?.price.toString() ?? '';
                  });
                },
              ),
              const SizedBox(height: 12),
              NeonTextField(
                label: 'Item Name',
                controller: nameCtrl,
              ),
              const SizedBox(height: 12),
              NeonTextField(
                label: 'Quantity',
                controller: qtyCtrl,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              NeonTextField(
                label: 'Unit',
                controller: unitCtrl,
              ),
              const SizedBox(height: 12),
              NeonTextField(
                label: 'Price',
                controller: priceCtrl,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              NeonTextField(
                label: 'Discount',
                controller: discountCtrl,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              NeonTextField(
                label: 'Note',
                controller: noteCtrl,
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final name = nameCtrl.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item name required')));
                return;
              }
              final qty = double.tryParse(qtyCtrl.text) ?? 1;
              final price = double.tryParse(priceCtrl.text) ?? 0;
              final discount = double.tryParse(discountCtrl.text) ?? 0;
              setState(() {
                _lineItems.add(InvoiceLineItem(
                  name: name,
                  qty: qty,
                  unit: unitCtrl.text.trim().isEmpty ? '-' : unitCtrl.text.trim(),
                  price: price,
                  discount: discount,
                  note: noteCtrl.text.trim().isEmpty ? null : noteCtrl.text.trim(),
                ));
              });
              Navigator.of(ctx).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  bool _validateStep1() {
    if (_selectedTemplate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select a template')));
      return false;
    }
    if (_selectedCustomer == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select a customer')));
      return false;
    }
    for (final section in _schema.sections) {
      for (final field in section.fields) {
        if (!field.required) continue;
        if (_isTextType(field.type)) {
          final value = _fieldControllers[field.key]?.text.trim() ?? '';
          if (value.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Required: ${field.label}')));
            return false;
          }
        } else if (field.type == 'dropdown') {
          if ((_dropdownValues[field.key] ?? '').isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Required: ${field.label}')));
            return false;
          }
        } else if (field.type == 'checkbox') {
          if (_checkboxValues[field.key] != true) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Required: ${field.label}')));
            return false;
          }
        } else if (field.type == 'date') {
          if (_dateValues[field.key] == null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Required: ${field.label}')));
            return false;
          }
        } else if (field.type == 'dateRange') {
          if (_dateRangeValues[field.key] == null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Required: ${field.label}')));
            return false;
          }
        }
      }
    }
    return true;
  }

  bool _validateStep2() {
    if (_lineItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add at least one line item')));
      return false;
    }
    return true;
  }

  bool _validateStep3() {
    if (_paymentMode == 'dp') {
      final dpValue = double.tryParse(_dpValueCtrl.text) ?? 0;
      if (dpValue <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter DP amount or percent')));
        return false;
      }
    }
    if (_paymentMode == 'termin' && _scheduleDrafts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add at least one termin schedule')));
      return false;
    }
    return true;
  }

  void _onStepContinue() {
    if (_currentStep == 0) {
      if (_validateStep1()) {
        setState(() => _currentStep = 1);
      }
      return;
    }
    if (_currentStep == 1) {
      if (_validateStep2()) {
        setState(() => _currentStep = 2);
      }
      return;
    }
    if (_currentStep == 2) {
      if (_validateStep3()) {
        _save();
      }
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    }
  }
  void _addScheduleDialog() {
    final titleCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    DateTime dueDate = DateTime.now().add(const Duration(days: 30));

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Termin Schedule'),
        content: StatefulBuilder(
          builder: (ctx, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NeonTextField(label: 'Title', controller: titleCtrl),
              const SizedBox(height: 12),
              NeonTextField(label: 'Amount', controller: amountCtrl, keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: ctx,
                    initialDate: dueDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now().add(const Duration(days: 3650)),
                  );
                  if (picked != null) setState(() => dueDate = picked);
                },
                child: Text(DateFormat('dd MMM yyyy').format(dueDate)),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final title = titleCtrl.text.trim().isEmpty ? 'Termin ${_scheduleDrafts.length + 1}' : titleCtrl.text.trim();
              final amount = double.tryParse(amountCtrl.text) ?? 0;
              if (amount <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Amount required')));
                return;
              }
              setState(() {
                _scheduleDrafts.add(PaymentScheduleDraft(title: title, dueDate: dueDate, amount: amount));
              });
              Navigator.of(ctx).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomFields() {
    if (_schema.sections.isEmpty) {
      return const Text('No custom fields defined for this template.');
    }
    return Column(
      children: _schema.sections.map((section) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: NeonCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(section.title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                ...section.fields.map(_buildFieldInput),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFieldInput(SchemaField field) {
    if (_isTextType(field.type)) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: NeonTextField(
          controller: _fieldControllers[field.key],
          label: '${field.label}${field.required ? ' *' : ''}',
          maxLines: field.type == 'multiline' ? 3 : 1,
          keyboardType: (field.type == 'number' || field.type == 'currency') ? TextInputType.number : TextInputType.text,
        ),
      );
    }
    if (field.type == 'dropdown') {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(field.label, style: Theme.of(context).textTheme.labelMedium),
            DropdownButton<String>(
              isExpanded: true,
              value: _dropdownValues[field.key],
              items: (field.options ?? [])
                  .map((opt) => DropdownMenuItem<String>(value: opt, child: Text(opt)))
                  .toList(),
              onChanged: (v) => setState(() => _dropdownValues[field.key] = v),
            ),
          ],
        ),
      );
    }
    if (field.type == 'checkbox') {
      return CheckboxListTile(
        title: Text(field.label),
        value: _checkboxValues[field.key] ?? false,
        onChanged: (v) => setState(() => _checkboxValues[field.key] = v ?? false),
      );
    }
    if (field.type == 'date') {
      final date = _dateValues[field.key];
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(field.label, style: Theme.of(context).textTheme.labelMedium),
            TextButton(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: date ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now().add(const Duration(days: 3650)),
                );
                if (picked != null) setState(() => _dateValues[field.key] = picked);
              },
              child: Text(date == null ? 'Select date' : DateFormat('dd MMM yyyy').format(date)),
            ),
          ],
        ),
      );
    }
    if (field.type == 'dateRange') {
      final range = _dateRangeValues[field.key];
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(field.label, style: Theme.of(context).textTheme.labelMedium),
            TextButton(
              onPressed: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now().add(const Duration(days: 3650)),
                  initialDateRange: range,
                );
                if (picked != null) setState(() => _dateRangeValues[field.key] = picked);
              },
              child: Text(
                range == null
                    ? 'Select date range'
                    : '${DateFormat('dd MMM yyyy').format(range.start)} - ${DateFormat('dd MMM yyyy').format(range.end)}',
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Future<void> _save() async {
    final allowed = await ensureProForInvoiceCreation(
      context: context,
      ref: ref,
    );
    if (!allowed) return;

    if (_selectedCustomer == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select a customer')));
      return;
    }

    final businessRepo = ref.read(businessRepositoryProvider);
    final invoiceRepo = ref.read(invoiceRepositoryProvider);
    final business = await businessRepo.getOrCreateBusiness();

    final invoiceNumber = InvoiceNumberGenerator.generateNumber(business);
    await businessRepo.updateBusiness(business);

    final subtotal = _calculateSubtotal();
    final discount = double.tryParse(_discountCtrl.text) ?? 0;
    final tax = double.tryParse(_taxCtrl.text) ?? 0;
    final shipping = double.tryParse(_shippingCtrl.text) ?? 0;
    final grandTotal = subtotal - discount + tax + shipping;
    final customData = _collectCustomData();
    String status = 'draft';
    if (_paymentMode == 'lunas') status = 'paid';
    if (_paymentMode == 'dp') status = 'partial_paid';
    if (_paymentMode == 'termin') status = 'sent';

    final invoice = Invoice(
      businessId: business.id ?? 1,
      customerId: _selectedCustomer!.id ?? 1,
      templateId: _selectedTemplate?.id ?? 1,
      number: invoiceNumber,
      date: _invoiceDate,
      dueDate: _dueDate,
      status: status,
      subtotal: subtotal,
      discount: discount,
      tax: tax,
      shipping: shipping,
      grandTotal: grandTotal,
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      terms: _termsCtrl.text.trim().isEmpty ? null : _termsCtrl.text.trim(),
      customDataJson: jsonEncode(customData),
    );

    await invoiceRepo.createInvoice(invoice);

    final invoiceItemsForPdf = <InvoiceItem>[];
    for (final item in _lineItems) {
      final invItem = InvoiceItem(
        invoiceId: invoice.id ?? 1,
        name: item.name,
        qty: item.qty,
        unit: item.unit,
        price: item.price,
        discount: item.discount,
        note: item.note,
      );
      invoiceItemsForPdf.add(invItem);
      await invoiceRepo.addInvoiceItem(invItem);
    }

    final paymentsToSave = <Payment>[];
    final schedulesToSave = <PaymentSchedule>[];
    if (_paymentMode == 'lunas') {
      paymentsToSave.add(Payment(
        invoiceId: invoice.id ?? 1,
        type: 'lunas',
        method: 'other',
        amount: grandTotal,
        paidAt: DateTime.now(),
      ));
    }
    if (_paymentMode == 'dp') {
      final dpValue = double.tryParse(_dpValueCtrl.text) ?? 0;
      final dpAmount = _dpType == 'percent' ? (grandTotal * (dpValue / 100)) : dpValue;
      paymentsToSave.add(Payment(
        invoiceId: invoice.id ?? 1,
        type: 'dp',
        method: 'other',
        amount: dpAmount,
        paidAt: DateTime.now(),
      ));
    }
    if (_paymentMode == 'termin') {
      for (final schedule in _scheduleDrafts) {
        schedulesToSave.add(PaymentSchedule(
          invoiceId: invoice.id ?? 1,
          title: schedule.title,
          dueDate: schedule.dueDate,
          amount: schedule.amount,
          isPaid: false,
        ));
      }
    }

    for (final payment in paymentsToSave) {
      await invoiceRepo.addPayment(payment);
    }
    for (final schedule in schedulesToSave) {
      await invoiceRepo.addPaymentSchedule(schedule);
    }

    if (_selectedTemplate != null) {
      final pdfService = PdfInvoiceService();
      final file = await pdfService.generateInvoicePdf(
        business: business,
        customer: _selectedCustomer!,
        template: _selectedTemplate!,
        invoice: invoice,
        items: invoiceItemsForPdf,
        customData: customData,
        payments: paymentsToSave,
        schedules: schedulesToSave,
      );
      invoice.pdfPath = file.path;
      await invoiceRepo.updateInvoice(invoice);
      if (_autoShareAfterSave) {
        await pdfService.shareExistingFile(file, invoice.number);
      }
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invoice created')));
    context.pop();
  }
  @override
  Widget build(BuildContext context) {
    final customersAsync = ref.watch(customersProviderCreate);
    final catalogAsync = ref.watch(catalogItemsProviderCreate);
    final templatesAsync = ref.watch(templatesProviderCreate);

    return Scaffold(
      appBar: AppBar(title: const Text('Create Invoice')),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: _onStepContinue,
        onStepCancel: _onStepCancel,
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: NeonButton(
                      label: 'Back',
                      onPressed: details.onStepCancel ?? () {},
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 12),
                Expanded(
                  child: NeonButton(
                    label: _currentStep == 2 ? 'Save Invoice' : 'Next',
                    onPressed: details.onStepContinue ?? () {},
                  ),
                ),
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text('Template & Customer'),
            isActive: _currentStep >= 0,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Invoice Details', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 12),
                NeonCard(
                  child: Column(
                    children: [
                      templatesAsync.when(
                        data: (templates) => DropdownButton<Template>(
                          isExpanded: true,
                          value: _selectedTemplate,
                          hint: const Text('Select Template'),
                          items: templates.map((t) => DropdownMenuItem(value: t, child: Text(t.name))).toList(),
                          onChanged: (t) {
                            if (t == null) return;
                            setState(() {
                              _selectedTemplate = t;
                              _resetCustomFields(t);
                            });
                          },
                        ),
                        loading: () => const CircularProgressIndicator(),
                        error: (e, st) => Text('Error: $e'),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Date', style: Theme.of(context).textTheme.labelMedium),
                                TextButton(
                                  onPressed: () async {
                                    final picked = await showDatePicker(
                                      context: context,
                                      initialDate: _invoiceDate,
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime.now().add(const Duration(days: 3650)),
                                    );
                                    if (picked != null) setState(() => _invoiceDate = picked);
                                  },
                                  child: Text(DateFormat('dd MMM yyyy').format(_invoiceDate)),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Due Date', style: Theme.of(context).textTheme.labelMedium),
                                TextButton(
                                  onPressed: () async {
                                    final picked = await showDatePicker(
                                      context: context,
                                      initialDate: _dueDate ?? DateTime.now().add(const Duration(days: 30)),
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime.now().add(const Duration(days: 3650)),
                                    );
                                    if (picked != null) setState(() => _dueDate = picked);
                                  },
                                  child: Text(_dueDate == null ? 'Not set' : DateFormat('dd MMM yyyy').format(_dueDate!)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      customersAsync.when(
                        data: (customers) => DropdownButton<Customer>(
                          isExpanded: true,
                          value: _selectedCustomer,
                          hint: const Text('Select Customer'),
                          items: customers.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
                          onChanged: (c) => setState(() => _selectedCustomer = c),
                        ),
                        loading: () => const CircularProgressIndicator(),
                        error: (e, st) => Text('Error: $e'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text('Template Fields', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                _buildCustomFields(),
              ],
            ),
          ),
          Step(
            title: const Text('Items'),
            isActive: _currentStep >= 1,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Line Items', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 12),
                catalogAsync.when(
                  data: (items) => NeonButton(
                    label: 'Add Item',
                    onPressed: () => _addLineItemDialog(items),
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (e, st) => Text('Error: $e'),
                ),
                const SizedBox(height: 12),
                if (_lineItems.isNotEmpty)
                  Column(
                    children: [
                      ..._lineItems.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Expanded(child: Text('${item.name} x ${item.qty.toStringAsFixed(2)} ${item.unit}')),
                              Text(item.lineTotal.toStringAsFixed(2), style: Theme.of(context).textTheme.titleSmall),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => setState(() => _lineItems.remove(item)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(),
                      const SizedBox(height: 12),
                    ],
                  ),
                const SizedBox(height: 16),
                Text('Summary', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 12),
                NeonCard(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtotal:'),
                          Text(_calculateSubtotal().toStringAsFixed(2)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(child: NeonTextField(label: 'Discount', controller: _discountCtrl, keyboardType: TextInputType.number)),
                          const SizedBox(width: 8),
                          Expanded(child: NeonTextField(label: 'Tax', controller: _taxCtrl, keyboardType: TextInputType.number)),
                          const SizedBox(width: 8),
                          Expanded(child: NeonTextField(label: 'Shipping', controller: _shippingCtrl, keyboardType: TextInputType.number)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Grand Total:', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            _calculateGrandTotal().toStringAsFixed(2),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                NeonTextField(label: 'Notes', controller: _notesCtrl, maxLines: 3),
                const SizedBox(height: 12),
                NeonTextField(label: 'Terms', controller: _termsCtrl, maxLines: 3),
              ],
            ),
          ),
          Step(
            title: const Text('Payment'),
            isActive: _currentStep >= 2,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Payment Mode', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                RadioListTile<String>(
                  title: const Text('Lunas'),
                  value: 'lunas',
                  groupValue: _paymentMode,
                  onChanged: (v) => setState(() => _paymentMode = v ?? 'lunas'),
                ),
                RadioListTile<String>(
                  title: const Text('DP'),
                  value: 'dp',
                  groupValue: _paymentMode,
                  onChanged: (v) => setState(() => _paymentMode = v ?? 'dp'),
                ),
                RadioListTile<String>(
                  title: const Text('Termin'),
                  value: 'termin',
                  groupValue: _paymentMode,
                  onChanged: (v) => setState(() => _paymentMode = v ?? 'termin'),
                ),
                if (_paymentMode == 'dp') ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _dpType,
                          items: const [
                            DropdownMenuItem(value: 'nominal', child: Text('Nominal')),
                            DropdownMenuItem(value: 'percent', child: Text('Percent')),
                          ],
                          onChanged: (v) => setState(() => _dpType = v ?? 'nominal'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: NeonTextField(
                          label: _dpType == 'percent' ? 'DP %' : 'DP Amount',
                          controller: _dpValueCtrl,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ],
                if (_paymentMode == 'termin') ...[
                  const SizedBox(height: 12),
                  NeonButton(label: 'Add Termin', onPressed: _addScheduleDialog),
                  const SizedBox(height: 12),
                  ..._scheduleDrafts.map((s) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(child: Text('${s.title} - ${DateFormat('dd MMM yyyy').format(s.dueDate)}')),
                            Text(s.amount.toStringAsFixed(2)),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => setState(() => _scheduleDrafts.remove(s)),
                            ),
                          ],
                        ),
                      )),
                ],
                CheckboxListTile(
                  title: const Text('Auto share after save'),
                  value: _autoShareAfterSave,
                  onChanged: (v) => setState(() => _autoShareAfterSave = v ?? false),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    SizedBox(
                      width: 150,
                      child: NeonButton(
                        label: 'Preview PDF',
                        isLoading: _pdfBusy,
                        onPressed: () async {
                          try {
                            final bytes = await _generatePdfBytesOnce();
                            await Printing.layoutPdf(onLayout: (_) async => bytes);
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Preview failed: $e')));
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: NeonButton(
                        label: 'Print',
                        isLoading: _pdfBusy,
                        onPressed: () async {
                          try {
                            final bytes = await _generatePdfBytesOnce();
                            await Printing.layoutPdf(onLayout: (_) async => bytes);
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Print failed: $e')));
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: 160,
                      child: NeonButton(
                        label: 'Share PDF',
                        isLoading: _pdfBusy,
                        onPressed: () async {
                          try {
                            final file = await _ensurePdfFile();
                            await Share.shareXFiles([XFile(file.path)], text: 'Invoice ${_previewInvoiceNumber ?? ''}'.trim());
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Share failed: $e')));
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Invoice Summary', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                NeonCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Template: ${_selectedTemplate?.name ?? '-'}'),
                      Text('Customer: ${_selectedCustomer?.name ?? '-'}'),
                      const SizedBox(height: 8),
                      Text('Items: ${_lineItems.length}'),
                      Text('Subtotal: ${_calculateSubtotal().toStringAsFixed(2)}'),
                      Text('Grand Total: ${_calculateGrandTotal().toStringAsFixed(2)}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InvoiceLineItem {
  final String name;
  final double qty;
  final String unit;
  final double price;
  final double discount;
  final String? note;

  InvoiceLineItem({
    required this.name,
    required this.qty,
    required this.unit,
    required this.price,
    this.discount = 0,
    this.note,
  });

  double get lineTotal => (qty * price) - discount;
}

class PaymentScheduleDraft {
  final String title;
  final DateTime dueDate;
  final double amount;

  PaymentScheduleDraft({required this.title, required this.dueDate, required this.amount});
}
