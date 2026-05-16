import SwiftUI

struct PulsingDot: View {
    let color: Color
    let size: CGFloat
    let isActive: Bool

    @State private var isPulsing = false

    init(color: Color = .accentGlow, size: CGFloat = 8, isActive: Bool = true) {
        self.color = color
        self.size = size
        self.isActive = isActive
    }

    var body: some View {
        ZStack {
            if isActive {
                // Pulse ring
                Circle()
                    .stroke(color.opacity(0.3), lineWidth: 1)
                    .frame(width: size * 2.5, height: size * 2.5)
                    .scaleEffect(isPulsing ? 1.5 : 1.0)
                    .opacity(isPulsing ? 0 : 0.6)
                    .animation(
                        .easeOut(duration: 1.5)
                        .repeatForever(autoreverses: false),
                        value: isPulsing
                    )
            }

            // Core dot
            Circle()
                .fill(color)
                .frame(width: size, height: size)
                .shadow(color: color.opacity(isActive ? 0.6 : 0.2), radius: isActive ? 4 : 1)
        }
        .onAppear {
            if isActive {
                isPulsing = true
            }
        }
    }
}

// MARK: - Animated Dots Loading
struct LoadingDots: View {
    @State private var dotOpacities: [Double] = [0.3, 0.3, 0.3]
    let color: Color

    init(color: Color = .accentGlow) {
        self.color = color
    }

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(color)
                    .frame(width: 4, height: 4)
                    .opacity(dotOpacities[index])
            }
        }
        .onAppear {
            animateDots()
        }
    }

    private func animateDots() {
        for index in 0..<3 {
            withAnimation(
                .easeInOut(duration: 0.6)
                .repeatForever(autoreverses: true)
                .delay(Double(index) * 0.2)
            ) {
                dotOpacities[index] = 1.0
            }
        }
    }
}
