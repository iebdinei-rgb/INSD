import RealityKit
import UIKit

final class ExplodedViewEntity {
    // MARK: - Create Component Entity
    static func createComponentEntity(
        for component: ObjectComponent,
        parent: Entity
    ) -> ModelEntity {
        let mesh = MeshResource.generateBox(
            width: component.size.x,
            height: component.size.y,
            depth: component.size.z,
            cornerRadius: 0.002
        )

        let uiColor = UIColor(component.color)
        var material = SimpleMaterial()
        material.color = .init(tint: uiColor.withAlphaComponent(0.75))
        material.metallic = .float(0.4)
        material.roughness = .float(0.3)

        let entity = ModelEntity(mesh: mesh, materials: [material])
        entity.position = component.relativePosition
        entity.name = component.name

        // Add collision for tap detection
        entity.generateCollisionShapes(recursive: false)

        parent.addChild(entity)
        return entity
    }

    // MARK: - Animate Explosion
    static func animateExplosion(
        entity: ModelEntity,
        to offset: SIMD3<Float>,
        parent: Entity,
        delay: Double
    ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            var transform = entity.transform
            transform.translation = offset
            entity.move(
                to: transform,
                relativeTo: parent,
                duration: AnimationConstants.explodeDuration,
                timingFunction: .easeInOut
            )
        }
    }

    // MARK: - Animate Collapse (Reverse)
    static func animateCollapse(
        entity: ModelEntity,
        to originalPosition: SIMD3<Float>,
        parent: Entity,
        delay: Double
    ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            var transform = entity.transform
            transform.translation = originalPosition
            entity.move(
                to: transform,
                relativeTo: parent,
                duration: AnimationConstants.explodeDuration * 0.8,
                timingFunction: .easeInOut
            )
        }
    }

    // MARK: - Create Label Entity
    static func createLabelEntity(
        text: String,
        position: SIMD3<Float>,
        color: UIColor
    ) -> ModelEntity {
        let mesh = MeshResource.generateText(
            text,
            extrusionDepth: 0.001,
            font: .systemFont(ofSize: 0.008, weight: .medium),
            containerFrame: .zero,
            alignment: .center,
            lineBreakMode: .byWordWrapping
        )

        var material = UnlitMaterial()
        material.color = .init(tint: color)

        let entity = ModelEntity(mesh: mesh, materials: [material])
        entity.position = position + SIMD3<Float>(0.05, 0, 0)

        return entity
    }

    // MARK: - Create Connection Line
    static func createConnectionLine(
        from start: SIMD3<Float>,
        to end: SIMD3<Float>,
        color: UIColor
    ) -> ModelEntity {
        let direction = end - start
        let length = simd_length(direction)

        let mesh = MeshResource.generateBox(
            width: 0.001,
            height: 0.001,
            depth: length,
            cornerRadius: 0.0005
        )

        var material = UnlitMaterial()
        material.color = .init(tint: color.withAlphaComponent(0.6))

        let entity = ModelEntity(mesh: mesh, materials: [material])

        let midpoint = (start + end) / 2
        entity.position = midpoint

        if length > 0 {
            let normalized = direction / length
            entity.look(at: end, from: midpoint, relativeTo: nil)
        }

        return entity
    }
}
