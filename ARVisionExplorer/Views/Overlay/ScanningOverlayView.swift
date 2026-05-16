import SwiftUI

struct ScanningOverlayView: View {
    @EnvironmentObject var arViewModel: ARViewModel
    @State private var scanLineOffset: CGFloat = -200
    @State private var gridOpacity: Double = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // MARK: - Tracking Points (AI Analysis Dots)
                ForEach(arViewModel.trackingPoints) { point in
                    TrackingDotView(
                        opacity: point.opacity,
                        scale: point.scale
                    )
                    .position(point.position)
                    .animation(
                        .easeInOut(duration: AnimationConstants.trackingPointFadeDuration),
                        value: point.opacity
                    )
                }

                // MARK: - Scan Line
                ScanLineView()
                    .offset(y: scanLineOffset)
                    .animation(
                        .linear(duration: AnimationConstants.scanLineDuration)
                        .repeatForever(autoreverses: true),
                        value: scanLineOffset
                    )

                // MARK: - Corner Brackets
                cornerBrackets(in: geometry.size)
                    .opacity(gridOpacity)
                    .animation(.easeIn(duration: 1.0), value: gridOpacity)
            }
        }
        .onAppear {
            scanLineOffset = UIScreen.main.bounds.height + 200
            withAnimation(.easeIn(duration: 0.8)) {
                gridOpacity = 1.0
            }
        }
    }

    // MARK: - Corner Brackets
    private func cornerBrackets(in size: CGSize) -> some View {
        let bracketLength: CGFloat = 40
        let bracketThickness: CGFloat = 2
        let margin: CGFloat = 60

        return ZStack {
            // Top-Left
            cornerBracket(
                at: CGPoint(x: margin, y: margin + 40),
                length: bracketLength,
                thickness: bracketThickness,
                rotation: 0
            )
            // Top-Right
            cornerBracket(
                at: CGPoint(x: size.width - margin, y: margin + 40),
                length: bracketLength,
                thickness: bracketThickness,
                rotation: 90
            )
            // Bottom-Left
            cornerBracket(
                at: CGPoint(x: margin, y: size.height - margin - 40),
                length: bracketLength,
                thickness: bracketThickness,
                rotation: 270
            )
            // Bottom-Right
            cornerBracket(
                at: CGPoint(x: size.width - margin, y: size.height - margin - 40),
                length: bracketLength,
                thickness: bracketThickness,
                rotation: 180
            )
        }
    }

    private func cornerBracket(
        at position: CGPoint,
        length: CGFloat,
        thickness: CGFloat,
        rotation: Double
    ) -> some View {
        ZStack {
            Rectangle()
                .fill(Color.accentGlow.opacity(0.5))
                .frame(width: length, height: thickness)
                .offset(x: length / 2, y: 0)

            Rectangle()
                .fill(Color.accentGlow.opacity(0.5))
                .frame(width: thickness, height: length)
                .offset(x: 0, y: length / 2)
        }
        .rotationEffect(.degrees(rotation))
        .position(position)
    }
}

// MARK: - Tracking Dot View
struct TrackingDotView: View {
    let opacity: Double
    let scale: CGFloat
    @State private var isPulsing = false

    var body: some View {
        ZStack {
            // Outer pulse ring
            Circle()
                .stroke(Color.accentGlow.opacity(opacity * 0.3), lineWidth: 1)
                .frame(width: 16 * scale, height: 16 * scale)
                .scaleEffect(isPulsing ? 1.5 : 1.0)
                .opacity(isPulsing ? 0 : 1)

            // Core dot
            Circle()
                .fill(Color.accentGlow.opacity(opacity))
                .frame(width: 4 * scale, height: 4 * scale)
                .shadow(color: Color.accentGlow.opacity(opacity * 0.5), radius: 4)

            // Cross hair
            Rectangle()
                .fill(Color.accentGlow.opacity(opacity * 0.4))
                .frame(width: 12 * scale, height: 0.5)

            Rectangle()
                .fill(Color.accentGlow.opacity(opacity * 0.4))
                .frame(width: 0.5, height: 12 * scale)
        }
        .onAppear {
            withAnimation(
                .easeOut(duration: 1.0)
                .repeatForever(autoreverses: false)
            ) {
                isPulsing = true
            }
        }
    }
}

// MARK: - Scan Line View
struct ScanLineView: View {
    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [
                        Color.scanBeam.opacity(0),
                        Color.scanBeam.opacity(0.15),
                        Color.scanBeam.opacity(0.4),
                        Color.scanBeam.opacity(0.15),
                        Color.scanBeam.opacity(0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(height: 120)
    }
}
