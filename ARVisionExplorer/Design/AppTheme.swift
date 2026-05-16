import SwiftUI

// MARK: - App Colors
extension Color {
    /// True black background for OLED screens
    static let trueBlack = Color(red: 0.02, green: 0.02, blue: 0.03)

    /// Deep dark background with slight blue tint
    static let deepDark = Color(red: 0.05, green: 0.05, blue: 0.08)

    /// Accent glow color - cyan/electric blue
    static let accentGlow = Color(red: 0.40, green: 0.82, blue: 1.0)

    /// Secondary accent - soft violet
    static let secondaryGlow = Color(red: 0.65, green: 0.45, blue: 1.0)

    /// Tertiary accent - warm amber for warnings/highlights
    static let tertiaryGlow = Color(red: 1.0, green: 0.78, blue: 0.32)

    /// Glass border color
    static let glassBorder = Color.white.opacity(0.15)

    /// Glass fill color
    static let glassFill = Color.white.opacity(0.06)

    /// Scanning beam color
    static let scanBeam = Color(red: 0.30, green: 0.90, blue: 1.0)
}

// MARK: - App Typography
struct AppFont {
    static let titleLarge = Font.system(size: 28, weight: .bold, design: .rounded)
    static let titleMedium = Font.system(size: 22, weight: .semibold, design: .rounded)
    static let titleSmall = Font.system(size: 18, weight: .semibold, design: .rounded)
    static let bodyPrimary = Font.system(size: 16, weight: .regular, design: .rounded)
    static let bodySecondary = Font.system(size: 14, weight: .regular, design: .rounded)
    static let caption = Font.system(size: 12, weight: .medium, design: .rounded)
    static let micro = Font.system(size: 10, weight: .medium, design: .rounded)
}

// MARK: - App Spacing
struct AppSpacing {
    static let xxs: CGFloat = 2
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
    static let xxxl: CGFloat = 48
}

// MARK: - Glass Material Properties
struct GlassMaterial {
    static let backgroundOpacity: CGFloat = 0.06
    static let borderOpacity: CGFloat = 0.15
    static let blurRadius: CGFloat = 20
    static let cornerRadius: CGFloat = 16
    static let borderWidth: CGFloat = 0.5
}
