# Keep com.itgsa.opensdk classes to prevent R8 from removing them
-keep class com.itgsa.opensdk.mediaunit.** { *; }
-keep class com.itgsa.opensdk.media.** { *; }
-keep class com.itgsa.opensdk.** { *; }

# Keep ZEGO-related classes (optional, for safety)
-keep class im.zego.** { *; }
-dontwarn im.zego.**

# Suppress warnings for com.itgsa and ZEGO (optional, if warnings persist)
-dontwarn com.itgsa.**