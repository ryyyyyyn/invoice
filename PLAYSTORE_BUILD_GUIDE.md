# Invoice Pro - Build & Play Store Release Guide

## 🔨 Local Build Instructions

### Prerequisites

Ensure you have installed:
- Flutter SDK (3.7.0+): `flutter --version`
- Android SDK tools: `flutter doctor`
- Java SDK 11+: `java -version`

### 1. Initial Setup

```bash
# Navigate to project
cd invoice

# Get all dependencies
flutter pub get

# Generate Isar database schema files
dart run build_runner build --delete-conflicting-outputs

# Verify build
flutter clean
```

### 2. Debug Build (Development)

```bash
# Run on connected device
flutter run

# Or build APK for testing
flutter build apk --debug
```

Output: `build/app/outputs/flutter-apk/app-debug.apk`

### 3. Release Build (Production)

#### Step 1: Create Signing Keystore (One-time setup)

```bash
# Generate keystore with 10-year validity
keytool -genkey -v -keystore app-release-keystore.jks ^
  -keyalg RSA -keysize 2048 -validity 10000 ^
  -alias key -storepass your_store_password ^
  -keypass your_key_password ^
  -dname "CN=Invoice Pro Developer,O=Your Company,C=ID"
```

**Parameters**:
- `your_store_password`: Password to access keystore (save securely)
- `your_key_password`: Password to access the key
- `CN`: Your name or business name
- `O`: Organization name
- `C`: Country code (ID for Indonesia)

**Output**: `app-release-keystore.jks` in project root

#### Step 2: Configure Gradle Signing

Create `android/key.properties`:

```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=key
storeFile=../app-release-keystore.jks
```

**Security Note**: Add `android/key.properties` to `.gitignore` to avoid committing passwords.

#### Step 3: Update Android Manifest

Edit `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application
        android:label="Invoice Pro"
        android:icon="@mipmap/ic_launcher"
        ...>
    </application>
</manifest>
```

Edit `android/app/src/main/res/values/strings.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">Invoice Pro</string>
</resources>
```

#### Step 4: Update Package ID (Optional)

Default: `com.example.invoice`

Edit `android/app/build.gradle`:

```gradle
android {
    namespace "com.yourcompany.invoicepro"
    
    defaultConfig {
        applicationId "com.yourcompany.invoicepro"
        minSdkVersion 21  // Flutter minimum
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }
}
```

Also update in `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest package="com.yourcompany.invoicepro">
```

#### Step 5: Build Release APK

```bash
flutter build apk --release
```

**Output**: `build/app/outputs/flutter-apk/app-release.apk`

Test APK on device:

```bash
flutter install build/app/outputs/flutter-apk/app-release.apk
```

#### Step 6: Build App Bundle (for Play Store)

```bash
flutter build appbundle --release
```

**Output**: `build/app/outputs/bundle/release/app-release.aab`

This is what you upload to Google Play Console.

## 📦 Google Play Store Preparation

### 1. App Icon

**Location**: `android/app/src/main/res/`

Required sizes:
- `mipmap-mdpi/ic_launcher.png` - 48×48 pixels
- `mipmap-hdpi/ic_launcher.png` - 72×72 pixels
- `mipmap-xhdpi/ic_launcher.png` - 96×96 pixels
- `mipmap-xxhdpi/ic_launcher.png` - 144×144 pixels
- `mipmap-xxxhdpi/ic_launcher.png` - 192×192 pixels

**Best practices**:
- Use a professional icon generator tool
- Ensure good contrast on both light and dark backgrounds
- Use PNG format with transparency
- Android Studio has built-in asset studio to generate all sizes

### 2. App Store Listing

#### App Name
- Max 50 characters
- Recommendation: "Invoice Pro" or "Invoice Pro - UMKM"

#### Short Description
- Max 80 characters
- Example: "Professional invoice management for small businesses"

#### Full Description
- Max 4000 characters
- Include features:
  * Custom invoice templates
  * Offline-first design
  * Professional PDF generation
  * Payment tracking (DP & Termin)
  * Dark modern UI
  * Local data security

#### Screenshots (minimum 2, max 8)
- Size: 1080×1920 pixels (9:16 aspect ratio)
- Show:
  1. Home dashboard
  2. Create invoice wizard
  3. Invoice list
  4. PDF preview
  5. Business profile setup

#### Content Rating
- Select "Apps - Business" category
- Questionnaire required by Google Play

### 3. Privacy Policy

**Create**: `lib/assets/privacy_policy.txt` or link to hosted policy

