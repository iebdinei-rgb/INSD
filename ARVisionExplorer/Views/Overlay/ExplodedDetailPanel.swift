import SwiftUI

struct ExplodedDetailPanel: View {
    let components: [ObjectComponent]
    let productName: String
    @State private var selectedComponent: ObjectComponent?
    @State private var animateIn = false

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Panel Header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("التفكيك الداخلي")
                        .font(AppFont.titleSmall)
                        .foregroundStyle(.white)

                    Text("\(components.count) قطعة - \(productName)")
                        .font(AppFont.caption)
                        .foregroundStyle(.white.opacity(0.5))
                }

                Spacer()

                Image(systemName: "cube.transparent.fill")
                    .font(.title2)
                    .foregroundStyle(Color.accentGlow)
                    .symbolEffect(.pulse, options: .repeating)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 12)

            Divider()
                .background(Color.glassBorder)
                .padding(.horizontal, 16)

            // MARK: - Components List
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(Array(components.enumerated()), id: \.element.id) { index, component in
                        ComponentChip(
                            component: component,
                            isSelected: selectedComponent?.id == component.id,
                            delay: Double(index) * 0.08
                        )
                        .onTapGesture {
                            withAnimation(AnimationConstants.snappySpring) {
                                if selectedComponent?.id == component.id {
                                    selectedComponent = nil
                                } else {
                                    selectedComponent = component
                                }
                            }
                            HapticEngine.shared.playSelection()
                        }
                        .offset(y: animateIn ? 0 : 30)
                        .opacity(animateIn ? 1 : 0)
                        .animation(
                            AnimationConstants.gentleSpring.delay(Double(index) * 0.08),
                            value: animateIn
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }

            // MARK: - Selected Component Detail
            if let selected = selectedComponent {
                Divider()
                    .background(Color.glassBorder)
                    .padding(.horizontal, 16)

                ComponentDetailView(component: selected)
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .opacity
                    ))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
            }
        }
        .glassBackground(cornerRadius: 24, opacity: 0.85, borderOpacity: 0.2)
        .onAppear {
            withAnimation {
                animateIn = true
            }
        }
    }
}

// MARK: - Component Chip
struct ComponentChip: View {
    let component: ObjectComponent
    let isSelected: Bool
    let delay: Double

    var body: some View {
        VStack(spacing: 6) {
            // Color indicator dot
            Circle()
                .fill(component.color)
                .frame(width: 10, height: 10)
                .shadow(color: component.color.opacity(0.5), radius: isSelected ? 6 : 2)

            Text(component.nameArabic)
                .font(AppFont.micro)
                .foregroundStyle(.white.opacity(isSelected ? 1.0 : 0.7))
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .frame(width: 72, height: 56)
        .padding(.vertical, 8)
        .padding(.horizontal, 6)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? component.color.opacity(0.15) : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    isSelected ? component.color.opacity(0.5) : Color.glassBorder,
                    lineWidth: isSelected ? 1.0 : 0.5
                )
        )
        .scaleEffect(isSelected ? 1.05 : 1.0)
    }
}

// MARK: - Component Detail View
struct ComponentDetailView: View {
    let component: ObjectComponent

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Name with color indicator
            HStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(component.color)
                    .frame(width: 4, height: 24)

                VStack(alignment: .leading, spacing: 1) {
                    Text(component.nameArabic)
                        .font(AppFont.titleSmall)
                        .foregroundStyle(.white)

                    Text(component.name)
                        .font(AppFont.caption)
                        .foregroundStyle(.white.opacity(0.4))
                }
            }

            // Material
            HStack(spacing: 8) {
                Image(systemName: "atom")
                    .font(.caption)
                    .foregroundStyle(component.color.opacity(0.7))
                    .frame(width: 18)

                VStack(alignment: .leading, spacing: 1) {
                    Text("الخامة")
                        .font(AppFont.micro)
                        .foregroundStyle(.white.opacity(0.4))
                    Text(component.materialArabic)
                        .font(AppFont.bodySecondary)
                        .foregroundStyle(.white.opacity(0.9))
                }
            }

            // Function
            HStack(spacing: 8) {
                Image(systemName: "gearshape.fill")
                    .font(.caption)
                    .foregroundStyle(component.color.opacity(0.7))
                    .frame(width: 18)

                VStack(alignment: .leading, spacing: 1) {
                    Text("الوظيفة")
                        .font(AppFont.micro)
                        .foregroundStyle(.white.opacity(0.4))
                    Text(component.functionArabic)
                        .font(AppFont.bodySecondary)
                        .foregroundStyle(.white.opacity(0.9))
                }
            }
        }
    }
}
