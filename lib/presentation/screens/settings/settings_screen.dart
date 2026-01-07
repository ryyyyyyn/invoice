import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:invoice/application/providers/providers.dart';
import 'package:invoice/core/widgets/neon_button.dart';
import 'package:invoice/core/widgets/neon_card.dart';
import 'package:invoice/services/backup_restore_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.read(appDatabaseProvider);
    final backupService = BackupRestoreService(db);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            _buildBackupSection(context, backupService),
            const SizedBox(height: 24),
            _buildLegalSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBackupSection(BuildContext context, BackupRestoreService backupService) {
    return NeonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Backup & Restore', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Export all data to a JSON file or restore from a backup. Restoring will replace current data.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          NeonButton(
            label: 'Export Backup',
            onPressed: () async {
              await backupService.exportAndShare();
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup exported')));
            },
          ),
          const SizedBox(height: 12),
          NeonButton(
            label: 'Import Backup (Replace Data)',
            onPressed: () => _handleImport(context, backupService),
          ),
        ],
      ),
    );
  }

  Future<void> _handleImport(BuildContext context, BackupRestoreService backupService) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Replace existing data?'),
        content: const Text('Importing backup will replace all existing data. Continue?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Replace')),
        ],
      ),
    );

    if (confirm != true) return;
    final file = await backupService.pickBackupFile();
    if (file == null) return;

    try {
      await backupService.importFromFile(file, replace: true);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup imported')));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Import failed: $e')));
    }
  }

  Widget _buildLegalSection(BuildContext context) {
    return NeonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Legal', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          NeonButton(
            label: 'Privacy Policy',
            onPressed: () => context.push('/privacy-policy'),
          ),
          const SizedBox(height: 12),
          NeonButton(
            label: 'Terms of Service',
            onPressed: () => context.push('/terms'),
          ),
        ],
      ),
    );
  }
}
