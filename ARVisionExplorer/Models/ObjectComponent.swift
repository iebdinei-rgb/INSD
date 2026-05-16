import Foundation
import SwiftUI
import simd

struct ObjectComponent: Identifiable {
    let id: UUID
    let name: String
    let nameArabic: String
    let material: String
    let materialArabic: String
    let function: String
    let functionArabic: String
    let color: Color
    let relativePosition: SIMD3<Float>
    let explodedOffset: SIMD3<Float>
    let size: SIMD3<Float>
    let order: Int

    static func componentsForCategory(_ category: ObjectCategory) -> [ObjectComponent] {
        switch category {
        case .smartphone:
            return smartphoneComponents
        case .watch:
            return watchComponents
        case .laptop:
            return laptopComponents
        default:
            return genericComponents
        }
    }

    // MARK: - Smartphone Components
    private static let smartphoneComponents: [ObjectComponent] = [
        ObjectComponent(
            id: UUID(), name: "Glass Display", nameArabic: "الشاشة الزجاجية",
            material: "Ceramic Shield Glass", materialArabic: "زجاج سيراميك درع",
            function: "Touch input and visual output", functionArabic: "الإدخال باللمس والعرض المرئي",
            color: .accentGlow, relativePosition: [0, 0.06, 0],
            explodedOffset: [0, 0.15, 0], size: [0.07, 0.002, 0.14], order: 0
        ),
        ObjectComponent(
            id: UUID(), name: "OLED Panel", nameArabic: "لوحة OLED",
            material: "Organic LED", materialArabic: "LED عضوي",
            function: "Super Retina XDR display", functionArabic: "شاشة Super Retina XDR",
            color: .secondaryGlow, relativePosition: [0, 0.04, 0],
            explodedOffset: [0, 0.10, 0], size: [0.065, 0.001, 0.135], order: 1
        ),
        ObjectComponent(
            id: UUID(), name: "Logic Board", nameArabic: "اللوحة الأم",
            material: "Multi-layer PCB", materialArabic: "لوحة دوائر مطبوعة متعددة الطبقات",
            function: "A17 Pro chipset & memory", functionArabic: "معالج A17 Pro والذاكرة",
            color: .tertiaryGlow, relativePosition: [0, 0.02, 0],
            explodedOffset: [0, 0.05, 0], size: [0.06, 0.002, 0.10], order: 2
        ),
        ObjectComponent(
            id: UUID(), name: "Battery", nameArabic: "البطارية",
            material: "Lithium-ion Polymer", materialArabic: "ليثيوم أيون بوليمر",
            function: "Power supply 4422 mAh", functionArabic: "مصدر الطاقة 4422 mAh",
            color: Color(red: 0.3, green: 0.9, blue: 0.5), relativePosition: [0, -0.01, 0.02],
            explodedOffset: [0, 0.0, 0], size: [0.055, 0.004, 0.08], order: 3
        ),
        ObjectComponent(
            id: UUID(), name: "Camera Module", nameArabic: "وحدة الكاميرا",
            material: "Sapphire Crystal Lens", materialArabic: "عدسة كريستال الياقوت",
            function: "48MP main + 12MP ultra-wide + 12MP telephoto", functionArabic: "48 م.ب رئيسية + 12 م.ب عريضة + 12 م.ب مقربة",
            color: Color(red: 1.0, green: 0.5, blue: 0.3), relativePosition: [0, -0.03, -0.04],
            explodedOffset: [0, -0.05, -0.05], size: [0.03, 0.006, 0.03], order: 4
        ),
        ObjectComponent(
            id: UUID(), name: "Back Glass", nameArabic: "الزجاج الخلفي",
            material: "Matte Glass", materialArabic: "زجاج مطفي",
            function: "Wireless charging & structural", functionArabic: "شحن لاسلكي وهيكلي",
            color: Color.white.opacity(0.5), relativePosition: [0, -0.06, 0],
            explodedOffset: [0, -0.12, 0], size: [0.07, 0.001, 0.14], order: 5
        ),
        ObjectComponent(
            id: UUID(), name: "Titanium Frame", nameArabic: "إطار التيتانيوم",
            material: "Grade 5 Titanium", materialArabic: "تيتانيوم درجة 5",
            function: "Structural frame & antenna", functionArabic: "الإطار الهيكلي والهوائي",
            color: Color(red: 0.7, green: 0.7, blue: 0.75), relativePosition: [0, 0, 0],
            explodedOffset: [0, -0.18, 0], size: [0.072, 0.008, 0.145], order: 6
        ),
    ]

