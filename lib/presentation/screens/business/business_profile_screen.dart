import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:invoice/core/widgets/neon_card.dart';
import 'package:invoice/core/widgets/neon_text_field.dart';
import 'package:invoice/core/widgets/neon_button.dart';
import 'package:invoice/application/providers/providers.dart';
import 'package:invoice/domain/entities/business.dart';
import 'package:invoice/utils/invoice_number_generator.dart';

class BusinessProfileScreen extends ConsumerStatefulWidget {
  const BusinessProfileScreen({super.key});

  @override
  ConsumerState<BusinessProfileScreen> createState() => _BusinessProfileScreenState();
}

class _BusinessProfileScreenState extends ConsumerState<BusinessProfileScreen> {
  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _prefixCtrl = TextEditingController(text: 'INV');
  final _counterCtrl = TextEditingController();

  Business? _business;
  String? _logoPath;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadBusiness();
  }

  Future<void> _loadBusiness() async {
    final repo = ref.read(businessRepositoryProvider);
    final b = await repo.getOrCreateBusiness();
    if (!mounted) return;
    setState(() {
      _business = b;
      _nameCtrl.text = b.name;
      _addressCtrl.text = b.address;
      _phoneCtrl.text = b.phone;
      _emailCtrl.text = b.email;
      _prefixCtrl.text = b.invoicePrefix ?? 'INV';
      _counterCtrl.text = b.invoiceCounter.toString();
      _logoPath = b.logoPath;
      _loading = false;
    });
  }

  Future<void> _pickLogo() async {
    final picker = ImagePicker();
    final result = await picker.pickImage(source: ImageSource.gallery);
    if (result == null) return;
    setState(() => _logoPath = result.path);
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Business name is required')));
      return;
    }

    final repo = ref.read(businessRepositoryProvider);
    final b = _business ?? Business(name: _nameCtrl.text.trim(), address: '', phone: '', email: '');
    b.name = _nameCtrl.text.trim();
    b.address = _addressCtrl.text.trim();
    b.phone = _phoneCtrl.text.trim();
    b.email = _emailCtrl.text.trim();
    b.invoicePrefix = _prefixCtrl.text.trim().isEmpty ? 'INV' : _prefixCtrl.text.trim();
    b.invoiceCounter = int.tryParse(_counterCtrl.text.trim()) ?? b.invoiceCounter;
    b.counterYear = b.counterYear == 0 ? DateTime.now().year : b.counterYear;
    b.logoPath = _logoPath;

    await repo.updateBusiness(b);
    if (!mounted) return;
    setState(() => _business = b);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Business saved')));
  }

  void _testGenerate() {
    if (_business == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Load business first')));
      return;
    }

    // Clone business to avoid incrementing real counter
    final clone = Business(
      id: _business!.id,
      name: _business!.name,
      address: _business!.address,
      phone: _business!.phone,
      email: _business!.email,
      logoPath: _business!.logoPath,
      invoicePrefix: _business!.invoicePrefix,
      invoiceCounter: _business!.invoiceCounter,
      counterYear: _business!.counterYear,
      themeColor: _business!.themeColor,
    );

    final sample = InvoiceNumberGenerator.generateNumber(clone);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sample Invoice Number'),
        content: Text(sample),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Close')),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _prefixCtrl.dispose();
    _counterCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Business Profile')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Business Information', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 24),
                  NeonCard(
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(child: NeonTextField(label: 'Business Name', controller: _nameCtrl, isRequired: true)),
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: _pickLogo,
                              child: _logoPath == null
                                  ? Container(width: 64, height: 64, color: Colors.grey[900], child: const Icon(Icons.camera_alt))
                                  : Image.file(File(_logoPath!), width: 64, height: 64, fit: BoxFit.cover),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        NeonTextField(label: 'Address', controller: _addressCtrl, maxLines: 3, minLines: 2),
                        const SizedBox(height: 16),
                        NeonTextField(label: 'Phone', controller: _phoneCtrl, keyboardType: TextInputType.phone),
                        const SizedBox(height: 16),
                        NeonTextField(label: 'Email', controller: _emailCtrl, keyboardType: TextInputType.emailAddress),
                        const SizedBox(height: 16),
                        NeonTextField(label: 'Invoice Prefix', controller: _prefixCtrl, hint: 'e.g., INV'),
                        const SizedBox(height: 16),
                        Row(children: [
                          Expanded(child: NeonTextField(label: 'Counter', controller: _counterCtrl, keyboardType: TextInputType.number)),
                          const SizedBox(width: 12),
                          Expanded(child: NeonTextField(label: 'Counter Year', controller: TextEditingController(text: (_business?.counterYear ?? DateTime.now().year).toString()), keyboardType: TextInputType.number)),
                        ]),
                        const SizedBox(height: 24),
                        Row(children: [
                          Expanded(child: NeonButton(label: 'Save', onPressed: _save)),
                          const SizedBox(width: 12),
                          NeonButton(label: 'Test Generate', onPressed: _testGenerate),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
