import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:invoice/core/constants/app_colors.dart';
import 'package:invoice/core/widgets/neon_card.dart';
import 'package:invoice/application/providers/providers.dart';
import 'package:invoice/presentation/utils/pro_access_guard.dart';

final homeStatsProvider = FutureProvider.autoDispose((ref) async {
  final invoiceRepo = ref.read(invoiceRepositoryProvider);
  final totalRevenue = await invoiceRepo.getTotalRevenue();
  final unpaidCount = await invoiceRepo.getUnpaidInvoicesCount();
  final overdueCount = await invoiceRepo.getOverdueInvoicesCount();
  final allInvoices = await invoiceRepo.getAllInvoices();

  return {
    'revenue': totalRevenue,
    'unpaid': unpaidCount,
    'overdue': overdueCount,
    'totalInvoices': allInvoices.length,
    'recentInvoices': allInvoices.length > 5 ? allInvoices.sublist(0, 5) : allInvoices,
  };
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(homeStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/business-profile'),
          ),
        ],
      ),
      body: statsAsync.when(
        data: (stats) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NeonCard(
                glowing: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome to Invoice App', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    Text('Manage your invoices with ease', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text('Quick Stats', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _StatCard(
                    title: 'Revenue',
                    value: (stats['revenue'] as double).toStringAsFixed(2),
                    icon: Icons.trending_up,
                    color: AppColors.statusSuccess,
                  ),
                  _StatCard(
                    title: 'Unpaid',
                    value: stats['unpaid'].toString(),
                    icon: Icons.warning_amber,
                    color: AppColors.statusWarning,
                  ),
                  _StatCard(
                    title: 'Overdue',
                    value: stats['overdue'].toString(),
                    icon: Icons.error_outline,
                    color: AppColors.statusError,
                  ),
                  _StatCard(
                    title: 'Total',
                    value: stats['totalInvoices'].toString(),
                    icon: Icons.receipt,
                    color: AppColors.accentNeon,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('Quick Actions', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => context.go('/customers'),
                      child: NeonCard(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.person_add, size: 32, color: AppColors.accentNeon),
                            const SizedBox(height: 8),
                            Text('Customers', style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => context.go('/invoices'),
                      child: NeonCard(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.receipt_long, size: 32, color: AppColors.accentNeon),
                            const SizedBox(height: 8),
                            Text('Invoices', style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
            context.go('/invoice/create');
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      backgroundColor: AppColors.surfaceLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: color,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
