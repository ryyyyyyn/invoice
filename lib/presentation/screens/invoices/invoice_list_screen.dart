import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:invoice/core/constants/app_colors.dart';
import 'package:invoice/core/widgets/neon_card.dart';
import 'package:invoice/core/widgets/neon_text_field.dart';
import 'package:invoice/core/widgets/empty_state.dart';
import 'package:invoice/core/widgets/status_badge.dart';
import 'package:invoice/application/providers/providers.dart';
import 'package:invoice/domain/entities/invoice.dart';
import 'package:invoice/services/pdf_invoice_service.dart';
import 'package:invoice/utils/invoice_number_generator.dart';
import 'package:invoice/presentation/utils/pro_access_guard.dart';
import 'package:intl/intl.dart';

final invoiceListViewProvider = FutureProvider.autoDispose<List<InvoiceListEntry>>((ref) async {
  final invoiceRepo = ref.read(invoiceRepositoryProvider);
  final customerRepo = ref.read(customerRepositoryProvider);
  final invoices = await invoiceRepo.getAllInvoices();
  final customers = await customerRepo.getAllCustomers();
  final customerMap = {for (final c in customers) c.id: c.name};
  final entries = <InvoiceListEntry>[];

  for (final inv in invoices) {
    final payments = await invoiceRepo.getInvoicePayments(inv.id ?? 0);
    final totalPaid = payments.fold<double>(0, (sum, p) => sum + p.amount);
    final status = deriveInvoiceStatus(inv, totalPaid);
    entries.add(
      InvoiceListEntry(
        invoice: inv,
        customerName: customerMap[inv.customerId] ?? 'Unknown Customer',
        totalPaid: totalPaid,
        status: status,
      ),
    );
  }

  return entries;
});

final invoiceSearchProvider = StateProvider<String>((ref) => '');
final invoiceStatusFilterProvider = StateProvider<String?>((ref) => null);
final invoiceSortDueDateProvider = StateProvider<bool>((ref) => false);

