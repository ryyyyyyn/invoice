# Invoice Pro - Professional Invoice Management for UMKM

A modern Flutter application for managing invoices, customers, products, and payment tracking with custom template builder. Built for Android with Material 3 dark neon UI theme and offline-first local storage.

## ✅ Current Status (MVP Complete)

**Release**: v1.0.0  
**Static Analysis**: 0 errors, 0 warnings  
**Data Storage**: LocalStorage (in-memory, ready for Drift migration)  
**State Management**: Riverpod  
**UI Framework**: Flutter + Material 3  

## 🎯 Completed Features

### ✅ Core Modules

#### 1. **Business Profile** (BusinessProfileScreen)
- Manage business name, address, phone, email
- Invoice prefix customization (default: INV)
- Auto-increment counter with year tracking
- Logo upload via image_picker (display as preview)
- Test invoice number generation (shows sample: INV-2025-0001)
- Auto-create default business on first launch (onboarding)

#### 2. **Customer Management** (CustomerListScreen)
- ✅ List all customers with search
- ✅ Add/edit customer (name, address, phone, email, WhatsApp, notes)
- ✅ Delete with confirmation
- ✅ Empty state with quick add button
- ✅ Full CRUD via CustomerRepository

#### 3. **Catalog Management** (CatalogListScreen)
- ✅ List catalog items with search
- ✅ Add/edit item (name, price, unit dropdown, category, description)
- ✅ Delete with confirmation
- ✅ Bottom sheet form for inline editing
- ✅ Validation (name required, valid price)
- ✅ Full CRUD via CatalogRepository

#### 4. **Invoice Management**
- **InvoiceListScreen**: 
  - ✅ List all invoices
  - ✅ Search by invoice number
  - ✅ Filter by status (draft, sent, paid, partial_paid, overdue, cancelled)
  - ✅ Delete with confirmation
  - ✅ Status-based color coding
  
- **InvoiceCreateScreen**:
  - ✅ Select customer from dropdown
  - ✅ Add line items from catalog
  - ✅ Auto-generate invoice number via InvoiceNumberGenerator
  - ✅ Set invoice & due dates
  - ✅ Calculate subtotal, apply discount, tax, shipping
  - ✅ View grand total in real-time
  - ✅ Add notes & terms
  - ✅ Save to repository with line items

#### 5. **Template Builder v1** (TemplateListScreen + TemplateEditorScreen)
- ✅ Create, edit, duplicate, delete templates
- ✅ **Template Editor**:
  - Add/rename/delete sections
  - Reorder sections (up/down buttons)
  - Full field CRUD within sections
  - Reorder fields within sections
- ✅ **Field Types Support**:
  - text, multiline, number, currency, date, dateRange, dropdown, checkbox
- ✅ **Field Properties**:
  - key (auto-generated snake_case)
  - label, type, required, showOnPdf, options (for dropdown)
- ✅ **JSON Schema Storage**:
  - `Template.schemaJson` stores full structure as JSON
  - Round-trip serialization (load/save)
  - TemplateRepository methods: loadSchema(), saveSchema()

#### 6. **Payment Tracking** (PaymentTrackingScreen)
- ✅ Select invoice to track
- ✅ Log payments with:
  - Amount, payment type (lunas/dp/termin)
  - Payment method (cash/transfer/check/other)
  - Payment date
  - Notes
- ✅ Auto-update invoice status:
  - draft → partial_paid → paid based on total amount

#### 7. **Dashboard/Home** (HomeScreen)
- ✅ Live statistics from repositories:
  - Total revenue (paid invoices)
  - Unpaid invoice count
  - Overdue invoice count
  - Total invoice count
- ✅ Quick action buttons (navigate to Customers, Invoices, etc.)
- ✅ Settings button (→ Business Profile)

### ✅ UI Components & Widgets

#### Custom Components (lib/core/widgets/)
- ✅ **NeonCard**: Glowing card with optional tap handler
- ✅ **NeonTextField**: Text input with label, hint, validation support
- ✅ **NeonButton**: Material button with neon styling
- ✅ **NeonStatusBadge**: Status chip with type-based colors
- ✅ **EmptyState**: Reusable empty list state with icon, title, CTA button

All widgets use **super.key** (super parameters applied).

### ✅ Navigation & Routing (GoRouter)

**Bottom Navigation** (6 tabs):
1. Home → HomeScreen (Dashboard with stats)
2. Invoices → InvoiceListScreen
3. Customers → CustomerListScreen
4. Catalog → CatalogListScreen
5. Templates → TemplateListScreen
6. Payments → PaymentTrackingScreen

