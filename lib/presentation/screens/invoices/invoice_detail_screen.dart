import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice/application/providers/providers.dart';
import 'package:invoice/core/constants/app_colors.dart';
import 'package:invoice/core/widgets/neon_card.dart';
import 'package:invoice/core/widgets/neon_button.dart';
import 'package:invoice/core/widgets/neon_text_field.dart';
import 'package:invoice/core/widgets/status_badge.dart';
import 'package:invoice/domain/entities/customer.dart';
import 'package:invoice/domain/entities/invoice.dart';
import 'package:invoice/domain/entities/template.dart';
import 'package:invoice/services/pdf_invoice_service.dart';
import 'package:invoice/utils/invoice_number_generator.dart';
import 'package:invoice/utils/template_schema.dart';
import 'package:intl/intl.dart';

final invoiceDetailProvider = FutureProvider.autoDispose.family<InvoiceDetailData?, int>((ref, id) async {
  final invoiceRepo = ref.read(invoiceRepositoryProvider);
  final customerRepo = ref.read(customerRepositoryProvider);
  final templateRepo = ref.read(templateRepositoryProvider);

  final invoice = await invoiceRepo.getInvoiceById(id);
  if (invoice == null) return null;

  final customer = await customerRepo.getCustomerById(invoice.customerId);
  final template = await templateRepo.getTemplateById(invoice.templateId);
  final items = await invoiceRepo.getInvoiceItems(id);
  final payments = await invoiceRepo.getInvoicePayments(id);
  final schedules = await invoiceRepo.getPaymentSchedules(id);
  final totalPaid = payments.fold<double>(0, (sum, p) => sum + p.amount);
  final status = _deriveStatus(invoice, totalPaid);
  final customData = _parseCustomData(invoice.customDataJson);

  return InvoiceDetailData(
    invoice: invoice,
    customer: customer,
    template: template,
    items: items,
    payments: payments,
    schedules: schedules,
    totalPaid: totalPaid,
    status: status,
    customData: customData,
  );
});

class InvoiceDetailScreen extends ConsumerWidget {
  final int invoiceId;

