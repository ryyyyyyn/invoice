# Invoice Pro - Developer Checklist & Next Steps

## ✅ What's Already Done

### Foundation (100% Complete)
- [x] Flutter project created with flutter create
- [x] All dependencies added to pubspec.yaml
- [x] Clean architecture folder structure created
- [x] Riverpod state management setup
- [x] GoRouter with bottom navigation implemented
- [x] Isar database with all collections defined
- [x] Theme system with dark neon colors
- [x] Reusable UI components (5 widgets)
- [x] All repositories created and ready
- [x] Invoice number generator utility
- [x] Home dashboard screen
- [x] Comprehensive documentation (4 guides)

### What Works Right Now
✅ App launches without crash  
✅ Bottom navigation works (4 tabs)  
✅ Theme applies across all screens  
✅ Database is initialized  
✅ Repositories are ready to use  
✅ Dark neon UI is consistent  

## 🔧 What Needs Implementation

### Phase 1: Critical Features (Must Do First)

#### 1. Invoice Wizard (Highest Priority)
**Files to Create**:
- `lib/presentation/screens/invoices/create_invoice_wizard.dart`
- `lib/presentation/screens/invoices/invoice_wizard_step1.dart`
- `lib/presentation/screens/invoices/invoice_wizard_step2.dart`
- `lib/presentation/screens/invoices/invoice_wizard_step3.dart`

**What It Does**:
- Step 1: Select template, customer, dates
- Step 2: Select/add invoice items
- Step 3: Choose payment type (Lunas/DP/Termin)

**Wiring Needed**:
```dart
// In invoice_list_screen.dart
FloatingActionButton(
  onPressed: () {
    context.push('/create-invoice');
  },
)

// In router.dart
GoRoute(
  path: '/create-invoice',
  builder: (context, state) => const CreateInvoiceWizard(),
)
```

**Data Flow**:
```
User Input → InvoiceWizard → InvoiceRepository.createInvoice()
                            → InvoiceNumberGenerator.generateNumber()
                            → Refresh invoiceListProvider
```

#### 2. Invoice List Screen
**File**: `lib/presentation/screens/invoices/invoice_list_screen.dart` (enhance existing)

**Features**:
- Show all invoices from database
- Filter chips: All, Draft, Partial Paid, Paid, Overdue
- Search by customer or invoice number
- Quick actions: View details, Share PDF, Mark as Paid

**Implementation**:
```dart
final invoiceListProvider = FutureProvider((ref) async {
  final repo = ref.watch(invoiceRepositoryProvider);
  return repo.getAllInvoices();
});

final invoiceFilterProvider = StateProvider<String>((ref) => 'all');

// In widget:
@override
Widget build(BuildContext context, WidgetRef ref) {
  final filter = ref.watch(invoiceFilterProvider);
  final invoicesAsync = ref.watch(invoiceListProvider);
  
  return invoicesAsync.when(
    data: (invoices) {
      final filtered = invoices.where((inv) {
        if (filter == 'all') return true;
        if (filter == 'draft') return inv.status == 'draft';
        // ... etc
        return false;
      }).toList();
      
      return Column(
        children: [
          // Filter chips
          // ListView with invoice cards
        ],
      );
    },
    // ...
  );
}
```

#### 3. PDF Generation Service
**File**: `lib/utils/pdf_generator_service.dart`

