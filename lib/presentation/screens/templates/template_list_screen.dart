import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:invoice/core/widgets/neon_card.dart';
import 'package:invoice/core/widgets/neon_text_field.dart';
import 'package:invoice/core/widgets/neon_button.dart';
import 'package:invoice/core/widgets/empty_state.dart';
import 'package:invoice/application/providers/providers.dart';
import 'package:invoice/domain/entities/template.dart';

final templateListProvider = FutureProvider.autoDispose((ref) async {
  final repo = ref.read(templateRepositoryProvider);
  return await repo.getAllTemplates();
});

final templateSearchProvider = StateProvider<String>((ref) => '');

class TemplateListScreen extends ConsumerWidget {
  const TemplateListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(templateSearchProvider);
    final templatesAsync = ref.watch(templateListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Templates')),
      body: templatesAsync.when(
        data: (allTemplates) {
          final filtered = searchQuery.isEmpty
              ? allTemplates
              : allTemplates.where((t) => t.name.toLowerCase().contains(searchQuery.toLowerCase())).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: NeonTextField(
                  label: 'Search',
                  hint: 'Search templates...',
                  prefixIcon: Icons.search,
                  onChanged: (v) => ref.read(templateSearchProvider.notifier).state = v,
                ),
              ),
              if (filtered.isEmpty)
                Expanded(
                  child: EmptyState(
                    icon: Icons.assignment,
                    title: 'No Templates',
                    description: 'Create your first invoice template',
                    buttonLabel: 'Create Template',
                    onButtonPressed: () => _showTemplateFormSheet(context, ref),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final template = filtered[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: NeonCard(
                          onTap: () => _showTemplateFormSheet(context, ref, editTemplate: template),
                          child: Row(
                            children: [
                              const Icon(Icons.assignment, size: 40),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(template.name, style: Theme.of(context).textTheme.titleMedium),
                                    if (template.description != null) Text(template.description!, style: Theme.of(context).textTheme.bodySmall),
                                  ],
                                ),
                              ),
                              PopupMenuButton<String>(
                                onSelected: (v) {
                                  if (v == 'edit') context.push('/template/${template.id}/edit');
                                  if (v == 'duplicate') _duplicateTemplate(context, ref, template);
                                  if (v == 'delete') _showDeleteConfirmation(context, ref, template);
                                },
                                itemBuilder: (_) => [
                                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                                  const PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
                                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
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
        onPressed: () => _showTemplateFormSheet(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showTemplateFormSheet(BuildContext context, WidgetRef ref, {Template? editTemplate}) {
    final nameCtrl = TextEditingController(text: editTemplate?.name ?? '');
    final descCtrl = TextEditingController(text: editTemplate?.description ?? '');
    final headerCtrl = TextEditingController();
    final footerCtrl = TextEditingController();
    String? nameError;
    final navigator = Navigator.of(context);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: StatefulBuilder(
            builder: (ctx, setState) => Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(editTemplate == null ? 'Add Template' : 'Edit Template', style: Theme.of(ctx).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  NeonTextField(controller: nameCtrl, label: 'Template Name *'),
                  if (nameError != null) Text(nameError ?? '', style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 8),
                  NeonTextField(controller: descCtrl, label: 'Description', maxLines: 2),
                  const SizedBox(height: 8),
                  NeonTextField(controller: headerCtrl, label: 'Header Content', maxLines: 3),
                  const SizedBox(height: 8),
                  NeonTextField(controller: footerCtrl, label: 'Footer Content', maxLines: 3),
                  const SizedBox(height: 12),
                  NeonButton(
                    label: editTemplate == null ? 'Save' : 'Update',
                    onPressed: () async {
                      final name = nameCtrl.text.trim();
                      if (name.isEmpty) {
                        setState(() => nameError = 'Name required');
                        return;
                      }

                      final repo = ref.read(templateRepositoryProvider);
                      final template = editTemplate ?? Template(name: name, description: descCtrl.text.trim().isEmpty ? null : descCtrl.text.trim());
                      template.name = name;
                      template.description = descCtrl.text.trim().isEmpty ? null : descCtrl.text.trim();

                      if (editTemplate == null) {
                        await repo.createTemplate(template);
                      } else {
                        await repo.updateTemplate(template);
                      }

                      final _ = ref.refresh(templateListProvider);
                      navigator.pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, Template template) {
    final navigator = Navigator.of(context);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Template'),
        content: Text('Delete "${template.name}"?'),
        actions: [
          TextButton(onPressed: () => navigator.pop(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              final repo = ref.read(templateRepositoryProvider);
              await repo.deleteTemplate(template.id!);
              final _ = ref.refresh(templateListProvider);
              navigator.pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _duplicateTemplate(BuildContext context, WidgetRef ref, Template template) async {
    final repo = ref.read(templateRepositoryProvider);
    final newTemplate = Template(
      name: '${template.name} (Copy)',
      description: template.description,
      schemaJson: template.schemaJson,
    );
    await repo.createTemplate(newTemplate);
    final _ = ref.refresh(templateListProvider);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Template duplicated')));
  }
}
