# Invoice Pro - Flutter Invoice Management App

A modern, professional invoice management application built with Flutter for Android, targeting offline-first architecture with dark neon UI theme.

## 🎯 Features

- **Business Profile Management**: Setup and customize your business information
- **Customer Management**: CRUD operations for customers with search functionality
- **Catalog Management**: Manage products/services with pricing
- **Template Builder**: Create custom invoice templates with dynamic fields
- **Invoice Creation Wizard**: 3-step wizard for creating professional invoices
- **Payment Tracking**: Support for full payment (Lunas), down payment (DP), and installments (Termin)
- **PDF Generation & Sharing**: Generate PDF invoices and share via WhatsApp
- **Dashboard**: Quick stats and recent activity overview
- **Offline-First**: All data stored locally with Isar database
- **Dark Neon UI**: Modern Material 3 design with neon blue accent

## 🛠️ Tech Stack

- **State Management**: Riverpod
- **Routing**: GoRouter
- **Local Database**: Isar (SQLite)
- **PDF Generation**: pdf + printing packages
- **UI Framework**: Flutter Material 3
- **Image Handling**: image_picker
- **File Operations**: path_provider
- **Social Sharing**: share_plus

## 📦 Project Structure

```
lib/
├── main.dart                          # App entry point
├── config/
│   ├── app_theme.dart                 # Theme configuration (dark neon blue)
│   └── router.dart                    # GoRouter configuration
├── constants/
│   ├── app_colors.dart                # Color constants
│   └── app_constants.dart             # Application constants
├── utils/
│   └── invoice_number_generator.dart  # Invoice numbering logic
├── presentation/
│   ├── widgets/                       # Reusable UI components
│   │   ├── neon_button.dart
│   │   ├── neon_card.dart
│   │   ├── neon_text_field.dart
│   │   ├── status_badge.dart
│   │   └── empty_state.dart
│   └── screens/
│       ├── home/
│       ├── invoices/
│       ├── customers/
│       ├── catalog/
│       ├── templates/
│       ├── business/
│       └── settings/
├── application/
│   └── providers/
│       └── providers.dart             # Riverpod providers
├── domain/
│   ├── entities/                      # Data models
│   │   ├── business.dart
│   │   ├── customer.dart
│   │   ├── catalog_item.dart
│   │   ├── template.dart
│   │   └── invoice.dart
│   └── repositories/
└── data/
    ├── datasources/
    │   └── isar_service.dart          # Isar database initialization
    ├── models/
    └── repositories/                  # Repository implementations
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK: 3.7.0 or higher
- Dart SDK: 3.7.0 or higher
- Android SDK (for Android development)

### Installation

1. **Clone or setup the project**
   ```bash
   cd invoice
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code (Isar schemas)**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
   
   Or for watch mode during development:
   ```bash
   dart run build_runner watch
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 🎨 UI Theme

The app uses a custom dark neon blue theme with Material 3:

- **Primary Background**: `#0B0F17` (deep dark blue)
- **Surface Cards**: `#101826` (slightly lighter blue)
- **Accent Color**: `#00D1FF` (bright neon cyan)
- **Primary Text**: `#E6F1FF` (light blue white)
- **Secondary Text**: `#8AA4C8` (muted blue gray)

### Color Usage

- **Status Success**: `#00D978` (green) - Paid invoices
- **Status Warning**: `#FFB700` (amber) - Partial payments
- **Status Error**: `#FF4444` (red) - Overdue invoices
- **Status Info**: `#00A8E8` (cyan) - Info states

## 📱 Features Detail

### 1. Business Profile
- Store business name, address, phone, email
- Upload logo image
- Customize invoice number prefix (default: INV)
- Auto-increment invoice counter per year

### 2. Customers
- Add, edit, delete customer records
- Search customers by name
- Store address, WhatsApp, email, notes
- Quick customer selection in invoice creation

### 3. Catalog
- Manage products/services library
- Store name, price, unit type, category
- Quick selection during invoice item creation

### 4. Template Builder (Custom Fields)
- Create unlimited invoice templates
- Add custom sections within templates
- Flexible field types: text, multiline, number, currency, date, dateRange, dropdown, checkbox
- Configure field visibility in PDF export
- Template duplication for quick setup
- Template-independent data storage (safe when templates change)

### 5. Invoice Creation Wizard

**Step 1: Basic Info**
- Select template
- Select customer
- Set invoice date and due date (optional)

**Step 2: Items & Details**
- Add items from catalog or create new
- Quantity, unit, price per item
- Item-level discounts
- Add notes per item
- Custom template fields

**Step 3: Payment & Preview**
- Choose payment type: Lunas (full), DP (down payment), Termin (installments)
- If DP: specify amount/percentage and due dates
- If Termin: create payment schedule with multiple due dates
- Preview PDF before saving
- Save and share options

**Invoice Status Flow**
- Draft → Sent → Partial Paid → Paid
- Automatic overdue detection (when dueDate passed and not paid)
- Support for cancellation