**Implementation**:
```dart
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfGeneratorService {
  static Future<Uint8List> generateInvoicePdf({
    required Invoice invoice,
    required Business business,
    required Customer customer,
    required List<InvoiceItem> items,
  }) async {
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            children: [
              // Header with logo and business info
              pw.Text(business.name, style: pw.TextStyle(fontSize: 24)),
              pw.Text(business.address),
              pw.SizedBox(height: 20),
              
              // Invoice number and dates
              pw.Text('Invoice ${invoice.number}'),
              pw.Text('Date: ${invoice.date}'),
              
              // Customer info
              pw.SizedBox(height: 20),
              pw.Text('Bill To: ${customer.name}'),
              
              // Items table
              pw.SizedBox(height: 20),
              pw.Table(
                children: [
                  // Header row
                  [
                    pw.Text('Item'),
                    pw.Text('Qty'),
                    pw.Text('Unit'),
                    pw.Text('Price'),
                    pw.Text('Total'),
                  ],
                  // Item rows
                  ...items.map((item) => [
                    pw.Text(item.name),
                    pw.Text(item.qty.toString()),
                    pw.Text(item.unit),
                    pw.Text('${item.price}'),
                    pw.Text('${item.qty * item.price}'),
                  ]),
                ],
              ),
              
              // Summary
              pw.SizedBox(height: 20),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('Subtotal: ${invoice.subtotal}'),
                    pw.Text('Discount: ${invoice.discount}'),
                    pw.Text('Tax: ${invoice.tax}'),
                    pw.Text('Total: ${invoice.grandTotal}',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
    
    return pdf.save();
  }
}
```

**Usage in Wizard Step 3**:
```dart
final pdfBytes = await PdfGeneratorService.generateInvoicePdf(
  invoice: invoice,
  business: business,
  customer: customer,
  items: items,
);

// Preview: use pdf viewer widget
// Share: use share_plus package
await Share.shareXFiles([
  XFile.fromData(pdfBytes, name: 'invoice_${invoice.number}.pdf')
]);
```

### Phase 2: Important Features

#### 4. Template Builder
**Files**:
- `lib/presentation/screens/templates/template_list_screen.dart`
- `lib/presentation/screens/templates/template_editor_screen.dart`
- `lib/presentation/screens/templates/template_field_editor.dart`

**Key Features**:
- Add/edit/delete templates
- Add sections to template
- Add fields to sections (with type, label, required, showOnPdf)
- Field type selector (text, number, currency, date, dropdown, etc)

**Implementation Pattern**:
```dart
// Template list
final templateListProvider = FutureProvider((ref) async {
  final repo = ref.watch(templateRepositoryProvider);
  return repo.getAllTemplates();
});

// Template sections
final templateSectionsProvider = FutureProvider.family(
  (ref, int templateId) async {
    final repo = ref.watch(templateRepositoryProvider);
    return repo.getTemplateSections(templateId);
  },
);

// Template fields
final templateFieldsProvider = FutureProvider.family(
  (ref, int sectionId) async {
    final repo = ref.watch(templateRepositoryProvider);
    return repo.getSectionFields(sectionId);
  },
);
```

#### 5. Catalog Management
**File**: `lib/presentation/screens/catalog/catalog_list_screen.dart`

**Features**:
- List all catalog items
- Search by name
- Filter by category
- Add/edit/delete items
- Quick add to invoice (from invoice wizard)

**Structure**:
```dart
final catalogListProvider = FutureProvider((ref) async {
  final repo = ref.watch(catalogRepositoryProvider);
  return repo.getAllItems();
});

final catalogSearchProvider = StateProvider<String>((ref) => '');
```

#### 6. Form Validations & Error Handling
**File**: `lib/utils/validators.dart`

```dart
class Validators {
  static String? validateRequired(String? value) {
    if (value?.isEmpty ?? true) return 'This field is required';
    return null;
  }
  
  static String? validateEmail(String? value) {
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value ?? '')) {
      return 'Please enter a valid email';
    }
    return null;
  }
  
  static String? validatePhone(String? value) {
    if (!RegExp(r'^[0-9]+$').hasMatch(value?.replaceAll(' ', '') ?? '')) {
      return 'Please enter a valid phone number';
    }
    return null;
  }
}
```

## 📋 Implementation Checklist

### Before You Start
- [ ] Run `flutter pub get`
- [ ] Run `dart run build_runner build --delete-conflicting-outputs`
- [ ] Verify `flutter run` works without errors
- [ ] Understand clean architecture (read CODE_ARCHITECTURE.md)

