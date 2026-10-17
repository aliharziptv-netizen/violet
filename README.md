# Violet

## مصدر المحتوى (اختر واحداً)
**أ) TMDB (مجاني، أفلام ومسلسلات وصور وتقييمات فقط)**
1. أنشئ حساباً في themoviedb.org ثم Settings > API واطلب مفتاح API (v3).
2. في مستودع GitHub: Settings > Secrets and variables > Actions > New repository secret
   الاسم `TMDB_KEY` والقيمة مفتاحك.

**ب) خادمك الخاص (JSON)**
1. Settings > Secrets and variables > Actions > تبويب Variables > New repository variable
   الاسم `API_BASE` والقيمة رابط خادمك (مثل https://example.com/api).
2. الخادم يرجع `/featured` و`/trending` كمصفوفة:
   `[{"name":"..","type":"movie|series","year":2026,"rating":7.5,"image":"https://.."}]`

إن لم تضبط شيئاً، يعرض التطبيق بيانات تجريبية.
بعد ضبط الأسرار أعد تشغيل Build APK من تبويب Actions.

## الصفحات
- الرئيسية، عرض الكل (شبكة + بحث)، تفاصيل العمل (بنفسجية)، ومشغل فيديو (mp4 / m3u8 / mpd ...).
- لا يعمل زر "تشغيل الآن" إلا إذا رجع مصدرك رابط تشغيل في الحقل `stream`.
- الفيديو التجريبي في وضع البيانات التجريبية هو Big Buck Bunny (رخصة CC-BY).
