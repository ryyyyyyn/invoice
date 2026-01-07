class Template {
  int? id;

  late String name;
  String? description;
  String? templateLogoPath;
  
  // JSON schema: {sections:[{id, title, order, fields:[{id, key, label, type, required, showOnPdf, options}]}]}
  String schemaJson = '{"sections":[]}';

  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  Template({
    this.id,
    required this.name,
    this.description,
    this.templateLogoPath,
    this.schemaJson = '{"sections":[]}',
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();
}

class TemplateSection {
  int? id;

  late int templateId;
  late String title;
  late int order;
  String? description;

  DateTime createdAt = DateTime.now();

  TemplateSection({
    this.id,
    required this.templateId,
    required this.title,
    required this.order,
    this.description,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

class TemplateField {
  int? id;

  late int sectionId;
  late String key; // unique field key for JSON storage
  late String label;
  late String type; // text, multiline, number, currency, date, dateRange, dropdown, checkbox
  late bool required;
  late bool showOnPdf;
  late int order;

  // For dropdown options: JSON string ["option1", "option2"]
  String? optionsJson;

  DateTime createdAt = DateTime.now();

  TemplateField({
    this.id,
    required this.sectionId,
    required this.key,
    required this.label,
    required this.type,
    required this.required,
    required this.showOnPdf,
    required this.order,
    this.optionsJson,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
