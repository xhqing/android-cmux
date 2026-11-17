# 协议模型用 kotlinx.serialization，字段名不能混淆
-keepattributes *Annotation*, InnerClasses
-keepclassmembers class dev.xhqing.androidcmux.** {
    *** Companion;
}
-keepclasseswithmembers class dev.xhqing.androidcmux.** {
    kotlinx.serialization.KSerializer serializer(...);
}
