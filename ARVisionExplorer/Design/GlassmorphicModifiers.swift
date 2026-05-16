import SwiftUI

// MARK: - Glassmorphic Background Modifier
struct GlassmorphicBackground: ViewModifier {
    let cornerRadius: CGFloat
    let opacity: CGFloat
    let borderOpacity: CGFloat

    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    // Frosted glass base
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(.ultraThinMaterial)
                        .opacity(0.6)

                    // Dark overlay for True Black feel
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color.trueBlack.opacity(opacity))

                    // Subtle gradient highlight on top edge
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.08),
                                    Color.clear,
                                    Color.clear
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.white.opacity(borderOpacity), lineWidth: GlassMaterial.borderWidth)
            )
    }
}

// MARK: - Glow Border Modifier
struct GlowBorder: ViewModifier {
    let color: Color
    let cornerRadius: CGFloat
    let lineWidth: CGFloat

    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(color.opacity(0.6), lineWidth: lineWidth)
            )
            .shadow(color: color.opacity(0.3), radius: 8, x: 0, y: 0)
    }
}

// MARK: - Scanning Pulse Modifier
struct ScanningPulse: ViewModifier {
    @State private var isPulsing = false

    let color: Color

    func body(content: Content) -> some View {
        content
            .overlay(
                Circle()
                    .stroke(color.opacity(isPulsing ? 0.0 : 0.6), lineWidth: 2)
                    .scaleEffect(isPulsing ? 2.0 : 1.0)
                    .animation(
                        .easeOut(duration: 1.5)
                        .repeatForever(autoreverses: false),
                        value: isPulsing
                    )
            )
            .onAppear { isPulsing = true }
    }
}

// MARK: - Shimmer Effect
struct ShimmerEffect: ViewModifier {
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    LinearGradient(
                        colors: [
                            .clear,
                            Color.white.opacity(0.1),
                            .clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geometry.size.width * 0.5)
                    .offset(x: -geometry.size.width * 0.25 + phase * geometry.size.width * 1.5)
                    .animation(
                        .linear(duration: 2.0)
                        .repeatForever(autoreverses: false),
                        value: phase
                    )
                }
                .mask(content)
            )
            .onAppear { phase = 1 }
    }
}

// MARK: - View Extensions
extension View {
    func glassBackground(
        cornerRadius: CGFloat = GlassMaterial.cornerRadius,
        opacity: CGFloat = 0.7,
        borderOpacity: CGFloat = GlassMaterial.borderOpacity
    ) -> some View {
        modifier(GlassmorphicBackground(
            cornerRadius: cornerRadius,
            opacity: opacity,
            borderOpacity: borderOpacity
        ))
    }

    func glowBorder(
        color: Color = .accentGlow,
        cornerRadius: CGFloat = GlassMaterial.cornerRadius,
        lineWidth: CGFloat = 1.0
    ) -> some View {
        modifier(GlowBorder(color: color, cornerRadius: cornerRadius, lineWidth: lineWidth))
    }

    func scanningPulse(color: Color = .accentGlow) -> some View {
        modifier(ScanningPulse(color: color))
    }

    func shimmer() -> some View {
        modifier(ShimmerEffect())
    }
}