### Invoice Features
- [ ] Create invoice wizard (3 steps)
- [ ] Enhance invoice list screen
- [ ] Connect wizard to repository
- [ ] Test create invoice flow
- [ ] Add PDF preview to step 3
- [ ] Implement PDF sharing

### Supporting Features
- [ ] Template builder UI
- [ ] Catalog CRUD screens
- [ ] Form validations
- [ ] Error handling
- [ ] Empty states
- [ ] Loading states

### Testing
- [ ] Test on Android device
- [ ] Verify offline functionality
- [ ] Test all navigation
- [ ] Test database persistence
- [ ] Test PDF generation
- [ ] Test sharing

### Play Store Preparation
- [ ] Generate app icon (all sizes)
- [ ] Update app name in manifest
- [ ] Configure package ID
- [ ] Update version in pubspec.yaml
- [ ] Create privacy policy
- [ ] Write release notes
- [ ] Build release APK
- [ ] Build app bundle

## 🎯 Priority Order

```
1. ⚡ Invoice Wizard (3 steps) - MUST HAVE
   └─ Then: PDF generation + sharing

2. 🔄 Invoice List + Filters - MUST HAVE
   └─ Then: Quick actions (share, mark paid)

3. 📝 Template Builder - IMPORTANT
   └─ Then: Template testing in invoice wizard

4. 📚 Catalog Management - IMPORTANT
   └─ Then: Integration with invoice items

5. ✨ Polish & Validation - NICE TO HAVE
   └─ Then: Play Store release preparation
```

## 💡 Development Tips

### Quick Reference: Riverpod Pattern
```dart
// 1. Define provider
final itemListProvider = FutureProvider((ref) async {
  final repo = ref.watch(repositoryProvider);
  return repo.getAll();
});

// 2. Use in widget
final itemsAsync = ref.watch(itemListProvider);

// 3. Refresh after mutation
ref.refresh(itemListProvider);

// 4. Combine multiple providers
final combinedProvider = FutureProvider((ref) async {
  final items = await ref.watch(itemListProvider.future);
  final stats = await ref.watch(statsProvider.future);
  return (items, stats);
});
```

### Quick Reference: Navigation
```dart
// Push
context.push('/route-path', extra: data);

// Go (replace)
context.go('/home');

// Pop
context.pop();

// Named
context.go('/invoices', extra: invoiceId);
```

### Quick Reference: Forms
```dart
// Validate
if (_formKey.currentState!.validate()) {
  // Save
  _formKey.currentState!.save();
}

// Show error
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Error message')),
);
```

## 📚 Useful Resources

- **Riverpod Examples**: Check providers.dart
- **Widget Examples**: Check presentation/widgets/
- **Repository Examples**: Check data/repositories/
- **Screen Examples**: Check presentation/screens/

## 🚀 Next Developer Instructions

1. Start with Invoice Wizard
2. Follow the pattern in existing code
3. Use provided component widgets
4. Test on device frequently
5. Commit working features
6. Update documentation as you go

## 📞 Common Issues & Solutions

### Isar Generated Files Missing
```bash
# Solution: Run build_runner
dart run build_runner build --delete-conflicting-outputs
```

### Hot Reload Not Working
```bash
# Solution: Clean and rebuild
flutter clean
flutter pub get
flutter run
```

### Provider Not Updating
```dart
# Solution: Use refresh
ref.refresh(providerName);
```

### Form Not Validating
```dart
# Solution: Ensure FormKey used with FormField
final _formKey = GlobalKey<FormState>();

Form(
  key: _formKey,
  child: TextFormField(
    validator: (value) { ... }
  ),
)
```

---

**Start Here**: Open `lib/presentation/screens/invoices/invoice_list_screen.dart` and begin with the Invoice Wizard implementation.

Good luck! 🚀
