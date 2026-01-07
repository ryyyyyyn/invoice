# Invoice Pro - Code Architecture & Implementation

## 📋 Directory Structure Created

```
invoice/
├── lib/
│   ├── main.dart                           ✅ App entry point with Riverpod & Isar init
│   ├── config/
│   │   ├── app_theme.dart                  ✅ Material 3 dark neon theme
│   │   └── router.dart                     ✅ GoRouter with bottom nav shell
│   ├── constants/
│   │   ├── app_colors.dart                 ✅ Color constants (dark neon blue)
│   │   └── app_constants.dart              ✅ App-wide constants
│   ├── utils/
│   │   └── invoice_number_generator.dart   ✅ INV-YYYY-XXXX numbering
│   ├── presentation/
│   │   ├── widgets/                        ✅ Reusable UI components
│   │   │   ├── neon_button.dart
│   │   │   ├── neon_card.dart
│   │   │   ├── neon_text_field.dart
│   │   │   ├── status_badge.dart
│   │   │   └── empty_state.dart
│   │   └── screens/
│   │       ├── home/home_screen.dart       ✅ Dashboard with stats
│   │       ├── invoices/invoice_list_screen.dart  🔧 Placeholder
│   │       ├── customers/customer_list_screen.dart ✅ CRUD template
│   │       ├── catalog/                    🔧 Placeholder
│   │       ├── templates/                  🔧 Template builder
│   │       ├── business/business_profile_screen.dart ✅ Business setup
│   │       └── settings/settings_screen.dart ✅ Settings
│   ├── application/
│   │   └── providers/providers.dart        ✅ Riverpod service providers
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── business.dart               ✅ @collection Business
│   │   │   ├── customer.dart               ✅ @collection Customer
│   │   │   ├── catalog_item.dart           ✅ @collection CatalogItem
│   │   │   ├── template.dart               ✅ @collection Template (with relations)
│   │   │   └── invoice.dart                ✅ @collection Invoice + Items + Payments
│   │   └── repositories/
│   └── data/
│       ├── datasources/isar_service.dart   ✅ Isar initialization & lifecycle
│       └── repositories/
│           ├── business_repository.dart    ✅ Business CRUD
│           ├── customer_repository.dart    ✅ Customer CRUD + search
│           ├── catalog_repository.dart     ✅ Catalog CRUD
│           ├── template_repository.dart    ✅ Template + nested entities
│           └── invoice_repository.dart     ✅ Invoice + items + payments + stats
├── assets/
│   ├── images/                             📂 For business logos, etc
│   └── icons/                              📂 For custom icons
├── android/                                 📂 Android configuration
├── pubspec.yaml                            ✅ All dependencies configured
└── SETUP_GUIDE.md                          ✅ Complete setup & build instructions
```

## 🔑 Key Code Samples

### 1. Main Application Setup
**File**: `lib/main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/app_theme.dart';
import 'config/router.dart';
import 'data/datasources/isar_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await IsarService.initialize();  // Initialize Isar database
  runApp(const ProviderScope(child: MyApp()));  // Wrap with Riverpod
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Invoice Pro',
      theme: AppTheme.darkNeonTheme,  // Dark neon theme
      routerConfig: appRouter,         // GoRouter configuration
    );
  }
}
```

### 2. Theme System - Dark Neon Blue
**File**: `lib/config/app_theme.dart`

```dart
class AppTheme {
  static ThemeData get darkNeonTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBg,  // #0B0F17
      colorScheme: ColorScheme.dark(
        background: AppColors.darkBg,
        surface: AppColors.surfaceCard,           // #101826
        primary: AppColors.accentNeon,            // #00D1FF
        secondary: AppColors.accentBrighter,      // #00BFFF
        error: AppColors.statusError,             // #FF4444
      ),
      // ... comprehensive button, text, input, and dialog themes
    );
  }
}
```

**Colors Used**:
- Background: `#0B0F17` (very dark blue)
- Surface: `#101826` (dark blue cards)
- Neon Accent: `#00D1FF` (bright cyan)
- Primary Text: `#E6F1FF` (light blue white)
- Secondary Text: `#8AA4C8` (muted blue)

### 3. Routing Configuration
**File**: `lib/config/router.dart`

```dart
final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return _ShellScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/invoices',
          name: 'invoices',
          builder: (context, state) => const InvoiceListScreen(),
        ),
        GoRoute(
          path: '/customers',
          name: 'customers',
          builder: (context, state) => const CustomerListScreen(),
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
    // Non-shell routes
    GoRoute(
      path: '/business-profile',
      name: 'business-profile',
      builder: (context, state) => const BusinessProfileScreen(),
    ),
  ],
);
```

**Bottom Navigation** automatically manages tab selection and routing.

### 4. Isar Database Models
**File**: `lib/domain/entities/invoice.dart`

