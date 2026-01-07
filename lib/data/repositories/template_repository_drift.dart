import 'package:drift/drift.dart';

import '../../domain/entities/template.dart';
import '../../utils/template_schema.dart';
import '../db/app_database.dart';

class TemplateRepositoryDrift {
  final AppDatabase _db;

  TemplateRepositoryDrift(this._db);

  Future<List<Template>> getAllTemplates() async {
    final rows = await _db.select(_db.templates).get();
    return rows.map(_mapTemplate).toList();
  }

  Future<Template?> getTemplateById(int id) async {
    final row = await (_db.select(_db.templates)..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : _mapTemplate(row);
  }

  Future<void> createTemplate(Template template, [List<TemplateSection>? sections, List<TemplateField>? fields]) async {
    final now = DateTime.now();
    template.createdAt = now;
    template.updatedAt = now;
    final id = await _db.into(_db.templates).insert(TemplatesCompanion.insert(
          name: template.name,
          description: Value(template.description),
          templateLogoPath: Value(template.templateLogoPath),
          schemaJson: template.schemaJson,
          createdAt: template.createdAt,
          updatedAt: template.updatedAt,
        ));
    template.id = id;
  }

  Future<void> updateTemplate(Template template) async {
    template.updatedAt = DateTime.now();
    await (_db.update(_db.templates)..where((t) => t.id.equals(template.id!))).write(
      TemplatesCompanion(
        name: Value(template.name),
        description: Value(template.description),
        templateLogoPath: Value(template.templateLogoPath),
        schemaJson: Value(template.schemaJson),
        updatedAt: Value(template.updatedAt),
      ),
    );
  }

  Future<void> deleteTemplate(int id) async {
    await (_db.delete(_db.templates)..where((t) => t.id.equals(id))).go();
  }

  Future<TemplateSchema> loadSchema(int templateId) async {
    final template = await getTemplateById(templateId);
    if (template == null) return TemplateSchema(sections: []);
    return TemplateSchema.fromJson(template.schemaJson);
  }

  Future<void> saveSchema(int templateId, TemplateSchema schema) async {
    final template = await getTemplateById(templateId);
    if (template != null) {
      template.schemaJson = schema.toJson();
      await updateTemplate(template);
    }
  }

  Future<List<TemplateSection>> getTemplateSections(int templateId) async => [];
  Future<List<TemplateField>> getSectionFields(int sectionId) async => [];
  Future<TemplateSection?> getSectionById(int id) async => null;
  Future<void> addSection(TemplateSection section) async {}
  Future<void> addField(TemplateField field) async {}
  Future<void> updateSection(TemplateSection section) async {}
  Future<void> updateField(TemplateField field) async {}
  Future<void> deleteSection(int id) async {}
  Future<void> deleteField(int id) async {}

  Template _mapTemplate(TemplateRow row) {
    return Template(
      id: row.id,
      name: row.name,
      description: row.description,
      templateLogoPath: row.templateLogoPath,
      schemaJson: row.schemaJson,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