    // MARK: - Watch Components
    private static let watchComponents: [ObjectComponent] = [
        ObjectComponent(
            id: UUID(), name: "Sapphire Crystal", nameArabic: "كريستال الياقوت",
            material: "Sapphire Crystal", materialArabic: "كريستال الياقوت الأزرق",
            function: "Scratch-resistant cover", functionArabic: "غطاء مقاوم للخدش",
            color: .accentGlow, relativePosition: [0, 0.03, 0],
            explodedOffset: [0, 0.10, 0], size: [0.04, 0.001, 0.045], order: 0
        ),
        ObjectComponent(
            id: UUID(), name: "OLED Display", nameArabic: "شاشة OLED",
            material: "LTPO OLED", materialArabic: "LTPO OLED",
            function: "Always-On Retina display", functionArabic: "شاشة Retina دائمة التشغيل",
            color: .secondaryGlow, relativePosition: [0, 0.02, 0],
            explodedOffset: [0, 0.07, 0], size: [0.035, 0.001, 0.04], order: 1
        ),
        ObjectComponent(
            id: UUID(), name: "S9 Chip", nameArabic: "معالج S9",
            material: "Silicon", materialArabic: "سيليكون",
            function: "Main processor & neural engine", functionArabic: "المعالج الرئيسي والمحرك العصبي",
            color: .tertiaryGlow, relativePosition: [0, 0.01, 0],
            explodedOffset: [0, 0.04, 0], size: [0.015, 0.002, 0.015], order: 2
        ),
        ObjectComponent(
            id: UUID(), name: "Health Sensors", nameArabic: "مستشعرات الصحة",
            material: "Ceramic & Sapphire", materialArabic: "سيراميك وياقوت",
            function: "Heart rate, SpO2, temperature", functionArabic: "نبض القلب، تشبع الأكسجين، الحرارة",
            color: Color(red: 1.0, green: 0.4, blue: 0.4), relativePosition: [0, -0.02, 0],
            explodedOffset: [0, -0.04, 0], size: [0.025, 0.003, 0.025], order: 3
        ),
        ObjectComponent(
            id: UUID(), name: "Battery", nameArabic: "البطارية",
            material: "Lithium-ion", materialArabic: "ليثيوم أيون",
            function: "308 mAh rechargeable", functionArabic: "بطارية 308 mAh قابلة للشحن",
            color: Color(red: 0.3, green: 0.9, blue: 0.5), relativePosition: [0, 0, 0],
            explodedOffset: [0, 0.01, 0], size: [0.03, 0.003, 0.025], order: 4
        ),
        ObjectComponent(
            id: UUID(), name: "Titanium Case", nameArabic: "غلاف التيتانيوم",
            material: "Grade 5 Titanium", materialArabic: "تيتانيوم درجة 5",
            function: "Water-resistant housing", functionArabic: "غلاف مقاوم للماء",
            color: Color(red: 0.7, green: 0.7, blue: 0.75), relativePosition: [0, -0.01, 0],
            explodedOffset: [0, -0.08, 0], size: [0.042, 0.01, 0.048], order: 5
        ),
    ]