### 6. PDF Generation

**Professional Layout**
- White background for printing
- Business logo and header
- Customer details
- Invoice number and dates
- Itemized table with quantities and prices
- Summary with subtotal, discounts, tax, shipping
- Payment terms and notes
- Responsive design for different paper sizes

**Export Options**
- Save to device (Documents folder)
- Share via WhatsApp
- Print directly from app
- Email support (via share_plus)

### 7. Dashboard

**Quick Stats**
- Revenue this month
- Unpaid invoices count
- Overdue invoices count
- DP payments received this month

**Recent Activity**
- Latest invoices with status
- Quick action buttons
- Monthly revenue summary

## 🔧 Build & Release

### Debug Build
```bash
flutter run
```

### Release Build (Android)

1. **Configure app signing**
   
   Create `android/key.properties`:
   ```properties
   storePassword=your_store_password
   keyPassword=your_key_password
   keyAlias=key
   storeFile=../app-release-keystore.jks
   ```

2. **Generate keystore** (if needed)
   ```bash
   keytool -genkey -v -keystore app-release-keystore.jks \
     -keyalg RSA -keysize 2048 -validity 10000 \
     -alias key -storepass your_store_password \
     -keypass your_key_password \
     -dname "CN=Your Name,O=Your Company,C=ID"
   ```

3. **Build release APK**
   ```bash
   flutter build apk --release
   ```
   
   Output: `build/app/outputs/flutter-apk/app-release.apk`

4. **Build release AppBundle** (for Play Store)
   ```bash
   flutter build appbundle --release
   ```
   
   Output: `build/app/outputs/bundle/release/app-release.aab`

### Google Play Store Preparation

1. **App Icon**
   - Place icon at: `android/app/src/main/res/mipmap-*/ic_launcher.png`
   - Recommended: 192x192 pixels for mdpi
   - Use asset to image converter or Android Studio

2. **App Name**
   - Edit: `android/app/src/main/AndroidManifest.xml`
   - Change `android:label="@string/app_name"`
   - Edit: `android/app/src/main/res/values/strings.xml`

3. **Package ID**
   - Default: `com.example.invoice`
   - Change in: `android/app/build.gradle` (applicationId)
   - Recommended: `com.yourcompany.invoicepro`

4. **Privacy Policy**
   - Create placeholder or actual policy
   - Add text file to: `assets/privacy_policy.txt`
   - Reference in app Settings screen

5. **Remove Debug Banner**
   - Already done in `main.dart` with `debugShowCheckedModeBanner: false`

6. **Version Configuration**
   - Update in `pubspec.yaml`: `version: 1.0.0+1`
   - First number: version name (user-facing)
   - Number after `+`: version code (incremented for each build)

## 📝 Database Schema

### Collections

**Business** (single record)
- id, name, address, phone, email, logoPath
- invoicePrefix, invoiceCounter, counterYear

**Customer**
- id, name, address, whatsapp, email, notes
- createdAt, updatedAt

**CatalogItem**
- id, name, price, unit, category, description
- createdAt, updatedAt

**Template** (invoice templates)
- id, name, description, createdAt, updatedAt

**TemplateSection** (parts of template)
- id, templateId, title, order, description

**TemplateField** (custom fields)
- id, sectionId, key, label, type, required, showOnPdf, order, optionsJson

**Invoice**
- id, businessId, customerId, templateId, number, date, dueDate
- status (draft/sent/partial_paid/paid/overdue/cancelled)
- subtotal, discount, tax, shipping, grandTotal
- notes, terms, customDataJson

**InvoiceItem**
- id, invoiceId, name, qty, unit, price, discount, note, metadataJson

**Payment**
- id, invoiceId, type (lunas/dp/termin), method (cash/transfer/other)
- amount, paidAt, note

**PaymentSchedule** (for termin payments)
- id, invoiceId, title, dueDate, amount, isPaid, paidAt, note

## 🎓 Development Notes

### Custom Field Storage

Custom invoice fields are stored as JSON in `customDataJson` field:
```json
{
  "custom_field_key_1": "value1",
  "custom_field_key_2": 12345,
  "custom_field_key_3": "2025-12-22"
}
```

This allows templates to be modified without breaking existing invoice data.

### Invoice Numbering

Automatic numbering: `PREFIX-YEAR-COUNTER`
Example: `INV-2025-0001`

- Counter resets each year
- Stored in Business entity
- Generated via InvoiceNumberGenerator utility

### Payment Status Logic

Status automatically updates based on payments:
- All items paid → `paid`
- Some items paid → `partial_paid`
- No payment + dueDate < now → `overdue`
- Draft state created but not yet sent

## 📞 Support

For issues or questions during development, refer to:
- Flutter docs: https://flutter.dev/docs
- Riverpod docs: https://riverpod.dev
- GoRouter docs: https://pub.dev/packages/go_router
- Isar docs: https://isar.dev

## 📄 License

This project is private and intended for internal use.

---

**Version**: 1.0.0  
**Last Updated**: December 2025
