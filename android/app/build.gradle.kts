import java.util.Properties
import java.io.FileInputStream

// Load keystore properties if present (keeps release build safe when absent)
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
var keystoreStoreFile: File? = null
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
    val storePath = keystoreProperties["storeFile"] as? String
    if (storePath != null) {
        // resolve relative or absolute path
        val candidate = rootProject.file(storePath)
        if (candidate.exists()) {
            keystoreStoreFile = candidate
        } else {
            println("[warning] keystore file specified in key.properties not found: $storePath")
        }
    } else {
        println("[warning] key.properties present but 'storeFile' not set")
    }
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.yourcompany.invoicepro"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.yourcompany.invoicepro"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
    signingConfigs {
        create("release") {
            if (keystoreStoreFile != null && keystoreStoreFile!!.exists()) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = keystoreStoreFile
                storePassword = keystoreProperties["storePassword"] as String
            } else {
                // leave signing config empty to avoid failing the build when keystore is missing
                println("[info] release signing config not applied because keystore is missing")
            }
        }
    }

    buildTypes {
        release {
            if (keystoreStoreFile != null && keystoreStoreFile!!.exists()) {
                signingConfig = signingConfigs.getByName("release")
            } else {
                println("[info] skipping release signing since keystore not found; build will be unsigned")
            }
            // Enable code shrinking and obfuscation
            isMinifyEnabled = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
