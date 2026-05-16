import SwiftUI

// MARK: - RTL Support
extension View {
    func rtlEnvironment() -> some View {
        self.environment(\.layoutDirection, .rightToLeft)
    }
}

// MARK: - Haptic Tap
extension View {
    func hapticTap(
        style: UIImpactFeedbackGenerator.FeedbackStyle = .light,
        action: @escaping () -> Void
    ) -> some View {
        self.onTapGesture {
            HapticEngine.shared.playImpact(style: style)
            action()
        }
    }
}

// MARK: - Fade Edge
extension View {
    func fadeEdges(
        top: Bool = false,
        bottom: Bool = false,
        length: CGFloat = 20
    ) -> some View {
        self.mask(
            VStack(spacing: 0) {
                if top {
                    LinearGradient(
                        colors: [.clear, .white],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: length)
                }

                Rectangle().fill(Color.white)

                if bottom {
                    LinearGradient(
                        colors: [.white, .clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: length)
                }
            }
        )
    }
}

// MARK: - Animated Appearance
extension View {
    func animatedAppearance(delay: Double = 0) -> some View {
        self.modifier(AnimatedAppearanceModifier(delay: delay))
    }
}

struct AnimatedAppearanceModifier: ViewModifier {
    let delay: Double
    @State private var isVisible = false

    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 20)
            .animation(
                AnimationConstants.gentleSpring.delay(delay),
                value: isVisible
            )
            .onAppear {
                isVisible = true
            }
    }
}
