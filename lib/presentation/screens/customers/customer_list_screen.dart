import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice/core/constants/app_colors.dart';
import 'package:invoice/application/providers/providers.dart';
import 'package:invoice/domain/entities/customer.dart';
import 'package:invoice/core/widgets/neon_card.dart';
import 'package:invoice/core/widgets/neon_text_field.dart';
import 'package:invoice/core/widgets/empty_state.dart';

// Riverpod Providers for Customers
final customerListProvider = FutureProvider.autoDispose((ref) async {
  final repo = ref.read(customerRepositoryProvider);
  return await repo.getAllCustomers();
});

final customerSearchProvider = StateProvider<String>((ref) => '');

class CustomerListScreen extends ConsumerWidget {
  const CustomerListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(customerSearchProvider);
    final customersAsync = ref.watch(customerListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        centerTitle: true,
      ),
      body: customersAsync.when(
        data: (allCustomers) {
          // Filter by search query
          final filteredCustomers = searchQuery.isEmpty
              ? allCustomers
              : allCustomers
                  .where((c) => c.name.toLowerCase().contains(searchQuery.toLowerCase()))
                  .toList();
          return Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: NeonTextField(
                  label: 'Search Customers',
                  hint: 'Search by name...',
                  prefixIcon: Icons.search,
                  onChanged: (value) {
                    ref.read(customerSearchProvider.notifier).state = value;
                  },
                ),
              ),
              // Customer list
              if (filteredCustomers.isEmpty)
                Expanded(
                  child: EmptyState(
                    icon: Icons.people_outline,
                    title: searchQuery.isNotEmpty ? 'No Matching Customers' : 'No Customers Yet',
                    description: searchQuery.isNotEmpty
                        ? 'Try a different search term'
                        : 'Add your first customer to get started',
                    buttonLabel: searchQuery.isNotEmpty ? null : 'Add Customer',
                    onButtonPressed: searchQuery.isNotEmpty ? null : () => _showAddCustomerDialog(context, ref),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredCustomers.length,
                    itemBuilder: (context, index) {
                      final customer = filteredCustomers[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: NeonCard(
                          onTap: () => _showCustomerDetailDialog(context, ref, customer),
                          child: Row(
                            children: [
                              Icon(
                                Icons.account_circle,
                                size: 48,
                                color: AppColors.accentNeon,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      customer.name,
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                    if (customer.email != null)
                                      Text(
                                        customer.email!,
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: AppColors.textSecondary,
                                            ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  ],
                                ),
                              ),
                              PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    _showEditCustomerDialog(context, ref, customer);
                                  } else if (value == 'delete') {
                                    _showDeleteConfirmation(context, ref, customer);
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                                ],
                                child: Icon(
                                  Icons.more_vert,
                                  color: AppColors.textSecondary,
                                ),
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
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCustomerDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddCustomerDialog(BuildContext context, WidgetRef ref) {
    _showCustomerFormDialog(
      context: context,
      ref: ref,
      title: 'Add Customer',
      customer: null,
      isEditing: false,
    );
  }

  void _showEditCustomerDialog(BuildContext context, WidgetRef ref, Customer customer) {
    _showCustomerFormDialog(
      context: context,
      ref: ref,
      title: 'Edit Customer',
      customer: customer,
      isEditing: true,
    );
  }

  void _showCustomerFormDialog({
    required BuildContext context,
    required WidgetRef ref,
    required String title,
    required Customer? customer,
    required bool isEditing,
  }) {
    final nameCtrl = TextEditingController(text: customer?.name ?? '');
    final emailCtrl = TextEditingController(text: customer?.email ?? '');
    final whatsappCtrl = TextEditingController(text: customer?.whatsapp ?? '');
    final addressCtrl = TextEditingController(text: customer?.address ?? '');
    final notesCtrl = TextEditingController(text: customer?.notes ?? '');
    String? nameError;

    showDialog<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return AlertDialog(
              title: Text(title),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameCtrl,
                      decoration: InputDecoration(
                        labelText: 'Name *',
                        errorText: nameError,
                        hintText: 'Required',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'customer@example.com',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: whatsappCtrl,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'WhatsApp',
                        hintText: '+62xxx',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: addressCtrl,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        hintText: 'Street address',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: notesCtrl,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Notes',
                        hintText: 'Additional information',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () async {
                    final name = nameCtrl.text.trim();
                    if (name.isEmpty) {
                      setState(() => nameError = 'Name is required');
                      return;
                    }

                    final customerToSave = isEditing && customer != null
                        ? Customer(
                            id: customer.id,
                            name: name,
                            email: emailCtrl.text.trim().isEmpty ? null : emailCtrl.text.trim(),
                            whatsapp: whatsappCtrl.text.trim().isEmpty ? null : whatsappCtrl.text.trim(),
                            address: addressCtrl.text.trim().isEmpty ? null : addressCtrl.text.trim(),
                            notes: notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim(),
                            createdAt: customer.createdAt,
                          )
                        : Customer(
                            name: name,
                            email: emailCtrl.text.trim().isEmpty ? null : emailCtrl.text.trim(),
                            whatsapp: whatsappCtrl.text.trim().isEmpty ? null : whatsappCtrl.text.trim(),
                            address: addressCtrl.text.trim().isEmpty ? null : addressCtrl.text.trim(),
                            notes: notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim(),
                          );

                    final repo = ref.read(customerRepositoryProvider);

                    try {
                      if (isEditing) {
                        await repo.updateCustomer(customerToSave);
                      } else {
                        await repo.createCustomer(customerToSave);
                      }

                      // refresh list
                      final _ = ref.refresh(customerListProvider);
                      
                      if (ctx.mounted) {
                        Navigator.of(ctx).pop();
                      }
                    } catch (e) {
                      if (ctx.mounted) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    }
                  },
                  child: Text(isEditing ? 'Update' : 'Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showCustomerDetailDialog(
    BuildContext context,
    WidgetRef ref,
    Customer customer,
  ) {
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(customer.name),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (customer.email != null) ...[
                  const Text('Email:', style: TextStyle(fontWeight: FontWeight.bold)),
                  SelectableText(customer.email!),
                  const SizedBox(height: 12),
                ],
                if (customer.whatsapp != null) ...[
                  const Text('WhatsApp:', style: TextStyle(fontWeight: FontWeight.bold)),
                  SelectableText(customer.whatsapp!),
                  const SizedBox(height: 12),
                ],
                if (customer.address != null) ...[
                  const Text('Address:', style: TextStyle(fontWeight: FontWeight.bold)),
                  SelectableText(customer.address!),
                  const SizedBox(height: 12),
                ],
                if (customer.notes != null) ...[
                  const Text('Notes:', style: TextStyle(fontWeight: FontWeight.bold)),
                  SelectableText(customer.notes!),
                  const SizedBox(height: 12),
                ],
                Text(
                  'Created: ${customer.createdAt.toString().split('.')[0]}',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Close')),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, Customer customer) {
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Delete Customer'),
          content: Text('Are you sure you want to delete "${customer.name}"?'),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                final repo = ref.read(customerRepositoryProvider);
                
                try {
                  await repo.deleteCustomer(customer.id!);
                  final _ = ref.refresh(customerListProvider);
                  
                  if (ctx.mounted) {
                    Navigator.of(ctx).pop();
                  }
                } catch (e) {
                  if (ctx.mounted) {
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
