import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice/application/providers/providers.dart';
import 'package:invoice/core/constants/billing_constants.dart';

class ProPaywallDialog extends ConsumerStatefulWidget {
  const ProPaywallDialog({super.key});

  @override
  ConsumerState<ProPaywallDialog> createState() => _ProPaywallDialogState();
}

class _ProPaywallDialogState extends ConsumerState<ProPaywallDialog> {
  @override
  Widget build(BuildContext context) {
    ref.listen(proAccessProvider, (previous, next) {
      if (previous?.isPro != true && next.isPro) {
        if (context.mounted) Navigator.of(context).pop(true);
      }
    });

    final state = ref.watch(proAccessProvider);
    final product = state.productDetails;
    final priceLabel = product?.price ?? '-';

    return AlertDialog(
      title: const Text('Upgrade ke Pro'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Limit invoice gratis adalah ${BillingConstants.freeInvoiceLimit}.'),
          const SizedBox(height: 8),
          const Text('Aktifkan langganan Pro untuk membuat invoice tanpa batas.'),
          const SizedBox(height: 12),
          Text('Harga: $priceLabel'),
          if (state.errorMessage != null) ...[
            const SizedBox(height: 12),
            Text(
              state.errorMessage!,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Tutup'),
        ),
        TextButton(
          onPressed: state.isAvailable ? () => ref.read(proAccessProvider.notifier).restore() : null,
          child: const Text('Pulihkan'),
        ),
        ElevatedButton(
          onPressed: state.isAvailable ? () => ref.read(proAccessProvider.notifier).buyPro() : null,
          child: const Text('Langganan Pro'),
        ),
      ],
    );
  }
}