    // MARK: - Laptop Components
    private static let laptopComponents: [ObjectComponent] = [
        ObjectComponent(
            id: UUID(), name: "Liquid Retina Display", nameArabic: "شاشة Liquid Retina",
            material: "Mini-LED", materialArabic: "Mini-LED",
            function: "XDR display with ProMotion", functionArabic: "شاشة XDR مع ProMotion",
            color: .accentGlow, relativePosition: [0, 0.08, -0.08],
            explodedOffset: [0, 0.15, -0.10], size: [0.30, 0.003, 0.20], order: 0
        ),
        ObjectComponent(
            id: UUID(), name: "M3 Max Chip", nameArabic: "معالج M3 Max",
            material: "3nm Silicon", materialArabic: "سيليكون 3 نانومتر",
            function: "CPU 16-core + GPU 40-core", functionArabic: "معالج 16 نواة + رسومات 40 نواة",
            color: .tertiaryGlow, relativePosition: [0, 0.02, 0.05],
            explodedOffset: [0, 0.08, 0.05], size: [0.04, 0.003, 0.04], order: 1
        ),
        ObjectComponent(
            id: UUID(), name: "Unified Memory", nameArabic: "الذاكرة الموحدة",
            material: "LPDDR5", materialArabic: "LPDDR5",
            function: "36GB unified architecture", functionArabic: "36 جيجا معمارية موحدة",
            color: .secondaryGlow, relativePosition: [0.05, 0.02, 0.05],
            explodedOffset: [0.10, 0.08, 0.05], size: [0.02, 0.002, 0.03], order: 2
        ),
        ObjectComponent(
            id: UUID(), name: "Battery Pack", nameArabic: "مجموعة البطاريات",
            material: "Lithium Polymer", materialArabic: "ليثيوم بوليمر",
            function: "100Wh - 22 hours battery", functionArabic: "100 واط/ساعة - 22 ساعة",
            color: Color(red: 0.3, green: 0.9, blue: 0.5), relativePosition: [0, -0.01, 0.06],
            explodedOffset: [0, -0.05, 0.06], size: [0.25, 0.006, 0.08], order: 3
        ),
        ObjectComponent(
            id: UUID(), name: "Keyboard & Trackpad", nameArabic: "لوحة المفاتيح ولوحة التتبع",
            material: "Aluminum & Glass", materialArabic: "ألمنيوم وزجاج",
            function: "Force Touch trackpad", functionArabic: "لوحة تتبع Force Touch",
            color: Color.white.opacity(0.5), relativePosition: [0, 0.005, 0.07],
            explodedOffset: [0, 0.02, 0.12], size: [0.28, 0.003, 0.10], order: 4
        ),
        ObjectComponent(
            id: UUID(), name: "Aluminum Unibody", nameArabic: "هيكل ألمنيوم موحد",
            material: "Recycled Aluminum", materialArabic: "ألمنيوم معاد تدويره",
            function: "Structural chassis", functionArabic: "الهيكل الأساسي",
            color: Color(red: 0.7, green: 0.7, blue: 0.75), relativePosition: [0, -0.02, 0.05],
            explodedOffset: [0, -0.12, 0.05], size: [0.31, 0.015, 0.22], order: 5
        ),
    ]

    // MARK: - Generic Components
    private static let genericComponents: [ObjectComponent] = [
        ObjectComponent(
            id: UUID(), name: "Outer Shell", nameArabic: "الغلاف الخارجي",
            material: "Mixed Materials", materialArabic: "مواد مختلطة",
            function: "External casing", functionArabic: "الغلاف الخارجي",
            color: .accentGlow, relativePosition: [0, 0.03, 0],
            explodedOffset: [0, 0.10, 0], size: [0.08, 0.002, 0.08], order: 0
        ),
        ObjectComponent(
            id: UUID(), name: "Internal Circuit", nameArabic: "الدائرة الداخلية",
            material: "PCB", materialArabic: "لوحة دوائر مطبوعة",
            function: "Main circuit board", functionArabic: "لوحة الدوائر الرئيسية",
            color: .tertiaryGlow, relativePosition: [0, 0.01, 0],
            explodedOffset: [0, 0.04, 0], size: [0.06, 0.002, 0.06], order: 1
        ),
        ObjectComponent(
            id: UUID(), name: "Power Unit", nameArabic: "وحدة الطاقة",
            material: "Lithium Cell", materialArabic: "خلية ليثيوم",
            function: "Power source", functionArabic: "مصدر الطاقة",
            color: Color(red: 0.3, green: 0.9, blue: 0.5), relativePosition: [0, -0.01, 0],
            explodedOffset: [0, -0.03, 0], size: [0.04, 0.005, 0.05], order: 2
        ),
    ]
}
