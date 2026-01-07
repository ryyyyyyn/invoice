import 'package:flutter/material.dart';
import 'package:invoice/core/widgets/neon_text_field.dart';
import 'package:invoice/core/widgets/neon_button.dart';
import 'package:invoice/utils/template_schema.dart';

class FieldEditorSheet extends StatefulWidget {
  final SchemaField? initialField;
  final Function(SchemaField) onSave;

  const FieldEditorSheet({super.key, this.initialField, required this.onSave});

  @override
  State<FieldEditorSheet> createState() => _FieldEditorSheetState();
}

class _FieldEditorSheetState extends State<FieldEditorSheet> {
  late final TextEditingController _labelCtrl;
  late final TextEditingController _keyCtrl;
  late final TextEditingController _optionsCtrl;
  late String _selectedType;
  late bool _required;
  late bool _showOnPdf;
  bool _keyManuallyEdited = false;

  static const List<String> fieldTypes = [
    'text',
    'multiline',
    'number',
    'currency',
    'date',
    'dateRange',
    'dropdown',
    'checkbox',
  ];

  @override
  void initState() {
    super.initState();
    final field = widget.initialField;
    _labelCtrl = TextEditingController(text: field?.label ?? '');
    _keyCtrl = TextEditingController(text: field?.key ?? '');
    _optionsCtrl = TextEditingController(text: field?.options?.join('\n') ?? '');
    _selectedType = field?.type ?? 'text';
    _required = field?.required ?? false;
    _showOnPdf = field?.showOnPdf ?? true;
    _keyManuallyEdited = (field?.key ?? '').isNotEmpty;
  }

  @override
  void dispose() {
    _labelCtrl.dispose();
    _keyCtrl.dispose();
    _optionsCtrl.dispose();
    super.dispose();
  }

  void _autoGenerateKey() {
    final key = SchemaField.generateKey(_labelCtrl.text);
    _keyCtrl.text = key;
  }

  void _onLabelChanged(String _) {
    if (_keyManuallyEdited) return;
    setState(_autoGenerateKey);
  }

  void _save() {
    final label = _labelCtrl.text.trim();
    final key = _keyCtrl.text.trim();

    if (label.isEmpty || key.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Label and key required')));
      return;
    }

    final options = _selectedType == 'dropdown'
        ? _optionsCtrl.text
            .split('\n')
            .map((o) => o.trim())
            .where((o) => o.isNotEmpty)
            .toList()
        : null;

    final field = SchemaField(
      id: widget.initialField?.id ?? DateTime.now().millisecondsSinceEpoch,
      key: key,
      label: label,
      type: _selectedType,
      required: _required,
      showOnPdf: _showOnPdf,
      options: options,
    );

    widget.onSave(field);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${widget.initialField == null ? 'Add' : 'Edit'} Field', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          NeonTextField(
            controller: _labelCtrl,
            label: 'Label *',
            hint: 'Field display name',
            onChanged: _onLabelChanged,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: NeonTextField(
                  controller: _keyCtrl,
                  label: 'Key (snake_case) *',
                  hint: 'field_key',
                  onChanged: (_) => setState(() => _keyManuallyEdited = true),
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(top: 28),
                child: ElevatedButton(
                  onPressed: () => setState(_autoGenerateKey),
                  child: const Text('Auto'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Type', style: Theme.of(context).textTheme.labelMedium),
              DropdownButton<String>(
                isExpanded: true,
                value: _selectedType,
                items: fieldTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (t) => setState(() => _selectedType = t ?? 'text'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_selectedType == 'dropdown')
            NeonTextField(
              controller: _optionsCtrl,
              label: 'Options (one per line)',
              hint: 'Option 1\nOption 2\nOption 3',
              maxLines: 3,
            ),
          if (_selectedType == 'dropdown') const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: CheckboxListTile(
                  title: const Text('Required'),
                  value: _required,
                  onChanged: (v) => setState(() => _required = v ?? false),
                ),
              ),
              Expanded(
                child: CheckboxListTile(
                  title: const Text('Show on PDF'),
                  value: _showOnPdf,
                  onChanged: (v) => setState(() => _showOnPdf = v ?? true),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          NeonButton(label: 'Save Field', onPressed: _save),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
