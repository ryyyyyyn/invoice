# Minimal ProGuard rules for Flutter
# Keep Flutter embedding and plugins
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.view.** { *; }
-dontwarn io.flutter.embedding.**
-dontwarn io.flutter.plugin.**

# Keep OkHttp/HTTP client models if used
-dontwarn okhttp3.**
-dontwarn okio.**

# Keep model classes for reflection (add your own as needed)
#-keepclassmembers class com.example.** { *; }