**Minimum content**:
```
PRIVACY POLICY FOR INVOICE PRO

Effective Date: [DATE]

1. DATA COLLECTION
- This app stores all data locally on your device
- No data is sent to external servers
- No personal data collection
- No analytics or tracking

2. OFFLINE-FIRST DESIGN
- All invoices, customers, and templates are stored locally
- Complete functionality without internet connection
- Data backup responsibility is user's

3. PERMISSIONS
- Camera: for logo upload (optional)
- Storage: for PDF saving and sharing

4. NO THIRD-PARTY SHARING
- We do not share your data with third parties
- We do not use cookies or tracking pixels

5. SECURITY
- Data encrypted locally via Isar database
- No user accounts required

6. CHANGES TO POLICY
This policy may be updated. Continued use constitutes acceptance.

[Your Company Name]
[Contact Email]
```

### 4. Testing Instructions for Reviewers

Create `TESTING_GUIDE.txt`:

```
TESTING GUIDE FOR INVOICE PRO

Quick Start:
1. Open app → Dashboard visible
2. Tap Settings icon → Business Profile setup
3. Enter business information → Save
4. Go to Customers tab → Add Customer (FAB)
5. Go to Invoices tab → Create Invoice (coming in next build)

Features to Test:
- Navigation via bottom tabs works
- Dark theme applies throughout
- All buttons are clickable
- Forms validate inputs (required fields)
- No crashes on basic navigation

Known Limitations (Beta):
- Invoice creation wizard in development
- PDF export coming in next update
- Template builder coming in next update

Device Requirements:
- Android 5.0 (API 21) or higher
- 20 MB free storage
- No internet required

Contact: [your.email@example.com]
```

### 5. Setup Google Play Developer Account

1. Go to [Google Play Console](https://play.google.com/console)
2. Create developer account ($25 one-time fee)
3. Fill in account information
4. Create new app → "Invoice Pro"
5. Complete store listing section
6. Add app bundle (AAB file)
7. Submit for review

### 6. Version Management

In `pubspec.yaml`:
```yaml
version: 1.0.0+1
```

Format: `major.minor.patch+buildNumber`

For Play Store:
- First release: `1.0.0+1`
- Bug fix update: `1.0.1+2`
- Feature update: `1.1.0+3`
- Major release: `2.0.0+4`

### 7. Proguard/R8 Configuration

Android automatically handles code obfuscation. For custom rules, create `android/app/proguard-rules.pro`:

```
# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Isar database
-keep class com.google.protobuf.** { *; }
-keep class io.objectbox.** { *; }
```

## 🚀 Deployment Checklist

- [ ] All dependencies updated and tested
- [ ] Debug banner removed (`debugShowCheckedModeBanner: false`)
- [ ] App icon added (all resolutions)
- [ ] App name updated
- [ ] Package ID customized
- [ ] Version number incremented
- [ ] Signing keystore created and secured
- [ ] key.properties configured
- [ ] Release APK tested on device
- [ ] App bundle generated
- [ ] Privacy policy created
- [ ] Store listing completed with screenshots
- [ ] Content rating questionnaire filled
- [ ] Testing guide prepared
- [ ] Release notes prepared

## 📋 Release Notes Template

```
VERSION 1.0.0 - Initial Release

New Features:
✓ Business profile management
✓ Customer directory with search
✓ Product/service catalog
✓ Dashboard with quick stats
✓ Professional dark theme with neon accent
✓ Offline-first design
✓ Local data storage

Coming Soon:
- Invoice creation wizard
- Custom invoice templates
- PDF generation and sharing
- Payment tracking (DP & Termin)
- Advanced reporting

Bug Fixes:
- Initial release

Known Issues:
- None at this time

Installation:
- Install from Google Play
- Grant storage permission for PDF saving
- Start with Business Profile setup

Feedback:
Please rate and review! Contact us at feedback@yourcompany.com
```

## 🔐 Security Best Practices

1. **Protect Keystore**
   - Store `app-release-keystore.jks` in secure location
   - Never commit to version control
   - Backup in secure cloud storage
   - Document password in secure password manager

2. **Protect key.properties**
   - Add to `.gitignore`
   - Store separately from repository
   - Share only with authorized team members

3. **Version Control**
   ```bash
   # .gitignore
   android/key.properties
   *.jks
   *.keystore
   ```

4. **Update Regularly**
   - Monitor Flutter security updates
   - Update dependencies monthly
   - Test thoroughly before release

## 📞 Support Resources

- [Google Play Console Help](https://support.google.com/googleplay/android-developer)
- [Flutter Build Documentation](https://flutter.dev/docs/deployment/android)
- [Android App Signing](https://developer.android.com/studio/publish/app-signing)

---

**Last Updated**: December 2025
**Maintained By**: Invoice Pro Team
