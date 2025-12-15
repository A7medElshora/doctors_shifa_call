# ──────────────────────────────────────────────────────────────
# Flutter Core
# ──────────────────────────────────────────────────────────────
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# ──────────────────────────────────────────────────────────────
# Agora RTC Engine (مهم جداً للـ Video Call)
# ──────────────────────────────────────────────────────────────
-keep class io.agora.** { *; }
-dontwarn io.agora.**

# ──────────────────────────────────────────────────────────────
# Firebase & Google Play Services
# ──────────────────────────────────────────────────────────────
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# ──────────────────────────────────────────────────────────────
# Google Play Core - حل نهائي لخطأ "Missing class com.google.android.play.core"
# (Flutter بيستخدمها داخليًا حتى لو ما استخدمتهاش)
# ──────────────────────────────────────────────────────────────
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }

# ──────────────────────────────────────────────────────────────
# Kotlin Standard Library
# ──────────────────────────────────────────────────────────────
-keep class kotlin.** { *; }
-keepclassmembers class kotlin.Metadata { *; }
-dontwarn kotlin.**

# ──────────────────────────────────────────────────────────────
# Gson & OkHttp (يستخدمهم Firebase و Retrofit)
# ──────────────────────────────────────────────────────────────
-keep class com.google.gson.** { *; }
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-dontwarn okhttp3.**

# ──────────────────────────────────────────────────────────────
# Retrofit (لو بتستخدمه)
# ──────────────────────────────────────────────────────────────
-keep class retrofit2.** { *; }
-dontwarn retrofit2.**
-keepattributes Signature
-keepattributes Exceptions

# ──────────────────────────────────────────────────────────────
# Keep Annotated Classes (مهم لـ Firebase & Annotations)
# ──────────────────────────────────────────────────────────────
-keepattributes *Annotation*
-keepattributes Signature
-keepclassmembers class * {
    @androidx.annotation.Keep *;
    @com.google.firebase.annotations.Keep *;
}

# ──────────────────────────────────────────────────────────────
# Remove Debug Logs in Release (يقلل الحجم أكتر)
# ──────────────────────────────────────────────────────────────
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
    public static *** w(...);
}
-assumenosideeffects class timber.log.Timber* {
    *;
}

# ──────────────────────────────────────────────────────────────
# Keep App Classes (حماية إضافية لكلاسات التطبيق الرئيسية)
# ──────────────────────────────────────────────────────────────
-keep class com.tabibsoft.shifa_doctors.** { *; }