import SwiftUI

struct GlassCard<Content: View>: View {
    let cornerRadius: CGFloat
    let padding: CGFloat
    let glowColor: Color?
    @ViewBuilder let content: () -> Content

    init(
        cornerRadius: CGFloat = 16,
        padding: CGFloat = 16,
        glowColor: Color? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.glowColor = glowColor
        self.content = content
    }

    var body: some View {
        content()
            .padding(padding)
            .glassBackground(cornerRadius: cornerRadius)
            .if(glowColor != nil) { view in
                view.glowBorder(
                    color: glowColor!,
                    cornerRadius: cornerRadius,
                    lineWidth: 0.5
                )
            }
    }
}

// MARK: - Conditional Modifier
extension View {
    @ViewBuilder
    func `if`<Transform: View>(
        _ condition: Bool,
        transform: (Self) -> Transform
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
