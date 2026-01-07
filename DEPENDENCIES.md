# Invoice Pro - Dependencies Reference

## All Dependencies Used

### Production Dependencies

#### UI & Material Design
```yaml
cupertino_icons: ^1.0.8           # iOS-style icons
flutter_animate: ^4.2.0+1         # Micro-interactions & animations
```

#### State Management
```yaml
flutter_riverpod: ^2.4.11         # State management library
riverpod_annotation: ^2.3.3       # Code generation for Riverpod
```

#### Navigation
```yaml
go_router: ^14.0.1                # Type-safe routing with nested navigation
```

#### Local Database
```yaml
isar: ^3.1.0+1                    # Lightweight local database
isar_flutter_libs: ^3.1.0+1       # Flutter-specific Isar bindings
```

#### PDF & Printing
```yaml
pdf: ^3.10.5                      # PDF generation
printing: ^5.11.0                 # Print and share PDFs
```

#### File & Media
```yaml
image_picker: ^1.1.1              # Pick images from device
path_provider: ^2.1.2             # Device paths (documents, cache, etc)
share_plus: ^7.2.2                # Share files and text
```

#### Utilities
```yaml
intl: ^0.19.0                     # Internationalization & formatting
uuid: ^4.0.0                      # UUID generation
freezed_annotation: ^2.4.1        # Immutable class generation (optional)
```

### Development Dependencies

```yaml
flutter_test:                      # Flutter testing framework
flutter_lints: ^5.0.0             # Lint rules
build_runner: ^2.4.6              # Code generation runner
isar_generator: ^3.1.0+1          # Generate Isar database code
riverpod_generator: ^2.3.9        # Generate Riverpod providers
freezed: ^2.4.1                   # Immutable class code gen (optional)
```

## Version Selection Rationale

| Package | Version | Why |
|---------|---------|-----|
| **flutter_riverpod** | 2.4.11 | Latest stable, great docs, widely used |
| **go_router** | 14.0.1 | Latest stable, type-safe, nested routing |
| **isar** | 3.1.0+1 | Latest stable, excellent performance |
| **pdf** | 3.10.5 | Latest stable, comprehensive PDF support |
| **image_picker** | 1.1.1 | Latest stable, good platform support |
| **share_plus** | 7.2.2 | Latest stable, cross-platform sharing |

## How to Update Dependencies

### Check for Updates
```bash
flutter pub upgrade --dry-run
```

### Update Specific Package
```bash
flutter pub upgrade package_name
```

### Update All Packages
```bash
flutter pub upgrade
```

### Fix Dependency Issues
```bash
flutter pub get
flutter pub upgrade --major-versions
```

## Code Generation

### Generate Isar Database Code
Required after modifying entity files (`domain/entities/`):

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Watch Mode (Auto-generate on changes)
```bash
dart run build_runner watch
```

### Clear Generated Files
```bash
dart run build_runner clean
```

## Minimum Requirements

- **Flutter**: 3.7.0 or higher
- **Dart**: 3.7.0 or higher
- **Android SDK**: API 21 (Android 5.0) or higher
- **Java**: JDK 11 or higher

## Optional Enhancements

Not included but could be added:

```yaml
# For better UI animations
simple_animations: ^5.0.0

# For local notifications
flutter_local_notifications: ^14.0.0

# For QR code generation
qr: ^3.0.0

# For Excel export
excel: ^2.0.0

# For Firebase (future cloud feature)
firebase_core: ^2.0.0
firebase_database: ^10.0.0

# For charts/reports
fl_chart: ^0.60.0
charts_flutter: ^0.12.0
```

## Troubleshooting Dependencies

### Issue: Build fails after adding package
**Solution**:
```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### Issue: Isar compilation error
**Solution**:
```bash
# Delete Isar generated files
rm -rf .dart_tool
flutter pub get
dart run build_runner build
```

### Issue: Version conflict
**Solution**:
```bash
flutter pub upgrade --major-versions
# Review changes in pubspec.lock
```

## Security Updates

Keep packages updated for security:

```bash
# Check for security vulnerabilities
dart pub outdated --mode=null-safety

# Update vulnerable packages only
flutter pub upgrade vuln_package
```

## Bundle Size Impact

Estimated apk size impact:

| Package | Size Impact |
|---------|------------|
| Riverpod | ~500KB |
| GoRouter | ~300KB |
| Isar | ~1.5MB (with SQLite) |
| PDF library | ~800KB |
| Image Picker | ~200KB |
| Share Plus | ~100KB |
| Others | ~500KB |
| **Total** | **~3.8MB** |

(Actual size varies by build configuration and optimization)

## Production Optimization

For release builds:

```bash
# Enable R8/ProGuard
flutter build apk --release --obfuscate

# Build split APKs by architecture
flutter build apk --release --split-per-abi

# Build app bundle (recommended for Play Store)
flutter build appbundle --release
```

## Notes

1. **Isar**: Chosen over Drift for better query performance
2. **Riverpod**: Modern state management, very scalable
3. **GoRouter**: Type-safe, supports nested navigation
4. **PDF Package**: Pure Dart, doesn't require native dependencies
5. **Share Plus**: Cross-platform, well-maintained

---

**Last Updated**: December 22, 2025
**Tested With**: Flutter 3.13.0, Dart 3.1.0
