import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice/application/providers/providers.dart';
import 'package:invoice/core/constants/billing_constants.dart';
import 'package:invoice/presentation/widgets/pro_paywall_dialog.dart';

Future<bool> ensureProForInvoiceCreation({
  required BuildContext context,
  required WidgetRef ref,
}) async {
  final proState = ref.read(proAccessProvider);
  if (proState.isPro) return true;

  final invoiceRepo = ref.read(invoiceRepositoryProvider);
  final count = await invoiceRepo.getInvoiceCount();
  if (count < BillingConstants.freeInvoiceLimit) return true;

  if (!context.mounted) return false;
  await showDialog<bool>(
    context: context,
    builder: (_) => const ProPaywallDialog(),
  );

  final updated = ref.read(proAccessProvider);
  return updated.isPro;
}