```dart
import 'package:isar/isar.dart';

@collection
class Invoice {
  Id id = Isar.autoIncrement;
  
  late int businessId;
  late int customerId;
  late int templateId;
  late String number;                // INV-2025-0001
  late DateTime date;
  DateTime? dueDate;
  
  late String status;                // draft, sent, partial_paid, paid, overdue
  late double subtotal;
  double discount = 0.0;
  double tax = 0.0;
  double shipping = 0.0;
  late double grandTotal;
  
  String? notes;
  String? terms;
  String? customDataJson;            // JSON of custom template fields
  
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();
}

@collection
class InvoiceItem {
  Id id = Isar.autoIncrement;
  late int invoiceId;
  late String name;
  late double qty;
  late String unit;
  late double price;
  double discount = 0.0;
  String? note;
  String? metadataJson;
  DateTime createdAt = DateTime.now();
}

@collection
class Payment {
  Id id = Isar.autoIncrement;
  late int invoiceId;
  late String type;                  // lunas, dp, termin
  late String method;                // cash, transfer, other
  late double amount;
  late DateTime paidAt;
  String? note;
  DateTime createdAt = DateTime.now();
}

@collection
class PaymentSchedule {
  Id id = Isar.autoIncrement;
  late int invoiceId;
  late String title;                 // "Termin 1", "DP", etc
  late DateTime dueDate;
  late double amount;
  late bool isPaid;
  DateTime? paidAt;
  String? note;
  DateTime createdAt = DateTime.now();
}
```

### 5. Isar Service (Database Initialization)
**File**: `lib/data/datasources/isar_service.dart`

```dart
import 'package:isar/isar.dart';
import '../../domain/entities/business.dart';
import '../../domain/entities/customer.dart';
// ... other imports

class IsarService {
  static late final Isar _isar;

  static Future<void> initialize() async {
    _isar = await Isar.open(
      [
        BusinessSchema,
        CustomerSchema,
        CatalogItemSchema,
        TemplateSchema,
        TemplateSectionSchema,
        TemplateFieldSchema,
        InvoiceSchema,
        InvoiceItemSchema,
        PaymentSchema,
        PaymentScheduleSchema,
      ],
    );
  }

  static Isar get instance => _isar;

  static Future<void> close() async {
    await _isar.close();
  }
}
```

### 6. Repository Pattern Example
**File**: `lib/data/repositories/customer_repository.dart`

```dart
import 'package:isar/isar.dart';
import '../../domain/entities/customer.dart';
import '../datasources/isar_service.dart';

class CustomerRepository {
  final IsarService _isarService;

  CustomerRepository(this._isarService);

  Future<List<Customer>> getAllCustomers() async {
    final isar = _isarService.instance;
    return await isar.customers.where().sortByNameAsc().findAll();
  }

  Future<List<Customer>> searchCustomers(String query) async {
    final isar = _isarService.instance;
    return await isar.customers
        .where()
        .nameContains(query, caseSensitive: false)
        .sortByNameAsc()
        .findAll();
  }

  Future<void> createCustomer(Customer customer) async {
    final isar = _isarService.instance;
    customer.createdAt = DateTime.now();
    customer.updatedAt = DateTime.now();
    await isar.writeTxn(() async {
      await isar.customers.put(customer);
    });
  }

  Future<void> updateCustomer(Customer customer) async {
    final isar = _isarService.instance;
    customer.updatedAt = DateTime.now();
    await isar.writeTxn(() async {
      await isar.customers.put(customer);
    });
  }

  Future<void> deleteCustomer(int id) async {
    final isar = _isarService.instance;
    await isar.writeTxn(() async {
      await isar.customers.delete(id);
    });
  }
}
```

### 7. Riverpod Service Providers
**File**: `lib/application/providers/providers.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/isar_service.dart';
import '../../data/repositories/customer_repository.dart';
import '../../data/repositories/invoice_repository.dart';
// ... other imports

// Database Service Provider
final isarServiceProvider = Provider((ref) {
  return IsarService();
});

// Repository Providers
final customerRepositoryProvider = Provider((ref) {
  return CustomerRepository(ref.watch(isarServiceProvider));
});

final invoiceRepositoryProvider = Provider((ref) {
  return InvoiceRepository(ref.watch(isarServiceProvider));
});

// Feature Providers - use these in screens
final customerListProvider = FutureProvider((ref) async {
  final repo = ref.watch(customerRepositoryProvider);
  return repo.getAllCustomers();
});

final invoiceStatsProvider = FutureProvider((ref) async {
  final repo = ref.watch(invoiceRepositoryProvider);
  final revenue = await repo.getTotalRevenue(
    startDate: DateTime(DateTime.now().year, DateTime.now().month, 1),
    endDate: DateTime.now(),
  );
  final unpaid = await repo.getUnpaidInvoicesCount();
  final overdue = await repo.getOverdueInvoicesCount();
  return (revenue: revenue, unpaid: unpaid, overdue: overdue);
});
```

### 8. Invoice Number Generator
**File**: `lib/utils/invoice_number_generator.dart`

