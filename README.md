# Violet (قالب تطبيق بثيم بنفسجي)

## البناء بدون كمبيوتر (من الجوال)
1. أنشئ حساباً على github.com وأنشئ مستودعاً جديداً (Repository).
2. ارفع كل محتويات هذا المجلد (Add file > Upload files)، مع المجلد المخفي `.github`.
3. ادخل تبويب **Actions** > **Build APK** > **Run workflow**.
4. بعد انتهائه (5 إلى 10 دقائق) افتح التشغيل ونزّل `violet-apk` من قسم Artifacts. فيه ملف `app-release.apk`.

## تغيير الألوان والأسماء
- الألوان: `lib/theme.dart`
- النصوص واللغات: `lib/strings.dart`
- المحتوى: `lib/data.dart` (واجهة `ContentRepository`، اربطها بمصدر محتوى مرخّص)