  const InvoiceDetailScreen({super.key, required this.invoiceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(invoiceDetailProvider(invoiceId));

    return Scaffold(
      appBar: AppBar(title: const Text('Invoice Detail')),
      body: detailAsync.when(
        data: (data) {
          if (data == null) {
            return const Center(child: Text('Invoice not found'));
          }
          final invoice = data.invoice;
          final customer = data.customer;
          final template = data.template;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NeonCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(invoice.number, style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 6),
                            Text('Date: ${DateFormat('dd MMM yyyy').format(invoice.date)}'),
                            Text('Due: ${invoice.dueDate == null ? '-' : DateFormat('dd MMM yyyy').format(invoice.dueDate!)}'),
                            const SizedBox(height: 6),
                            Text('Grand Total: ${invoice.grandTotal.toStringAsFixed(2)}'),
                          ],
                        ),
                      ),
                      StatusBadge(status: data.status),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _buildActionRow(context, ref, data),
                const SizedBox(height: 16),
                NeonCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Customer', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text(customer?.name ?? 'Unknown Customer'),
                      if ((customer?.address ?? '').isNotEmpty) Text(customer!.address!),
                      if ((customer?.email ?? '').isNotEmpty) Text(customer!.email!),
                      if ((customer?.whatsapp ?? '').isNotEmpty) Text(customer!.whatsapp!),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildCustomFieldsSection(context, template, data.customData),
                const SizedBox(height: 16),
                _buildItemsSection(context, data.items),
                const SizedBox(height: 16),
                _buildPaymentsSection(context, data.payments, data.totalPaid, invoice.grandTotal),
                const SizedBox(height: 16),
                _buildSchedulesSection(context, data.schedules),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildActionRow(BuildContext context, WidgetRef ref, InvoiceDetailData data) {
    final pdfExists = data.invoice.pdfPath != null && File(data.invoice.pdfPath!).existsSync();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        SizedBox(
          width: 160,
          child: NeonButton(
            label: pdfExists ? 'Share PDF' : 'Regenerate PDF',
            onPressed: () => _sharePdf(context, ref, data),
          ),
        ),
        SizedBox(
          width: 160,
          child: NeonButton(
            label: 'Mark as Paid',
            onPressed: () => _markPaid(context, ref, data),
          ),
        ),
        SizedBox(
          width: 160,
          child: NeonButton(
            label: 'Add Payment',
            onPressed: () => _addPaymentDialog(context, ref, data),
          ),
        ),
        SizedBox(
          width: 160,
          child: NeonButton(
            label: 'Duplicate',
            onPressed: () => _duplicateInvoice(context, ref, data.invoice),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomFieldsSection(BuildContext context, Template? template, Map<String, dynamic> data) {
    if (template == null) {
      return NeonCard(child: const Text('Template not found'));
    }
    final schema = TemplateSchema.fromJson(template.schemaJson);
    final rows = <Widget>[];

    for (final section in schema.sections) {
      for (final field in section.fields) {
        final value = _formatCustomValue(data[field.key]);
        if (value.isEmpty) continue;
        rows.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Expanded(child: Text(field.label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary))),
                Text(value),
              ],
            ),
          ),
        );
      }
    }

    return NeonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Custom Fields', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (rows.isEmpty) const Text('No custom fields.'),
          ...rows,
        ],
      ),
    );
  }

  Widget _buildItemsSection(BuildContext context, List<InvoiceItem> items) {
    return NeonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Items', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (items.isEmpty) const Text('No items.'),
          ...items.map((item) {
            final total = (item.qty * item.price) - item.discount;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 4),
                  Text('${item.qty.toStringAsFixed(2)} ${item.unit} x ${item.price.toStringAsFixed(2)}'),
                  if (item.discount > 0) Text('Discount: ${item.discount.toStringAsFixed(2)}'),
                  Text('Total: ${total.toStringAsFixed(2)}'),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPaymentsSection(BuildContext context, List<Payment> payments, double totalPaid, double grandTotal) {
    return NeonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Payments', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (payments.isEmpty) const Text('No payments yet.'),
          ...payments.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text('${p.type.toUpperCase()} - ${p.amount.toStringAsFixed(2)} (${DateFormat('dd MMM yyyy').format(p.paidAt)})'),
              )),
          const Divider(),
          Text('Total Paid: ${totalPaid.toStringAsFixed(2)}'),
          Text('Remaining: ${(grandTotal - totalPaid).clamp(0, grandTotal).toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  Widget _buildSchedulesSection(BuildContext context, List<PaymentSchedule> schedules) {
    return NeonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Termin Schedules', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (schedules.isEmpty) const Text('No schedules.'),
          ...schedules.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text('${s.title}: ${DateFormat('dd MMM yyyy').format(s.dueDate)} - ${s.amount.toStringAsFixed(2)}'),
              )),
        ],
      ),
    );
  }

  Future<void> _sharePdf(BuildContext context, WidgetRef ref, InvoiceDetailData data) async {
    final businessRepo = ref.read(businessRepositoryProvider);
    final business = await businessRepo.getOrCreateBusiness();
    if (data.customer == null || data.template == null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Missing customer or template')));
      return;
    }

    final pdfService = PdfInvoiceService();
    if (data.invoice.pdfPath != null) {
      final existing = File(data.invoice.pdfPath!);
      if (await existing.exists()) {
        await pdfService.shareExistingFile(existing, data.invoice.number);
        return;
      }
    }

    final file = await pdfService.generateInvoicePdf(
      business: business,
      customer: data.customer!,
      template: data.template!,
      invoice: data.invoice,
      items: data.items,
      customData: data.customData,
      payments: data.payments,
      schedules: data.schedules,
    );
    data.invoice.pdfPath = file.path;
    final invoiceRepo = ref.read(invoiceRepositoryProvider);
    await invoiceRepo.updateInvoice(data.invoice);
    await pdfService.shareExistingFile(file, data.invoice.number);
  }

  Future<void> _markPaid(BuildContext context, WidgetRef ref, InvoiceDetailData data) async {
    final invoiceRepo = ref.read(invoiceRepositoryProvider);
    final remaining = data.invoice.grandTotal - data.totalPaid;
    if (remaining <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invoice already paid')));
      return;
    }
    await invoiceRepo.addPayment(Payment(
      invoiceId: data.invoice.id ?? 0,
      type: 'lunas',
      method: 'other',
      amount: remaining,
      paidAt: DateTime.now(),
    ));
    data.invoice.status = _deriveStatus(data.invoice, data.totalPaid + remaining);
    await invoiceRepo.updateInvoice(data.invoice);
    final _ = ref.refresh(invoiceDetailProvider(invoiceId));
  }

  Future<void> _addPaymentDialog(BuildContext context, WidgetRef ref, InvoiceDetailData data) async {
    final amountCtrl = TextEditingController();
    final noteCtrl = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NeonTextField(
              label: 'Amount',
              controller: amountCtrl,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            NeonTextField(
              label: 'Note (optional)',
              controller: noteCtrl,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final amount = double.tryParse(amountCtrl.text) ?? 0;
              if (amount <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Amount required')));
                return;
              }
              final invoiceRepo = ref.read(invoiceRepositoryProvider);
              final remaining = data.invoice.grandTotal - data.totalPaid;
              final type = amount >= remaining ? 'lunas' : 'dp';
              await invoiceRepo.addPayment(Payment(
                invoiceId: data.invoice.id ?? 0,
                type: type,
                method: 'other',
                amount: amount,
                paidAt: DateTime.now(),
                note: noteCtrl.text.trim().isEmpty ? null : noteCtrl.text.trim(),
              ));
              final newTotalPaid = data.totalPaid + amount;
              data.invoice.status = _deriveStatus(data.invoice, newTotalPaid);
              await invoiceRepo.updateInvoice(data.invoice);
              if (!ctx.mounted) return;
              Navigator.of(ctx).pop();
              final _ = ref.refresh(invoiceDetailProvider(invoiceId));
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _duplicateInvoice(BuildContext context, WidgetRef ref, Invoice source) async {
    final businessRepo = ref.read(businessRepositoryProvider);
    final invoiceRepo = ref.read(invoiceRepositoryProvider);
    final business = await businessRepo.getOrCreateBusiness();

    final newNumber = InvoiceNumberGenerator.generateNumber(business);
    await businessRepo.updateBusiness(business);

    final items = await invoiceRepo.getInvoiceItems(source.id ?? 0);
    final newInvoice = Invoice(
      businessId: source.businessId,
      customerId: source.customerId,
      templateId: source.templateId,
      number: newNumber,
      date: DateTime.now(),
      dueDate: source.dueDate,
      status: 'draft',
      subtotal: source.subtotal,
      discount: source.discount,
      tax: source.tax,
      shipping: source.shipping,
      grandTotal: source.grandTotal,
      notes: source.notes,
      terms: source.terms,
      customDataJson: source.customDataJson,
      pdfPath: null,
    );

    await invoiceRepo.createInvoice(newInvoice);
    for (final item in items) {
      await invoiceRepo.addInvoiceItem(InvoiceItem(
        invoiceId: newInvoice.id ?? 0,
        name: item.name,
        qty: item.qty,
        unit: item.unit,
        price: item.price,
        discount: item.discount,
        note: item.note,
      ));
    }

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invoice duplicated')));
  }
}

class InvoiceDetailData {
  final Invoice invoice;
  final Customer? customer;
  final Template? template;
  final List<InvoiceItem> items;
  final List<Payment> payments;
  final List<PaymentSchedule> schedules;
  final double totalPaid;
  final String status;
  final Map<String, dynamic> customData;

  InvoiceDetailData({
    required this.invoice,
    required this.customer,
    required this.template,
    required this.items,
    required this.payments,
    required this.schedules,
    required this.totalPaid,
    required this.status,
    required this.customData,
  });
}

String _deriveStatus(Invoice invoice, double totalPaid) {
  if (invoice.status == 'cancelled') return 'cancelled';
  if (totalPaid >= invoice.grandTotal) return 'paid';

  final today = DateTime.now();
  final todayDate = DateTime(today.year, today.month, today.day);
  if (invoice.dueDate != null && invoice.dueDate!.isBefore(todayDate)) {
    return 'overdue';
  }

  if (totalPaid > 0 && totalPaid < invoice.grandTotal) return 'partial_paid';
  if (invoice.status == 'sent') return 'sent';
  return 'draft';
}

Map<String, dynamic> _parseCustomData(String? json) {
  if (json == null || json.isEmpty) return {};
  try {
    return jsonDecode(json) as Map<String, dynamic>;
  } catch (_) {
    return {};
  }
}

String _formatCustomValue(dynamic value) {
  if (value == null) return '';
  if (value is Map && value.containsKey('start') && value.containsKey('end')) {
    return '${value['start']} - ${value['end']}';
  }
  if (value is bool) return value ? 'Yes' : 'No';
  return value.toString();
}
