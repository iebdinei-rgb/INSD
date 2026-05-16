import SwiftUI

struct ComponentLabel: View {
    let component: ObjectComponent
    let isHighlighted: Bool
    @State private var lineLength: CGFloat = 0

    var body: some View {
        HStack(spacing: 0) {
            // Connection line
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            component.color.opacity(0.6),
                            component.color.opacity(0.2)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: lineLength, height: 1)
                .animation(.easeOut(duration: 0.4), value: lineLength)

            // Label card
            HStack(spacing: 6) {
                Circle()
                    .fill(component.color)
                    .frame(width: 6, height: 6)

                VStack(alignment: .leading, spacing: 1) {
                    Text(component.nameArabic)
                        .font(AppFont.micro)
                        .foregroundStyle(.white.opacity(0.9))
                        .lineLimit(1)

                    Text(component.materialArabic)
                        .font(.system(size: 8, weight: .regular))
                        .foregroundStyle(.white.opacity(0.4))
                        .lineLimit(1)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .glassBackground(cornerRadius: 8, opacity: 0.9, borderOpacity: 0.1)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        component.color.opacity(isHighlighted ? 0.6 : 0.0),
                        lineWidth: 0.5
                    )
            )
            .scaleEffect(isHighlighted ? 1.05 : 1.0)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5).delay(0.2)) {
                lineLength = 30
            }
        }
    }
}

// MARK: - Exploded Component 3D Label
struct ExplodedComponentOverlay: View {
    let components: [ObjectComponent]
    let selectedIndex: Int?
    let geometry: GeometryProxy

    var body: some View {
        ForEach(Array(components.enumerated()), id: \.element.id) { index, component in
            let yPosition = calculateYPosition(
                for: index,
                total: components.count,
                in: geometry.size
            )

            ComponentLabel(
                component: component,
                isHighlighted: selectedIndex == index
            )
            .position(
                x: geometry.size.width * 0.7,
                y: yPosition
            )
            .opacity(selectedIndex == nil || selectedIndex == index ? 1.0 : 0.4)
            .animation(AnimationConstants.snappySpring, value: selectedIndex)
        }
    }

    private func calculateYPosition(
        for index: Int,
        total: Int,
        in size: CGSize
    ) -> CGFloat {
        let startY = size.height * 0.2
        let endY = size.height * 0.7
        let spacing = (endY - startY) / CGFloat(max(total - 1, 1))
        return startY + CGFloat(index) * spacing
    }
}
