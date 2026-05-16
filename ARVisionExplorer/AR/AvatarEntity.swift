import RealityKit
import UIKit

final class AvatarEntity {
    // MARK: - Create Avatar
    static func createAvatar(
        at position: SIMD3<Float>,
        parent: Entity
    ) -> ModelEntity {
        // Create a stylized avatar representation
        // In production, replace with a USDZ 3D character model
        let headMesh = MeshResource.generateSphere(radius: 0.06)

        var headMaterial = SimpleMaterial()
        headMaterial.color = .init(tint: UIColor(Color.accentGlow).withAlphaComponent(0.3))
        headMaterial.metallic = .float(0.8)
        headMaterial.roughness = .float(0.2)

        let head = ModelEntity(mesh: headMesh, materials: [headMaterial])
        head.position = position
        head.name = "avatar_head"

        // Inner glow core
        let coreMesh = MeshResource.generateSphere(radius: 0.04)
        var coreMaterial = UnlitMaterial()
        coreMaterial.color = .init(tint: UIColor(Color.accentGlow).withAlphaComponent(0.6))
        let core = ModelEntity(mesh: coreMesh, materials: [coreMaterial])
        core.name = "avatar_core"
        head.addChild(core)

        // Orbital ring
        let ringMesh = MeshResource.generateBox(
            width: 0.12,
            height: 0.001,
            depth: 0.12,
            cornerRadius: 0.06
        )
        var ringMaterial = UnlitMaterial()
        ringMaterial.color = .init(tint: UIColor(Color.accentGlow).withAlphaComponent(0.4))
        let ring = ModelEntity(mesh: ringMesh, materials: [ringMaterial])
        ring.position = SIMD3(0, -0.02, 0)
        ring.name = "avatar_ring"
        head.addChild(ring)

        parent.addChild(head)
        return head
    }

    // MARK: - Animate Speaking
    static func animateSpeaking(entity: ModelEntity, isSpeaking: Bool) {
        guard let core = entity.children.first(where: { $0.name == "avatar_core" }) else {
            return
        }

        if isSpeaking {
            var transform = core.transform
            transform.scale = SIMD3<Float>(repeating: 1.15)
            core.move(
                to: transform,
                relativeTo: entity,
                duration: AnimationConstants.avatarSpeakingPulseDuration,
                timingFunction: .easeInOut
            )
        } else {
            var transform = core.transform
            transform.scale = SIMD3<Float>(repeating: 1.0)
            core.move(
                to: transform,
                relativeTo: entity,
                duration: AnimationConstants.avatarSpeakingPulseDuration,
                timingFunction: .easeInOut
            )
        }
    }

    // MARK: - Animate Look At
    static func animateLookAt(
        entity: ModelEntity,
        target: SIMD3<Float>,
        duration: Double = 0.5
    ) {
        var transform = entity.transform
        let direction = target - entity.position
        if simd_length(direction) > 0.01 {
            entity.look(at: target, from: entity.position, relativeTo: nil)
        }
    }

    // MARK: - Glow Effect
    static func updateGlow(entity: ModelEntity, intensity: Float) {
        guard let core = entity.children.first(where: { $0.name == "avatar_core" }) as? ModelEntity else {
            return
        }

        var material = UnlitMaterial()
        material.color = .init(
            tint: UIColor(Color.accentGlow).withAlphaComponent(CGFloat(intensity))
        )
        core.model?.materials = [material]
    }
}