class InvoiceListScreen extends ConsumerWidget {
  const InvoiceListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(invoiceSearchProvider);
    final statusFilter = ref.watch(invoiceStatusFilterProvider);
    final sortByDueDate = ref.watch(invoiceSortDueDateProvider);
    final invoicesAsync = ref.watch(invoiceListViewProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoices'),
        actions: [
          IconButton(
            tooltip: sortByDueDate ? 'Sort by newest' : 'Sort by due date',
            icon: Icon(sortByDueDate ? Icons.schedule : Icons.calendar_today),
            onPressed: () => ref.read(invoiceSortDueDateProvider.notifier).state = !sortByDueDate,
          ),
        ],
      ),
      body: invoicesAsync.when(
        data: (allEntries) {
          var filtered = allEntries;

          if (statusFilter != null) {
            filtered = filtered.where((i) => i.status == statusFilter).toList();
          }

          if (searchQuery.isNotEmpty) {
            final q = searchQuery.toLowerCase();
            filtered = filtered
                .where((i) => i.invoice.number.toLowerCase().contains(q) || i.customerName.toLowerCase().contains(q))
                .toList();
          }

          filtered.sort((a, b) {
            if (sortByDueDate) {
              final aDue = a.invoice.dueDate ?? DateTime(9999);
              final bDue = b.invoice.dueDate ?? DateTime(9999);
              return aDue.compareTo(bDue);
            }
            return b.invoice.date.compareTo(a.invoice.date);
          });

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: NeonTextField(
                  label: 'Search',
                  hint: 'Search by invoice number or customer...',
                  prefixIcon: Icons.search,
                  onChanged: (v) => ref.read(invoiceSearchProvider.notifier).state = v,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(ref, 'All', null),
                      _buildFilterChip(ref, 'Draft', 'draft'),
                      _buildFilterChip(ref, 'Partial', 'partial_paid'),
                      _buildFilterChip(ref, 'Paid', 'paid'),
                      _buildFilterChip(ref, 'Overdue', 'overdue'),
                      _buildFilterChip(ref, 'Cancelled', 'cancelled'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (filtered.isEmpty)
                Expanded(
                  child: EmptyState(
                    icon: Icons.receipt_long_outlined,
                    title: 'No Invoices',
                    description: 'Create your first invoice',
                    buttonLabel: 'Create Invoice',
                    onButtonPressed: () async {
                      final allowed = await ensureProForInvoiceCreation(
                        context: context,
                        ref: ref,
                      );
                      if (allowed && context.mounted) {
                        context.push('/invoice/create');
                      }
                    },
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final entry = filtered[index];
                      final inv = entry.invoice;
                      final pdfExists = inv.pdfPath != null && File(inv.pdfPath!).existsSync();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: NeonCard(
                          onTap: () => context.push('/invoice/${inv.id}'),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: _getStatusColor(entry.status),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Center(child: Icon(Icons.receipt, color: Colors.black, size: 24)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(inv.number, style: Theme.of(context).textTheme.titleMedium),
                                    const SizedBox(height: 2),
                                    Text(entry.customerName, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Date: ${DateFormat('dd MMM yyyy').format(inv.date)}',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                                    ),
                                    Text(
                                      'Due: ${inv.dueDate == null ? '-' : DateFormat('dd MMM yyyy').format(inv.dueDate!)}',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(inv.grandTotal.toStringAsFixed(2), style: Theme.of(context).textTheme.titleSmall),
                                  const SizedBox(height: 6),
                                  StatusBadge(status: entry.status),
                                ],
                              ),
                              PopupMenuButton<String>(
                                onSelected: (v) {
                                  if (v == 'share') _sharePdf(context, ref, inv);
                                  if (v == 'mark_paid') _markPaid(context, ref, entry);
                                  if (v == 'mark_sent') _markSent(context, ref, entry);
                                  if (v == 'duplicate') _duplicateInvoice(context, ref, inv);
                                  if (v == 'archive') _archiveInvoice(context, ref, inv);
                                },
                                itemBuilder: (_) => [
                                  PopupMenuItem(value: 'share', child: Text(pdfExists ? 'Share PDF' : 'Regenerate PDF')),
                                  if (entry.status == 'draft')
                                    const PopupMenuItem(value: 'mark_sent', child: Text('Mark as Sent')),
                                  if (entry.status != 'paid' && entry.status != 'cancelled')
                                    const PopupMenuItem(value: 'mark_paid', child: Text('Mark Paid')),
                                  const PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
                                  const PopupMenuItem(value: 'archive', child: Text('Archive')),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final allowed = await ensureProForInvoiceCreation(
            context: context,
            ref: ref,
          );
          if (allowed && context.mounted) {
            context.push('/invoice/create');
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterChip(WidgetRef ref, String label, String? value) {
    final selected = ref.watch(invoiceStatusFilterProvider) == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (selected) {
          ref.read(invoiceStatusFilterProvider.notifier).state = selected ? value : null;
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'draft':
        return Colors.grey;
      case 'sent':
        return Colors.blue;
      case 'partial_paid':
        return Colors.orange;
      case 'paid':
        return Colors.green;
      case 'overdue':
        return Colors.red;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  Future<void> _sharePdf(BuildContext context, WidgetRef ref, Invoice invoice) async {
    final businessRepo = ref.read(businessRepositoryProvider);
    final customerRepo = ref.read(customerRepositoryProvider);
    final templateRepo = ref.read(templateRepositoryProvider);
    final invoiceRepo = ref.read(invoiceRepositoryProvider);

    final business = await businessRepo.getOrCreateBusiness();
    final customer = await customerRepo.getCustomerById(invoice.customerId);
    final template = await templateRepo.getTemplateById(invoice.templateId);
    if (customer == null || template == null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Missing customer or template')));
      return;
    }

    final items = await invoiceRepo.getInvoiceItems(invoice.id ?? 0);
    final payments = await invoiceRepo.getInvoicePayments(invoice.id ?? 0);
    final schedules = await invoiceRepo.getPaymentSchedules(invoice.id ?? 0);
    final customData = _parseCustomData(invoice.customDataJson);

    final pdfService = PdfInvoiceService();
    if (invoice.pdfPath != null) {
      final file = File(invoice.pdfPath!);
      if (await file.exists()) {
        await pdfService.shareExistingFile(file, invoice.number);
        return;
      }
    }

    final file = await pdfService.generateInvoicePdf(
      business: business,
      customer: customer,
      template: template,
      invoice: invoice,
      items: items,
      customData: customData,
      payments: payments,
      schedules: schedules,
    );
    invoice.pdfPath = file.path;
    await invoiceRepo.updateInvoice(invoice);
    await pdfService.shareExistingFile(file, invoice.number);
  }

  Future<void> _markPaid(BuildContext context, WidgetRef ref, InvoiceListEntry entry) async {
    final invoiceRepo = ref.read(invoiceRepositoryProvider);
    final remaining = entry.invoice.grandTotal - entry.totalPaid;
    if (remaining <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invoice already paid')));
      return;
    }
    await invoiceRepo.addPayment(Payment(
      invoiceId: entry.invoice.id ?? 0,
      type: 'lunas',
      method: 'other',
      amount: remaining,
      paidAt: DateTime.now(),
    ));
    final newTotalPaid = entry.totalPaid + remaining;
    entry.invoice.status = deriveInvoiceStatus(entry.invoice, newTotalPaid);
    await invoiceRepo.updateInvoice(entry.invoice);
    final _ = ref.refresh(invoiceListViewProvider);
  }

  Future<void> _markSent(BuildContext context, WidgetRef ref, InvoiceListEntry entry) async {
    final invoiceRepo = ref.read(invoiceRepositoryProvider);
    entry.invoice.status = 'sent';
    await invoiceRepo.updateInvoice(entry.invoice);
    final _ = ref.refresh(invoiceListViewProvider);
  }

  Future<void> _archiveInvoice(BuildContext context, WidgetRef ref, Invoice invoice) async {
    final invoiceRepo = ref.read(invoiceRepositoryProvider);
    invoice.status = 'cancelled';
    await invoiceRepo.updateInvoice(invoice);
    final _ = ref.refresh(invoiceListViewProvider);
  }

  Future<void> _duplicateInvoice(BuildContext context, WidgetRef ref, Invoice source) async {
    final allowed = await ensureProForInvoiceCreation(
      context: context,
      ref: ref,
    );
    if (!allowed) return;

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

    final _ = ref.refresh(invoiceListViewProvider);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invoice duplicated')));
  }

  Map<String, dynamic> _parseCustomData(String? json) {
    if (json == null || json.isEmpty) return {};
    try {
      return jsonDecode(json) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }
}

class InvoiceListEntry {
  final Invoice invoice;
  final String customerName;
  final double totalPaid;
  final String status;

  InvoiceListEntry({
    required this.invoice,
    required this.customerName,
    required this.totalPaid,
    required this.status,
  });
}

String deriveInvoiceStatus(Invoice invoice, double totalPaid) {
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
