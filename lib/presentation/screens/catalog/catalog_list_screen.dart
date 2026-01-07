import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice/core/constants/app_colors.dart';
import 'package:invoice/core/widgets/neon_card.dart';
import 'package:invoice/core/widgets/neon_text_field.dart';
import 'package:invoice/core/widgets/neon_button.dart';
import 'package:invoice/core/widgets/empty_state.dart';
import 'package:invoice/application/providers/providers.dart';
import 'package:invoice/domain/entities/catalog_item.dart';

// Provider to load catalog items
final catalogListProvider = FutureProvider.autoDispose((ref) async {
  final repo = ref.read(catalogRepositoryProvider);
  return await repo.getAllItems();
});

final catalogSearchProvider = StateProvider<String>((ref) => '');

class CatalogListScreen extends ConsumerWidget {
  const CatalogListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(catalogSearchProvider);
    final itemsAsync = ref.watch(catalogListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Catalog')),
      body: itemsAsync.when(
        data: (allItems) {
          final filtered = searchQuery.isEmpty
              ? allItems
              : allItems.where((i) => i.name.toLowerCase().contains(searchQuery.toLowerCase())).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: NeonTextField(
                  label: 'Search Catalog',
                  hint: 'Search by name...',
                  prefixIcon: Icons.search,
                  onChanged: (v) => ref.read(catalogSearchProvider.notifier).state = v,
                ),
              ),
              if (filtered.isEmpty)
                Expanded(
                  child: EmptyState(
                    icon: Icons.inventory_2_outlined,
                    title: 'No Items',
                    description: 'Add items to your catalog',
                    buttonLabel: 'Add Item',
                    onButtonPressed: () => _showCatalogFormSheet(context, ref),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final it = filtered[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: NeonCard(
                          onTap: () => _showCatalogFormSheet(context, ref, editItem: it),
                          child: Row(
                            children: [
                              const Icon(Icons.inventory, size: 40),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(it.name, style: Theme.of(context).textTheme.titleMedium),
                                    Text('${it.price.toStringAsFixed(2)} • ${it.unit}${it.category != null ? ' • ${it.category}' : ''}',
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                                  ],
                                ),
                              ),
                              PopupMenuButton<String>(
                                onSelected: (v) {
                                  if (v == 'edit') _showCatalogFormSheet(context, ref, editItem: it);
                                  if (v == 'delete') _showDeleteConfirmation(context, ref, it);
                                },
                                itemBuilder: (_) => [
                                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                                ],
                                child: Icon(Icons.more_vert, color: AppColors.textSecondary),
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
        onPressed: () => _showCatalogFormSheet(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, CatalogItem it) {
    final navigator = Navigator.of(context);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Delete "${it.name}"?'),
        actions: [
          TextButton(onPressed: () => navigator.pop(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              final repo = ref.read(catalogRepositoryProvider);
              await repo.deleteItem(it.id!);
              final _ = ref.refresh(catalogListProvider);
              navigator.pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showCatalogFormSheet(BuildContext context, WidgetRef ref, {CatalogItem? editItem}) {
    final nameCtrl = TextEditingController(text: editItem?.name ?? '');
    final priceCtrl = TextEditingController(text: editItem != null ? editItem.price.toString() : '');
    String unit = editItem?.unit ?? 'pcs';
    final categoryCtrl = TextEditingController(text: editItem?.category ?? '');
    final descCtrl = TextEditingController(text: editItem?.description ?? '');
    String? nameError;
    String? priceError;

    final navigator = Navigator.of(context);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: StatefulBuilder(builder: (ctx, setState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(editItem == null ? 'Add Catalog Item' : 'Edit Item', style: Theme.of(ctx).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  NeonTextField(controller: nameCtrl, label: 'Name *'),
                  if (nameError != null) Text(nameError ?? '', style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 8),
                  NeonTextField(controller: priceCtrl, label: 'Price *', keyboardType: TextInputType.number),
                  if (priceError != null) Text(priceError ?? '', style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: unit,
                        items: ['pcs', 'unit', 'jam', 'hari', 'm2', 'm3', 'paket']
                            .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                            .toList(),
                        onChanged: (v) => setState(() => unit = v ?? unit),
                        decoration: const InputDecoration(labelText: 'Unit'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: NeonTextField(controller: categoryCtrl, label: 'Category')),
                  ]),
                  const SizedBox(height: 8),
                  NeonTextField(controller: descCtrl, label: 'Description', maxLines: 2),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(
                      child: NeonButton(
                        label: editItem == null ? 'Save' : 'Update',
                          onPressed: () async {
                          final name = nameCtrl.text.trim();
                          final priceText = priceCtrl.text.trim();
                          double? price = double.tryParse(priceText);
                          if (name.isEmpty) {
                            setState(() => nameError = 'Name required');
                            return;
                          }
                          if (price == null) {
                            setState(() => priceError = 'Enter valid number');
                            return;
                          }
                          final repo = ref.read(catalogRepositoryProvider);
                          if (editItem == null) {
                            final item = CatalogItem(name: name, price: price, unit: unit, category: categoryCtrl.text.trim().isEmpty ? null : categoryCtrl.text.trim(), description: descCtrl.text.trim().isEmpty ? null : descCtrl.text.trim());
                            await repo.createItem(item);
                          } else {
                            final item = CatalogItem(id: editItem.id, name: name, price: price, unit: unit, category: categoryCtrl.text.trim().isEmpty ? null : categoryCtrl.text.trim(), description: descCtrl.text.trim().isEmpty ? null : descCtrl.text.trim(), createdAt: editItem.createdAt);
                            await repo.updateItem(item);
                          }
                          final _ = ref.refresh(catalogListProvider);
                          navigator.pop();
                        },
                      ),
                    ),
                  ]),
                  const SizedBox(height: 12),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}