**Additional Routes**:
- `/invoice/create` → InvoiceCreateScreen (FAB from InvoiceListScreen)
- `/template/:id/edit` → TemplateEditorScreen (Edit button from TemplateListScreen)
- `/business-profile` → BusinessProfileScreen (Settings icon in AppBar)

### ✅ Data Layer

#### Repositories
- ✅ **BusinessRepository**: getOrCreateBusiness(), updateBusiness()
- ✅ **CustomerRepository**: getAllCustomers(), add/update/delete
- ✅ **CatalogRepository**: getAllItems(), add/update/delete
- ✅ **InvoiceRepository**: 
  - getAllInvoices(), getInvoicesByStatus(), getInvoicesByCustomer()
  - CRUD for invoices, line items, payments, payment schedules
  - Stats: getTotalRevenue(), getUnpaidInvoicesCount(), getOverdueInvoicesCount()
- ✅ **TemplateRepository**:
  - CRUD for templates
  - loadSchema(), saveSchema() for JSON schema management

#### Storage
- ✅ **LocalStorage** singleton (in-memory, ready for database migration)
  - Stores: businesses, customers, catalogItems, templates, invoices, invoiceItems, payments, paymentSchedules
  - Auto-increment ID assignment per collection

#### Entities
- ✅ **Business**: name, address, phone, email, logoPath, invoicePrefix, counter, counterYear
- ✅ **Customer**: name, address, phone, email, WhatsApp, notes
- ✅ **CatalogItem**: name, price, unit, category, description
- ✅ **Template**: name, description, schemaJson (stores full template structure)
- ✅ **Invoice**: number, customer, business, date, dueDate, status, items, totals, notes
- ✅ **InvoiceItem**: name, quantity, unit, price, discount, note
- ✅ **Payment**: invoiceId, type, method, amount, paidAt, note
- ✅ **PaymentSchedule**: title, dueDate, amount, isPaid

### ✅ Utilities

- ✅ **InvoiceNumberGenerator**: Generates unique invoice numbers with year/counter tracking
- ✅ **TemplateSchema**: JSON schema classes (TemplateSchema, SchemaSection, SchemaField) with serialization
- ✅ **FieldEditorSheet**: Bottom sheet widget for field CRUD in template builder

## 📦 Technology Stack

| Technology | Purpose |
|-----------|---------|
| **Flutter 3.7.0** | Cross-platform UI framework |
| **Riverpod 2.4.11** | State management |
| **GoRouter 14.0.1** | Type-safe navigation |
| **Material 3** | Modern UI design system |
| **image_picker 1.1.1** | Image/logo upload |
| **intl 0.19.0** | Date formatting |
| **uuid 4.0.0** | ID generation |
| **Drift 2.14.0** | Database (schema defined, ready for migration) |
| **pdf 3.10.5** | PDF generation (ready for integration) |

**Note**: Project currently uses **LocalStorage** (in-memory) for data persistence. Isar has been removed. Drift schema is prepared and ready for database migration in Phase 2.

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.7.0+
- Android SDK for Android development

### Installation

```bash
# 1. Clone repository
git clone <repo-url>
cd invoice

# 2. Get dependencies
flutter pub get

# 3. Run app
flutter run

# 4. (Optional) Generate code for Drift migrations when implemented
dart run build_runner build
```

## 🎨 Design System

### Colors
- **Primary BG**: `#0B0F17` (Deep blue)
- **Surface**: `#101826` (Light blue)
- **Accent**: `#00D1FF` (Neon cyan)
- **Text Primary**: `#E6F1FF` (Light blue)
- **Text Secondary**: `#8AA4C8` (Muted)

### Status Colors
- **Success/Paid**: `#00D978` (Green)
- **Warning/Partial**: `#FFB700` (Amber)
- **Error/Overdue**: `#FF4444` (Red)
- **Draft**: `#8AA4C8` (Gray)

## 📁 Project Structure

