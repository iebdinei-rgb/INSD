import SwiftUI

struct AvatarOverlayView: View {
    @EnvironmentObject var avatarViewModel: AvatarViewModel
    @State private var orbRotation: Double = 0
    @State private var glowPulse = false

    var body: some View {
        VStack(spacing: 16) {
            // MARK: - Avatar Orb
            ZStack {
                // Outer glow rings
                ForEach(0..<3, id: \.self) { ring in
                    Circle()
                        .stroke(
                            avatarViewModel.avatarMood.glowColor.opacity(
                                0.1 - Double(ring) * 0.03
                            ),
                            lineWidth: 1
                        )
                        .frame(
                            width: CGFloat(80 + ring * 20),
                            height: CGFloat(80 + ring * 20)
                        )
                        .rotationEffect(.degrees(orbRotation + Double(ring) * 30))
                }

                // Main orb
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                avatarViewModel.avatarMood.glowColor.opacity(0.6),
                                avatarViewModel.avatarMood.glowColor.opacity(0.2),
                                Color.trueBlack.opacity(0.8)
                            ],
                            center: .center,
                            startRadius: 5,
                            endRadius: 35
                        )
                    )
                    .frame(width: 70, height: 70)
                    .shadow(
                        color: avatarViewModel.avatarMood.glowColor.opacity(
                            avatarViewModel.glowIntensity
                        ),
                        radius: 20
                    )
                    .scaleEffect(avatarViewModel.breathingScale)

                // Inner core
                Circle()
                    .fill(avatarViewModel.avatarMood.glowColor.opacity(0.8))
                    .frame(width: 20, height: 20)
                    .blur(radius: avatarViewModel.isSpeaking ? 3 : 1)
                    .scaleEffect(avatarViewModel.isSpeaking ? 1.3 : 1.0)
                    .animation(
                        .easeInOut(duration: 0.3).repeatForever(autoreverses: true),
                        value: avatarViewModel.isSpeaking
                    )

                // Speaking wave indicator
                if avatarViewModel.isSpeaking {
                    ForEach(0..<3, id: \.self) { wave in
                        Circle()
                            .stroke(
                                avatarViewModel.avatarMood.glowColor.opacity(0.3),
                                lineWidth: 1.5
                            )
                            .frame(width: CGFloat(30 + wave * 15), height: CGFloat(30 + wave * 15))
                            .scaleEffect(glowPulse ? 1.5 : 1.0)
                            .opacity(glowPulse ? 0 : 0.6)
                            .animation(
                                .easeOut(duration: 1.0)
                                .repeatForever(autoreverses: false)
                                .delay(Double(wave) * 0.3),
                                value: glowPulse
                            )
                    }
                }

                // Orbital particle
                Circle()
                    .fill(avatarViewModel.avatarMood.glowColor)
                    .frame(width: 4, height: 4)
                    .offset(x: 40)
                    .rotationEffect(.degrees(orbRotation))
                    .shadow(
                        color: avatarViewModel.avatarMood.glowColor.opacity(0.6),
                        radius: 4
                    )
            }

            // MARK: - Speech Bubble
            if !avatarViewModel.currentMessage.isEmpty {
                speechBubble
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.8, anchor: .top).combined(with: .opacity),
                        removal: .opacity
                    ))
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 8.0).repeatForever(autoreverses: false)) {
                orbRotation = 360
            }
            glowPulse = true
        }
    }

    // MARK: - Speech Bubble
    private var speechBubble: some View {
        VStack(spacing: 0) {
            // Pointer triangle
            Triangle()
                .fill(Color.trueBlack.opacity(0.8))
                .frame(width: 16, height: 8)

            // Message text
            Text(avatarViewModel.currentMessage)
                .font(AppFont.bodyPrimary)
                .foregroundStyle(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
                .glassBackground(cornerRadius: 16, opacity: 0.85, borderOpacity: 0.2)
                .glowBorder(
                    color: avatarViewModel.avatarMood.glowColor,
                    cornerRadius: 16,
                    lineWidth: 0.5
                )
        }
        .frame(maxWidth: 300)
    }
}

// MARK: - Triangle Shape
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
