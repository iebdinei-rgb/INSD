# AR Vision Explorer

تطبيق واقع معزز متقدم يجمع بين **الذكاء الاصطناعي البصري (Vision AI)** و**التفكيك ثلاثي الأبعاد (Exploded AR View)** مع **شخصية رقمية تفاعلية (AI Avatar)**.

## المميزات الرئيسية

### المسح الذكي (AI Scanning)
- تحليل البيئة المحيطة في الوقت الفعلي باستخدام Apple Vision Framework
- نقاط تتبع ذكية متحركة تظهر أثناء المسح
- التعرف على الأجسام الإلكترونية (هواتف، ساعات، حواسيب، كاميرات)

### التفكيك بالواقع المعزز (Exploded AR View)
- **الضغط المطول** على أي جسم معروف لتفكيكه إلى مكوناته الداخلية
- تأثيرات اهتزاز تفاعلي (Haptic Feedback) مخصصة
- انيميشن تفكيك فيزيائي سلس مع تأخير متسلسل
- بطاقات معلومات زجاجية لكل قطعة مع الخامة والوظيفة

### الشخصية الرقمية (AI Avatar)
- كرة ضوئية تفاعلية مع حلقات مدارية
- فقاعة حوار زجاجية مع رسائل ذكية
- تأثيرات تنفس وتوهج ديناميكية
- نطق صوتي عربي باستخدام AVSpeechSynthesizer

### تصميم Glassmorphic True Black
- خلفيات زجاجية شبه شفافة مع ضبابية
- ألوان متوهجة (Cyan, Violet, Amber)
- حدود مضيئة نابضة
- انيميشن فيزيائي سلس بمعدل إطارات مرتفع

## المتطلبات

- **iOS 17.0+**
- **Xcode 15.0+**
- **Swift 5.9+**
- جهاز iPhone أو iPad يدعم ARKit (يتطلب معالج A12 أو أحدث)
- اختياري: جهاز يدعم LiDAR لدقة أعلى

## الإعداد والتشغيل

### الطريقة 1: باستخدام XcodeGen (موصى بها)

```bash
# تثبيت XcodeGen
brew install xcodegen

# توليد مشروع Xcode
cd ARVisionExplorer
xcodegen generate

# فتح المشروع
open ARVisionExplorer.xcodeproj
```

### الطريقة 2: إنشاء مشروع يدوي

1. افتح Xcode واختر **File → New → Project**
2. اختر **iOS → App**
3. اختر **SwiftUI** كواجهة و **Swift** كلغة
4. انسخ جميع ملفات المصدر من مجلد `ARVisionExplorer/` إلى المشروع
5. تأكد من إضافة `Info.plist` و `Assets.xcassets`

### إعداد المشروع

1. افتح المشروع في Xcode
2. اختر **Team** الخاص بك في إعدادات التوقيع (Signing)
3. غيّر **Bundle Identifier** إلى معرّفك الخاص
4. وصّل جهاز iPhone (المحاكي لا يدعم ARKit)
5. اضغط **Run** (⌘R)

## هيكل المشروع

```
ARVisionExplorer/
├── App/
│   ├── ARVisionExplorerApp.swift    # نقطة الدخول
│   └── ContentView.swift            # الواجهة الرئيسية
├── Design/
│   ├── AppTheme.swift               # الألوان والخطوط
│   ├── GlassmorphicModifiers.swift  # تأثيرات الزجاج
│   └── AnimationConstants.swift     # ثوابت الحركة
├── Models/
│   ├── DetectedObject.swift         # نموذج الجسم المكتشف
│   ├── ObjectComponent.swift        # مكونات الأجسام المفصلة
│   └── ProductDatabase.swift        # قاعدة بيانات المنتجات
├── ViewModels/
│   ├── ARViewModel.swift            # إدارة جلسة AR
│   ├── ObjectDetectionViewModel.swift # كشف الأجسام
│   └── AvatarViewModel.swift        # حالة الشخصية الرقمية
├── Views/
│   ├── AR/
│   │   └── ARContainerView.swift    # UIViewRepresentable لـ ARView
│   ├── Overlay/
│   │   ├── ScanningOverlayView.swift # تأثيرات المسح
│   │   ├── ObjectInfoCard.swift     # بطاقة معلومات الجسم
│   │   └── ExplodedDetailPanel.swift # لوحة التفكيك
│   ├── Avatar/
│   │   └── AvatarOverlayView.swift  # واجهة الشخصية الرقمية
│   └── Components/
│       ├── GlassCard.swift          # بطاقة زجاجية قابلة لإعادة الاستخدام
│       ├── PulsingDot.swift         # نقطة نابضة
│       └── ComponentLabel.swift     # تسمية المكونات
├── Services/
│   ├── HapticEngine.swift           # محرك الاهتزاز التفاعلي
│   └── SpeechService.swift          # خدمة النطق الصوتي
├── AR/
│   ├── ExplodedViewEntity.swift     # كيانات RealityKit للتفكيك
│   ├── TrackingVisualsEntity.swift  # تأثيرات التتبع البصري
│   └── AvatarEntity.swift           # كيان الشخصية ثلاثية الأبعاد
├── Extensions/
│   └── View+Extensions.swift        # إضافات SwiftUI
└── Resources/
    ├── Info.plist                    # إعدادات التطبيق
    └── Assets.xcassets/             # الأصول والأيقونات
```

## كيفية الاستخدام

1. **افتح التطبيق** - تظهر كاميرا AR مع نقاط تتبع ذكية
2. **وجّه الكاميرا** نحو هاتف أو ساعة أو حاسوب محمول
3. **تعرّف AI** - تظهر بطاقة زجاجية تحتوي على اسم المنتج ونسبة الثقة
4. **اضغط مطولاً** على الجسم المكتشف - يتفكك الجسم إلى مكوناته الداخلية
5. **تصفح المكونات** - اسحب أفقياً لرؤية جميع القطع واضغط على أي قطعة لمعرفة تفاصيلها
6. **اضغط مرة أخرى** لإعادة تجميع الجسم

## المنتجات المدعومة (MVP)

| المنتج | المكونات |
|--------|----------|
| iPhone 15 Pro Max | 7 قطع (شاشة، OLED، لوحة أم، بطارية، كاميرا، زجاج خلفي، إطار) |
| Apple Watch Ultra 2 | 6 قطع (كريستال، شاشة، معالج، مستشعرات، بطارية، غلاف) |
| MacBook Pro 16" | 6 قطع (شاشة، معالج، ذاكرة، بطارية، لوحة مفاتيح، هيكل) |

## التقنيات المستخدمة

- **SwiftUI** - واجهة المستخدم التعريفية
- **RealityKit** - العرض ثلاثي الأبعاد والواقع المعزز
- **ARKit** - تتبع العالم واكتشاف المساحات
- **Vision Framework** - التعرف على الأجسام وتصنيفها
- **Core Haptics** - اهتزاز تفاعلي مخصص
- **AVSpeechSynthesizer** - النطق الصوتي العربي

## التطوير المستقبلي

- [ ] إضافة نماذج Core ML مخصصة للتعرف الدقيق
- [ ] دعم المزيد من فئات المنتجات (سيارات، أجهزة منزلية)
- [ ] شخصية رقمية واقعية بنموذج USDZ مفصل
- [ ] التعرف الصوتي والمحادثة مع AI
- [ ] دعم visionOS لـ Apple Vision Pro
- [ ] مشاركة التفكيكات عبر SharePlay

## الترخيص

هذا المشروع متاح للاستخدام الشخصي والتعليمي.