```
lib/
├── main.dart                           # App entry, theme, router
├── core/
│   ├── constants/
│   │   ├── app_colors.dart             # Color palette
│   │   └── app_constants.dart          # Global constants
│   └── widgets/
│       ├── neon_card.dart              # Reusable card widget
│       ├── neon_button.dart            # Button component
│       ├── neon_text_field.dart        # Text input component
│       ├── empty_state.dart            # Empty list state
│       └── status_badge.dart           # Status chip
├── domain/
│   └── entities/
│       ├── business.dart
│       ├── customer.dart
│       ├── catalog_item.dart
│       ├── invoice.dart
│       ├── template.dart
│       └── ...
├── data/
│   ├── datasources/
│   │   └── local_storage.dart          # In-memory storage
│   └── repositories/
│       ├── business_repository.dart
│       ├── customer_repository.dart
│       ├── catalog_repository.dart
│       ├── invoice_repository.dart
│       ├── template_repository.dart
│       └── ...
├── application/
│   └── providers/
│       └── providers.dart              # Riverpod provider definitions
├── presentation/
│   ├── routes/
│   │   └── app_router.dart             # GoRouter configuration
│   ├── screens/
│   │   ├── home/
│   │   │   └── home_screen.dart        # Dashboard
│   │   ├── business/
│   │   │   └── business_profile_screen.dart
│   │   ├── customers/
│   │   │   └── customer_list_screen.dart
│   │   ├── catalog/
│   │   │   └── catalog_list_screen.dart
│   │   ├── invoices/
│   │   │   ├── invoice_list_screen.dart
│   │   │   └── invoice_create_screen.dart
│   │   ├── templates/
│   │   │   ├── template_list_screen.dart
│   │   │   └── template_editor_screen.dart
│   │   ├── payments/
│   │   │   └── payment_tracking_screen.dart
│   │   └── settings/
│   │       └── settings_screen.dart
│   └── widgets/
│       └── field_editor_sheet.dart     # Template field editor
└── utils/
    ├── invoice_number_generator.dart   # Invoice number logic
    └── template_schema.dart            # Template JSON schema classes
```

## 🔄 Data Flow Example: Create Invoice

```
InvoiceCreateScreen
  ├─ Load customers (FutureProvider)
  ├─ Load catalog items (FutureProvider)
  ├─ Select customer + add line items from catalog
  ├─ Auto-generate number via InvoiceNumberGenerator
  ├─ Calculate totals (subtotal, discount, tax, shipping)
  └─ Save via InvoiceRepository.createInvoice()
      └─ Refresh invoiceListProvider
          └─ InvoiceListScreen rebuilds with new invoice
```

## 📊 Invoice Status Flow

```
draft ──[Send]──> sent ──[Payment]──> partial_paid ──[Final Payment]──> paid
  │                                        │
  └─────────────[Check Due Date]─────────────> overdue
  
Any status ──[Cancel]──> cancelled
```

## 🎯 Next Steps / Roadmap

### Phase 2 (Planned)
- [ ] PDF generation from templates
- [ ] Invoice preview/PDF export
- [ ] WhatsApp integration (send via API)
- [ ] Email invoice sending
- [ ] Database migration (Drift/SQLite)
- [ ] Cloud backup/sync
- [ ] Dark mode settings toggle
- [ ] Offline receipt printing
- [ ] Advanced reporting (revenue by period, customer analytics)

### Phase 3 (Future)
- [ ] Multi-language support
- [ ] Tax/VAT calculations
- [ ] Inventory management
- [ ] Recurring invoices
- [ ] Client portal
- [ ] Mobile app optimization

## 📝 License

Proprietary - Built for UMKM Invoice Management

## 👨‍💻 Development

### Code Quality
- ✅ Static analysis: 0 errors, 0 warnings
- ✅ All widgets use `super.key`
- ✅ Consistent naming (snake_case for files, camelCase for code)
- ✅ Repository pattern for data access
- ✅ Riverpod providers for state management

### Run Tests
```bash
flutter test
```

### Build & Deploy
See [PLAYSTORE_BUILD_GUIDE.md](PLAYSTORE_BUILD_GUIDE.md) for release instructions.

## Google Play Release (AAB)

### 1) Create keystore
```bash
keytool -genkey -v -keystore ~/invoicepro-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias invoicepro
```

### 2) Add `android/key.properties`
```properties
storeFile=/path/to/invoicepro-release.jks
storePassword=YOUR_STORE_PASSWORD
keyAlias=invoicepro
keyPassword=YOUR_KEY_PASSWORD
```

### 3) Configure signing in `android/app/build.gradle.kts`
```kotlin
// Example signing config snippet (adjust as needed)
val keystoreProperties = java.util.Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(keystorePropertiesFile.inputStream())
}

android {
    signingConfigs {
        create("release") {
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
        }
    }
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}
```

### 4) Build release AAB
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter build appbundle --release
```

The AAB output is at:
```
build/app/outputs/bundle/release/app-release.aab
```

---

**Last Updated**: December 23, 2025  
**Status**: MVP Complete - Ready for Beta Testing