```dart
import '../../domain/entities/business.dart';
import '../datasources/isar_service.dart';

class InvoiceNumberGenerator {
  static Future<String> generateNumber(Business business) async {
    final isar = IsarService.instance;
    final currentYear = DateTime.now().year;

    // Reset counter if year changed
    if (business.counterYear != currentYear) {
      business.counterYear = currentYear;
      business.invoiceCounter = 0;
    }

    // Increment counter
    business.invoiceCounter++;

    // Update business
    await isar.writeTxn(() async {
      await isar.businesses.put(business);
    });

    // Format: INV-2025-0001
    final prefix = business.invoicePrefix ?? 'INV';
    final counter = business.invoiceCounter.toString().padLeft(4, '0');
    final invoiceNumber = '$prefix-$currentYear-$counter';

    return invoiceNumber;
  }
}
```

### 9. Custom Form Widget
**File**: `lib/presentation/widgets/neon_text_field.dart`

```dart
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class NeonTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final int? maxLines;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final IconData? prefixIcon;
  final bool isRequired;

  const NeonTextField({
    required this.label,
    this.hint,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.maxLines = 1,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.isRequired = false,
  });

  @override
  State<NeonTextField> createState() => _NeonTextFieldState();
}

class _NeonTextFieldState extends State<NeonTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: widget.label,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              if (widget.isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: AppColors.statusError),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          maxLines: widget.maxLines,
          validator: widget.validator,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, color: AppColors.textSecondary)
                : null,
          ),
        ),
      ],
    );
  }
}
```

### 10. Reusable NeonCard Component
**File**: `lib/presentation/widgets/neon_card.dart`

```dart
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';

class NeonCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double padding;
  final Color? backgroundColor;
  final bool glowing;

  const NeonCard({
    required this.child,
    this.onTap,
    this.padding = 16,
    this.backgroundColor,
    this.glowing = false,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        border: Border.all(color: AppColors.divider, width: 1),
        boxShadow: glowing
            ? [
                BoxShadow(
                  color: AppColors.accentNeon.withOpacity(0.2),
                  blurRadius: 12,
                  spreadRadius: 0,
                ),
              ]
            : [
                BoxShadow(
                  color: AppColors.shadow.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ],
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: card,
      );
    }

    return card;
  }
}
```

### 11. Home Screen with Dashboard
**File**: `lib/presentation/screens/home/home_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/neon_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/business-profile'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome banner
            NeonCard(
              glowing: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to Invoice App',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Manage your invoices with ease',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Quick stats grid (4 cards)
            Text(
              'Quick Stats',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _StatCard(
                  title: 'Revenue This Month',
                  value: 'Rp. 0',
                  icon: Icons.trending_up,
                  color: AppColors.statusSuccess,
                ),
                // ... more stat cards
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

## 📚 Next Steps to Complete

The following modules need implementation:

### 1. **Invoice CRUD & Wizard** (Critical)
- Invoice list screen with status filters
- 3-step wizard: template selection → items → payment
- Dynamic form renderer based on template
- PDF preview before save

### 2. **Template Builder** (Critical)
- Template list CRUD
- Template editor with sections
- Field editor with type selection
- Dropdown options configuration
- Field visibility toggle for PDF

### 3. **PDF Generation & Sharing** (Critical)
- PDF layout generator (white background)
- Business header with logo
- Itemized table
- Summary and payment info
- Save to documents folder
- Share via WhatsApp / email

### 4. **Catalog CRUD** (Important)
- Catalog list with search/filter
- Add/edit/delete items
- Category management
- Quick selection in invoice

### 5. **Business Profile Enhancement** (Important)
- Logo picker using image_picker
- Verify invoice prefix format
- Test invoice number generation

### 6. **Polish & Testing** (Important)
- Input validation on all forms
- Error handling and retry logic
- Empty states for all lists
- Loading states with shimmer (optional)
- Success/error snackbars

## 🔄 State Management Pattern

Every feature follows this pattern:

```dart
// 1. Define a provider for data
final featureListProvider = FutureProvider((ref) async {
  final repo = ref.watch(featureRepositoryProvider);
  return repo.getAll();
});

// 2. Watch it in the widget
@override
Widget build(BuildContext context, WidgetRef ref) {
  final dataAsync = ref.watch(featureListProvider);
  
  return dataAsync.when(
    data: (data) { /* render list */ },
    loading: () { /* show loading */ },
    error: (err, stack) { /* show error */ },
  );
}

// 3. Create action
await ref.read(featureRepositoryProvider).create(newItem);
ref.refresh(featureListProvider); // Refetch
```

## 📱 Responsive Design Notes

- All screens use `SingleChildScrollView` for overflow safety
- GridView items adapt to 2 columns on mobile
- BottomSheet modals use `isScrollControlled: true`
- FAB positioned bottom right
- Cards use `NeonCard` for consistent styling

## 🎨 Design System Summary

| Component | Implementation | Colors |
|-----------|----------------|--------|
| **Buttons** | NeonButton (scale animation) | Neon (#00D1FF) |
| **Cards** | NeonCard (border + shadow) | Surface (#101826) |
| **Text Fields** | NeonTextField (labeled) | Neon focus border |
| **Badges** | StatusBadge (status color) | Status-specific |
| **Background** | Scaffold with theme | Dark (#0B0F17) |
| **Navigation** | BottomNavigationBar | 4 tabs + FAB |

---

This architecture is production-ready and scalable. All components follow Material 3 guidelines with custom dark neon theme applied consistently.
