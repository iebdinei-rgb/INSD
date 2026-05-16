import RealityKit
import UIKit

final class TrackingVisualsEntity {
    // MARK: - Create Tracking Dot
    static func createTrackingDot(
        at position: SIMD3<Float>,
        parent: Entity,
        color: UIColor = UIColor(Color.accentGlow)
    ) -> ModelEntity {
        let mesh = MeshResource.generateSphere(radius: 0.003)

        var material = UnlitMaterial()
        material.color = .init(tint: color.withAlphaComponent(0.7))

        let entity = ModelEntity(mesh: mesh, materials: [material])
        entity.position = position

        parent.addChild(entity)
        return entity
    }

    // MARK: - Create Bounding Frame
    static func createBoundingFrame(
        size: SIMD3<Float>,
        at position: SIMD3<Float>,
        parent: Entity,
        color: UIColor = UIColor(Color.accentGlow)
    ) -> [ModelEntity] {
        var edges: [ModelEntity] = []
        let halfSize = size / 2
        let edgeThickness: Float = 0.001
        let cornerLength: Float = min(size.x, size.z) * 0.2

        // Corner lines (L-shaped corners)
        let corners: [(SIMD3<Float>, Bool, Bool)] = [
            (SIMD3(-halfSize.x, 0, -halfSize.z), false, false),
            (SIMD3(halfSize.x, 0, -halfSize.z), true, false),
            (SIMD3(-halfSize.x, 0, halfSize.z), false, true),
            (SIMD3(halfSize.x, 0, halfSize.z), true, true),
        ]

        var material = UnlitMaterial()
        material.color = .init(tint: color.withAlphaComponent(0.8))

        for (corner, flipX, flipZ) in corners {
            // Horizontal edge
            let hMesh = MeshResource.generateBox(
                width: cornerLength,
                height: edgeThickness,
                depth: edgeThickness
            )
            let hEntity = ModelEntity(mesh: hMesh, materials: [material])
            let hOffset = SIMD3<Float>(
                (flipX ? -1 : 1) * cornerLength / 2,
                0,
                0
            )
            hEntity.position = position + corner + hOffset
            parent.addChild(hEntity)
            edges.append(hEntity)

            // Vertical edge
            let vMesh = MeshResource.generateBox(
                width: edgeThickness,
                height: edgeThickness,
                depth: cornerLength
            )
            let vEntity = ModelEntity(mesh: vMesh, materials: [material])
            let vOffset = SIMD3<Float>(
                0,
                0,
                (flipZ ? -1 : 1) * cornerLength / 2
            )
            vEntity.position = position + corner + vOffset
            parent.addChild(vEntity)
            edges.append(vEntity)
        }

        return edges
    }

    // MARK: - Create Scan Line
    static func createScanLine(
        width: Float,
        at position: SIMD3<Float>,
        parent: Entity,
        color: UIColor = UIColor(Color.scanBeam)
    ) -> ModelEntity {
        let mesh = MeshResource.generateBox(
            width: width,
            height: 0.0005,
            depth: 0.001
        )

        var material = UnlitMaterial()
        material.color = .init(tint: color.withAlphaComponent(0.5))

        let entity = ModelEntity(mesh: mesh, materials: [material])
        entity.position = position

        parent.addChild(entity)
        return entity
    }

    // MARK: - Animate Scan Line
    static func animateScanLine(
        entity: ModelEntity,
        from start: SIMD3<Float>,
        to end: SIMD3<Float>,
        parent: Entity,
        duration: Double
    ) {
        entity.position = start
        var transform = entity.transform
        transform.translation = end
        entity.move(
            to: transform,
            relativeTo: parent,
            duration: duration,
            timingFunction: .linear
        )
    }
}
