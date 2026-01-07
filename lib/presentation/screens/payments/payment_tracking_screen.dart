import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice/core/widgets/neon_card.dart';
import 'package:invoice/core/widgets/neon_text_field.dart';
import 'package:invoice/core/widgets/neon_button.dart';
import 'package:invoice/application/providers/providers.dart';
import 'package:invoice/domain/entities/invoice.dart';
import 'package:intl/intl.dart';

final paymentInvoicesProvider = FutureProvider.autoDispose((ref) async {
  final repo = ref.read(invoiceRepositoryProvider);
  return await repo.getAllInvoices();
});

class PaymentTrackingScreen extends ConsumerStatefulWidget {
  const PaymentTrackingScreen({super.key});

  @override
  ConsumerState<PaymentTrackingScreen> createState() => _PaymentTrackingScreenState();
}

class _PaymentTrackingScreenState extends ConsumerState<PaymentTrackingScreen> {
  Invoice? _selectedInvoice;

  @override
  Widget build(BuildContext context) {
    final invoicesAsync = ref.watch(paymentInvoicesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Payment Tracking')),
      body: invoicesAsync.when(
        data: (invoices) {
          final unsubmitted = invoices.where((i) => i.status != 'paid' && i.status != 'cancelled').toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Select Invoice to Track', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    DropdownButton<Invoice>(
                      isExpanded: true,
                      value: _selectedInvoice,
                      hint: const Text('Select an invoice'),
                      items: unsubmitted.map((inv) => DropdownMenuItem(value: inv, child: Text('${inv.number} - ${inv.grandTotal.toStringAsFixed(2)}'))).toList(),
                      onChanged: (inv) => setState(() => _selectedInvoice = inv),
                    ),
                  ],
                ),
              ),
              if (_selectedInvoice != null)
                Expanded(
                  child: InvoicePaymentForm(invoice: _selectedInvoice!, onPaymentAdded: () {
                    setState(() => _selectedInvoice = null);
                    ref.invalidate(paymentInvoicesProvider);
                  }),
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class InvoicePaymentForm extends ConsumerStatefulWidget {
  final Invoice invoice;
  final VoidCallback onPaymentAdded;

  const InvoicePaymentForm({required this.invoice, required this.onPaymentAdded, super.key});

  @override
  ConsumerState<InvoicePaymentForm> createState() => _InvoicePaymentFormState();
}

class _InvoicePaymentFormState extends ConsumerState<InvoicePaymentForm> {
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  String _paymentType = 'lunas';
  String _paymentMethod = 'cash';
  DateTime _paidDate = DateTime.now();

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _logPayment() async {
    final amount = double.tryParse(_amountCtrl.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter valid amount')));
      return;
    }

    final repo = ref.read(invoiceRepositoryProvider);
    final payment = Payment(
      invoiceId: widget.invoice.id ?? 1,
      type: _paymentType,
      method: _paymentMethod,
      amount: amount,
      paidAt: _paidDate,
      note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
    );

    await repo.addPayment(payment);

    // Update invoice status
    final payments = await repo.getInvoicePayments(widget.invoice.id ?? 1);
    double totalPaid = payments.fold<double>(0, (sum, p) => sum + p.amount);
    String newStatus = 'draft';
    if (totalPaid >= widget.invoice.grandTotal) {
      newStatus = 'paid';
    } else if (totalPaid > 0) {
      newStatus = 'partial_paid';
    }

    widget.invoice.status = newStatus;
    await repo.updateInvoice(widget.invoice);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment recorded')));
    _amountCtrl.clear();
    _noteCtrl.clear();
    widget.onPaymentAdded();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Invoice Details', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          NeonCard(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Number:'),
                    Text(widget.invoice.number, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Grand Total:'),
                    Text(widget.invoice.grandTotal.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Status:'),
                    Chip(label: Text(widget.invoice.status)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Log Payment', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          NeonCard(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Date', style: Theme.of(context).textTheme.labelMedium),
                          TextButton(
                            onPressed: () async {
                              final picked = await showDatePicker(context: context, initialDate: _paidDate, firstDate: DateTime(2020), lastDate: DateTime.now().add(const Duration(days: 30)));
                              if (picked != null) setState(() => _paidDate = picked);
                            },
                            child: Text(DateFormat('dd MMM yyyy').format(_paidDate)),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Type', style: Theme.of(context).textTheme.labelMedium),
                          DropdownButton<String>(
                            value: _paymentType,
                            items: ['lunas', 'dp', 'termin'].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                            onChanged: (v) => setState(() => _paymentType = v ?? 'lunas'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: NeonTextField(label: 'Amount', controller: _amountCtrl, keyboardType: TextInputType.number),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Method', style: Theme.of(context).textTheme.labelMedium),
                          DropdownButton<String>(
                            value: _paymentMethod,
                            items: ['cash', 'transfer', 'check', 'other'].map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                            onChanged: (v) => setState(() => _paymentMethod = v ?? 'cash'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                NeonTextField(label: 'Note', controller: _noteCtrl, maxLines: 2),
                const SizedBox(height: 12),
                NeonButton(label: 'Record Payment', onPressed: _logPayment),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
