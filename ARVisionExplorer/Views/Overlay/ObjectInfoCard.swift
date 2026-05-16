import SwiftUI

struct ObjectInfoCard: View {
    let object: DetectedObject
    @State private var isExpanded = false
    @State private var glowPulse = false

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Header
            HStack(spacing: 12) {
                // Category Icon
                ZStack {
                    Circle()
                        .fill(Color.accentGlow.opacity(0.15))
                        .frame(width: 44, height: 44)

                    Image(systemName: object.category.icon)
                        .font(.title3)
                        .foregroundStyle(Color.accentGlow)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(object.nameArabic)
                        .font(AppFont.titleSmall)
                        .foregroundStyle(.white)
                        .lineLimit(1)

                    HStack(spacing: 8) {
                        Text(object.manufacturer)
                            .font(AppFont.caption)
                            .foregroundStyle(.white.opacity(0.6))

                        Text("•")
                            .foregroundStyle(.white.opacity(0.3))

                        Text(object.releaseYear)
                            .font(AppFont.caption)
                            .foregroundStyle(.white.opacity(0.6))
                    }
                }

                Spacer()

                // Confidence Badge
                confidenceBadge
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)

            // MARK: - Expanded Details
            if isExpanded {
                Divider()
                    .background(Color.glassBorder)
                    .padding(.horizontal, 16)

                VStack(spacing: 12) {
                    detailRow(
                        icon: "cpu",
                        label: "الفئة",
                        value: object.category.nameArabic
                    )

                    detailRow(
                        icon: "building.2.fill",
                        label: "الشركة المصنعة",
                        value: object.manufacturer
                    )

                    detailRow(
                        icon: "calendar",
                        label: "سنة الإصدار",
                        value: object.releaseYear
                    )

                    // Long Press Hint
                    HStack(spacing: 8) {
                        Image(systemName: "hand.tap.fill")
                            .font(.caption)
                            .foregroundStyle(Color.accentGlow)

                        Text("اضغط مطولاً لتفكيك الجسم ورؤية مكوناته الداخلية")
                            .font(AppFont.caption)
                            .foregroundStyle(Color.accentGlow.opacity(0.8))
                    }
                    .padding(.top, 4)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .glassBackground(cornerRadius: 20, opacity: 0.8, borderOpacity: 0.2)
        .glowBorder(
            color: Color.accentGlow,
            cornerRadius: 20,
            lineWidth: glowPulse ? 1.0 : 0.5
        )
        .onTapGesture {
            withAnimation(AnimationConstants.snappySpring) {
                isExpanded.toggle()
            }
            HapticEngine.shared.playSelection()
        }
        .onAppear {
            HapticEngine.shared.playScanDetectedHaptic()
            withAnimation(
                .easeInOut(duration: AnimationConstants.glowPulseDuration)
                .repeatForever(autoreverses: true)
            ) {
                glowPulse = true
            }
        }
    }

    // MARK: - Confidence Badge
    private var confidenceBadge: some View {
        let percentage = Int(object.confidence * 100)
        let color: Color = percentage > 80 ? .accentGlow :
                           percentage > 60 ? .tertiaryGlow : .secondaryGlow

        return HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 6, height: 6)

            Text("\(percentage)%")
                .font(AppFont.caption)
                .foregroundStyle(color)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(color.opacity(0.12))
        .clipShape(Capsule())
    }

    // MARK: - Detail Row
    private func detailRow(icon: String, label: String, value: String) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(Color.accentGlow.opacity(0.6))
                .frame(width: 20)

            Text(label)
                .font(AppFont.bodySecondary)
                .foregroundStyle(.white.opacity(0.5))

            Spacer()

            Text(value)
                .font(AppFont.bodySecondary)
                .foregroundStyle(.white.opacity(0.9))
        }
    }
}
