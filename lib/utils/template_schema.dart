import 'dart:convert';

class TemplateSchema {
  final List<SchemaSection> sections;

  TemplateSchema({required this.sections});

  factory TemplateSchema.fromJson(String json) {
    try {
      final data = jsonDecode(json) as Map<String, dynamic>;
      final sectionsData = (data['sections'] as List<dynamic>?) ?? [];
      final sections = sectionsData.map((s) => SchemaSection.fromMap(s as Map<String, dynamic>)).toList();
      return TemplateSchema(sections: sections);
    } catch (e) {
      return TemplateSchema(sections: []);
    }
  }

  String toJson() {
    return jsonEncode({'sections': sections.map((s) => s.toMap()).toList()});
  }
}

class SchemaSection {
  final int id;
  late String title;
  late int order;
  final List<SchemaField> fields;

  SchemaSection({required this.id, required this.title, required this.order, List<SchemaField>? fields})
      : fields = fields ?? [];

  factory SchemaSection.fromMap(Map<String, dynamic> map) {
    final fieldsData = (map['fields'] as List<dynamic>?) ?? [];
    final fields = fieldsData.map((f) => SchemaField.fromMap(f as Map<String, dynamic>)).toList();
    return SchemaSection(
      id: map['id'] as int? ?? 0,
      title: map['title'] as String? ?? '',
      order: map['order'] as int? ?? 0,
      fields: fields,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'order': order,
      'fields': fields.map((f) => f.toMap()).toList(),
    };
  }
}

class SchemaField {
  final int id;
  late String key; // auto-generated snake_case
  late String label;
  late String type; // text, multiline, number, currency, date, dateRange, dropdown, checkbox
  late bool required;
  late bool showOnPdf;
  late List<String>? options; // for dropdown

  SchemaField({
    required this.id,
    required this.key,
    required this.label,
    required this.type,
    required this.required,
    required this.showOnPdf,
    this.options,
  });

  factory SchemaField.fromMap(Map<String, dynamic> map) {
    final optionsData = map['options'];
    List<String>? options;
    if (optionsData != null) {
      options = List<String>.from(optionsData as List<dynamic>);
    }
    return SchemaField(
      id: map['id'] as int? ?? 0,
      key: map['key'] as String? ?? '',
      label: map['label'] as String? ?? '',
      type: map['type'] as String? ?? 'text',
      required: map['required'] as bool? ?? false,
      showOnPdf: map['showOnPdf'] as bool? ?? true,
      options: options,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'key': key,
      'label': label,
      'type': type,
      'required': required,
      'showOnPdf': showOnPdf,
      'options': options,
    };
  }

  static String generateKey(String label) {
    return label
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
  }
}
