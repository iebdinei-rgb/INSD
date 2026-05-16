import SwiftUI
import RealityKit
import ARKit
import Combine

@MainActor
final class ARViewModel: ObservableObject {
    // MARK: - Published State
    @Published var isScanning = true
    @Published var currentDetectedObject: DetectedObject?
    @Published var isExplodedViewActive = false
    @Published var explodedComponents: [ObjectComponent] = []
    @Published var trackingPoints: [TrackingPoint] = []
    @Published var arView: ARView?

    // MARK: - Internal State
    private var objectDetectionVM = ObjectDetectionViewModel()
    private var cancellables = Set<AnyCancellable>()
    private var explodedEntities: [ModelEntity] = []
    private var labelEntities: [ModelEntity] = []
    private var scanTimer: Timer?

    struct TrackingPoint: Identifiable {
        let id = UUID()
        var position: CGPoint
        var opacity: Double
        var scale: CGFloat
    }

    // MARK: - Initialization
    init() {
        setupBindings()
        startScanningSimulation()
    }

    // MARK: - AR Session Setup
    func setupARView(_ arView: ARView) {
        self.arView = arView

        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic

        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }

        if type(of: config).supportsFrameSemantics(.personSegmentationWithDepth) {
            config.frameSemantics.insert(.personSegmentationWithDepth)
        }

        arView.session.run(config)
        arView.environment.sceneUnderstanding.options = [.occlusion, .physics]
    }

    // MARK: - Object Detection
    func processFrame(_ frame: ARFrame) {
        objectDetectionVM.detectObjects(in: frame) { [weak self] detectedObject in
            Task { @MainActor in
                guard let self else { return }
                if let obj = detectedObject {
                    self.currentDetectedObject = obj
                    self.isScanning = false
                    self.explodedComponents = ObjectComponent.componentsForCategory(obj.category)
                } else if self.currentDetectedObject != nil && !self.isExplodedViewActive {
                    // Keep showing detected object for a while
                }
            }
        }
    }

    // MARK: - Exploded View
    func activateExplodedView() {
        guard currentDetectedObject != nil, !isExplodedViewActive else { return }

        HapticEngine.shared.playExplodeHaptic()
        isExplodedViewActive = true

        guard let arView else { return }
        addExplodedEntities(to: arView)
    }

    func deactivateExplodedView() {
        isExplodedViewActive = false
        removeExplodedEntities()
        HapticEngine.shared.playImpact(style: .light)
    }

    func dismissDetectedObject() {
        currentDetectedObject = nil
        isExplodedViewActive = false
        isScanning = true
        removeExplodedEntities()
    }

    // MARK: - Exploded Entities (RealityKit)
    private func addExplodedEntities(to arView: ARView) {
        removeExplodedEntities()

        let anchor = AnchorEntity(world: currentDetectedObject?.worldPosition ?? [0, 0, -0.5])

        for (index, component) in explodedComponents.enumerated() {
            let mesh = MeshResource.generateBox(
                width: component.size.x,
                height: component.size.y,
                depth: component.size.z,
                cornerRadius: 0.002
            )

            let uiColor = UIColor(component.color)
            var material = SimpleMaterial()
            material.color = .init(tint: uiColor.withAlphaComponent(0.7))
            material.metallic = .float(0.3)
            material.roughness = .float(0.4)

            let entity = ModelEntity(mesh: mesh, materials: [material])

            // Start at relative position, animate to exploded offset
            entity.position = component.relativePosition
            anchor.addChild(entity)
            explodedEntities.append(entity)

            // Animate explosion with staggered delay
            let delay = Double(index) * AnimationConstants.explodeDelay
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                var transform = entity.transform
                transform.translation = component.explodedOffset
                entity.move(
                    to: transform,
                    relativeTo: anchor,
                    duration: AnimationConstants.explodeDuration,
                    timingFunction: .easeInOut
                )
            }
        }

        arView.scene.addAnchor(anchor)
    }

    private func removeExplodedEntities() {
        for entity in explodedEntities {
            entity.anchor?.removeFromParent()
        }
        explodedEntities.removeAll()
        labelEntities.removeAll()
    }

    // MARK: - Scanning Simulation
    private func startScanningSimulation() {
        scanTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self, self.isScanning else { return }
                self.updateTrackingPoints()
            }
        }
    }

    private func updateTrackingPoints() {
        // Generate random tracking points to simulate AI scanning
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height

        // Remove old points
        trackingPoints = trackingPoints.filter { $0.opacity > 0.1 }

        // Add new points
        if trackingPoints.count < 12 {
            let newPoint = TrackingPoint(
                position: CGPoint(
                    x: CGFloat.random(in: 40...(screenWidth - 40)),
                    y: CGFloat.random(in: 100...(screenHeight - 100))
                ),
                opacity: Double.random(in: 0.3...0.8),
                scale: CGFloat.random(in: 0.5...1.2)
            )
            trackingPoints.append(newPoint)
        }

        // Fade existing points
        trackingPoints = trackingPoints.map { point in
            var updated = point
            updated.opacity = max(0, point.opacity - 0.05)
            return updated
        }
    }

    // MARK: - Demo Mode
    func triggerDemoDetection(category: ObjectCategory) {
        let product = ProductDatabase.defaultProduct(for: category)
        let detectedObject = DetectedObject(
            id: UUID(),
            name: product.nameArabic,
            nameArabic: product.nameArabic,
            manufacturer: product.manufacturer,
            category: product.category,
            releaseYear: product.releaseYear,
            confidence: 0.95,
            boundingBox: CGRect(x: 0.2, y: 0.3, width: 0.6, height: 0.4),
            worldPosition: [0, 0, -0.5]
        )
        currentDetectedObject = detectedObject
        explodedComponents = ObjectComponent.componentsForCategory(category)
        isScanning = false
    }

    // MARK: - Bindings
    private func setupBindings() {
        $currentDetectedObject
            .compactMap { $0 }
            .sink { [weak self] _ in
                self?.isScanning = false
            }
            .store(in: &cancellables)
    }

    deinit {
        scanTimer?.invalidate()
    }
}
