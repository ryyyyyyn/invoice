import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:invoice/core/widgets/neon_card.dart';
import 'package:invoice/core/widgets/neon_text_field.dart';
import 'package:invoice/core/widgets/neon_button.dart';
import 'package:invoice/application/providers/providers.dart';
import 'package:invoice/domain/entities/template.dart';
import 'package:invoice/utils/template_schema.dart';
import 'package:invoice/presentation/widgets/field_editor_sheet.dart';

class TemplateEditorScreen extends ConsumerStatefulWidget {
  final int templateId;

  const TemplateEditorScreen({super.key, required this.templateId});

  @override
  ConsumerState<TemplateEditorScreen> createState() => _TemplateEditorScreenState();
}

class _TemplateEditorScreenState extends ConsumerState<TemplateEditorScreen> {
  late TemplateSchema _schema;
  late Template _template;
  bool _loading = true;
  bool _notFound = false;

  @override
  void initState() {
    super.initState();
    _loadTemplate();
  }

  Future<void> _loadTemplate() async {
    final repo = ref.read(templateRepositoryProvider);
    final template = await repo.getTemplateById(widget.templateId);
    if (template == null) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _notFound = true;
      });
      return;
    }
    setState(() {
      _template = template;
      _schema = TemplateSchema.fromJson(template.schemaJson);
      _loading = false;
    });
  }

  Future<void> _saveTemplate() async {
    _template.schemaJson = _schema.toJson();
    _template.updatedAt = DateTime.now();
    final repo = ref.read(templateRepositoryProvider);
    await repo.updateTemplate(_template);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Template saved')));
  }

  void _addSection() {
    final titleCtrl = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Section'),
        content: NeonTextField(controller: titleCtrl, label: 'Section Title'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final title = titleCtrl.text.trim();
              if (title.isEmpty) return;
              setState(() {
                final newOrder = (_schema.sections.isNotEmpty ? _schema.sections.last.order : 0) + 1;
                _schema.sections.add(
                  SchemaSection(
                    id: DateTime.now().millisecondsSinceEpoch,
                    title: title,
                    order: newOrder,
                  ),
                );
              });
              Navigator.of(ctx).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _editSectionTitle(SchemaSection section) {
    final titleCtrl = TextEditingController(text: section.title);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Section'),
        content: NeonTextField(controller: titleCtrl, label: 'Section Title'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final title = titleCtrl.text.trim();
              if (title.isNotEmpty) {
                setState(() => section.title = title);
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteSection(SchemaSection section) {
    setState(() => _schema.sections.removeWhere((s) => s.id == section.id));
  }

  void _moveSection(SchemaSection section, bool up) {
    final idx = _schema.sections.indexWhere((s) => s.id == section.id);
    if ((up && idx > 0) || (!up && idx < _schema.sections.length - 1)) {
      setState(() {
        final newIdx = up ? idx - 1 : idx + 1;
        final temp = _schema.sections[idx];
        _schema.sections[idx] = _schema.sections[newIdx];
        _schema.sections[newIdx] = temp;
        // Update order
        for (int i = 0; i < _schema.sections.length; i++) {
          _schema.sections[i].order = i + 1;
        }
      });
    }
  }

  void _addField(SchemaSection section) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => FieldEditorSheet(
        onSave: (field) {
          setState(() => section.fields.add(field));
        },
      ),
    );
  }

  Future<void> _pickTemplateLogo() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() => _template.templateLogoPath = image.path);
  }

  void _removeTemplateLogo() {
    setState(() => _template.templateLogoPath = null);
  }

  Widget _buildTemplateLogoSection(BuildContext context) {
    final logoPath = _template.templateLogoPath;
    final hasLogo = logoPath != null && File(logoPath).existsSync();
    return NeonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Template Logo', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (hasLogo)
            Container(
              height: 80,
              width: 120,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: Image.file(File(logoPath), fit: BoxFit.contain),
            )
          else
            const Text('No logo selected.'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: NeonButton(
                  label: 'Upload Logo',
                  onPressed: _pickTemplateLogo,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: NeonButton(
                  label: 'Remove Logo',
                  onPressed: _template.templateLogoPath == null ? () {} : _removeTemplateLogo,
                  isOutlined: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _editField(SchemaSection section, SchemaField field) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => FieldEditorSheet(
        initialField: field,
        onSave: (updatedField) {
          setState(() {
            final idx = section.fields.indexWhere((f) => f.id == field.id);
            if (idx >= 0) section.fields[idx] = updatedField;
          });
        },
      ),
    );
  }

  void _deleteField(SchemaSection section, SchemaField field) {
    setState(() => section.fields.removeWhere((f) => f.id == field.id));
  }

  void _moveField(SchemaSection section, SchemaField field, bool up) {
    final idx = section.fields.indexWhere((f) => f.id == field.id);
    if ((up && idx > 0) || (!up && idx < section.fields.length - 1)) {
      setState(() {
        final newIdx = up ? idx - 1 : idx + 1;
        final temp = section.fields[idx];
        section.fields[idx] = section.fields[newIdx];
        section.fields[newIdx] = temp;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Template Editor')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_notFound) {
      return Scaffold(
        appBar: AppBar(title: const Text('Template Editor')),
        body: const Center(child: Text('Template not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_template.name),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveTemplate),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTemplateLogoSection(context),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sections', style: Theme.of(context).textTheme.headlineSmall),
                NeonButton(label: 'Add Section', onPressed: _addSection),
              ],
            ),
            const SizedBox(height: 12),
            if (_schema.sections.isEmpty)
              const Text('No sections yet. Create one to start building your template.')
            else
              Column(
                children: _schema.sections.map((section) {
                  final idx = _schema.sections.indexOf(section);
                  final canMoveUp = idx > 0;
                  final canMoveDown = idx < _schema.sections.length - 1;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: NeonCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(section.title, style: Theme.of(context).textTheme.titleMedium),
                              ),
                              Row(
                                children: [
                                  if (canMoveUp)
                                    IconButton(
                                      icon: const Icon(Icons.arrow_upward),
                                      onPressed: () => _moveSection(section, true),
                                    ),
                                  if (canMoveDown)
                                    IconButton(
                                      icon: const Icon(Icons.arrow_downward),
                                      onPressed: () => _moveSection(section, false),
                                    ),
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () => _editSectionTitle(section),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _deleteSection(section),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text('Fields (${section.fields.length})', style: Theme.of(context).textTheme.labelMedium),
                          const SizedBox(height: 8),
                          if (section.fields.isEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text('No fields. Add one below.'),
                            )
                          else
                            Column(
                              children: section.fields.asMap().entries.map((entry) {
                                final fieldIdx = entry.key;
                                final field = entry.value;
                                final canMoveUp = fieldIdx > 0;
                                final canMoveDown = fieldIdx < section.fields.length - 1;

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey[700]!),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: ListTile(
                                      title: Text(field.label),
                                      subtitle: Text(field.key),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Chip(label: Text(field.type, style: const TextStyle(fontSize: 10))),
                                          if (field.required) const Chip(label: Text('R', style: TextStyle(fontSize: 10))),
                                          if (canMoveUp)
                                            IconButton(
                                              icon: const Icon(Icons.arrow_upward, size: 18),
                                              onPressed: () => _moveField(section, field, true),
                                            ),
                                          if (canMoveDown)
                                            IconButton(
                                              icon: const Icon(Icons.arrow_downward, size: 18),
                                              onPressed: () => _moveField(section, field, false),
                                            ),
                                          IconButton(
                                            icon: const Icon(Icons.edit, size: 18),
                                            onPressed: () => _editField(section, field),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.close, size: 18, color: Colors.red),
                                            onPressed: () => _deleteField(section, field),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          const SizedBox(height: 12),
                          NeonButton(
                            label: 'Add Field',
                            onPressed: () => _addField(section),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
