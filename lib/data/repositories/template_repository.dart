import '../../domain/entities/template.dart';
import '../../utils/template_schema.dart';
import '../datasources/local_storage.dart';

class TemplateRepository {
  final LocalStorage _store = LocalStorage.instance;

  TemplateRepository();

  Future<List<Template>> getAllTemplates() async => _store.getAllTemplates();

  Future<Template?> getTemplateById(int id) async {
    try {
      return _store.templates.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> createTemplate(Template template, [List<TemplateSection>? sections, List<TemplateField>? fields]) async {
    template.createdAt = DateTime.now();
    template.updatedAt = DateTime.now();
    _store.addTemplate(template);
  }

  Future<void> updateTemplate(Template template) async {
    template.updatedAt = DateTime.now();
    _store.updateTemplate(template);
  }

  Future<void> deleteTemplate(int id) async {
    _store.templates.removeWhere((t) => t.id == id);
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
}
