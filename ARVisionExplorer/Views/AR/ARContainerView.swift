import SwiftUI
import RealityKit
import ARKit

struct ARContainerView: UIViewRepresentable {
    @EnvironmentObject var arViewModel: ARViewModel

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        arView.automaticallyConfigureSession = false

        // Configure rendering
        arView.renderOptions = [
            .disablePersonOcclusion,
            .disableMotionBlur
        ]
        arView.environment.background = .cameraFeed()

        // Set up coaching overlay
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.session = arView.session
        coachingOverlay.goal = .anyPlane
        arView.addSubview(coachingOverlay)

        // Setup AR session
        arViewModel.setupARView(arView)

        // Set delegate
        arView.session.delegate = context.coordinator

        // Add gesture recognizers
        let longPress = UILongPressGestureRecognizer(
            target: context.coordinator,
            action: #selector(ARCoordinator.handleLongPress(_:))
        )
        longPress.minimumPressDuration = 0.6
        arView.addGestureRecognizer(longPress)

        let tap = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(ARCoordinator.handleTap(_:))
        )
        arView.addGestureRecognizer(tap)

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}

    func makeCoordinator() -> ARCoordinator {
        ARCoordinator(arViewModel: arViewModel)
    }
}

// MARK: - AR Session Coordinator
class ARCoordinator: NSObject, ARSessionDelegate {
    let arViewModel: ARViewModel
    private var frameCounter = 0
    private let processEveryNthFrame = 15

    init(arViewModel: ARViewModel) {
        self.arViewModel = arViewModel
    }

    // MARK: - ARSessionDelegate
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        frameCounter += 1
        guard frameCounter % processEveryNthFrame == 0 else { return }

        Task { @MainActor in
            arViewModel.processFrame(frame)
        }
    }

    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            if anchor is ARPlaneAnchor {
                // Plane detected - environment is being mapped
            }
        }
    }

    // MARK: - Gesture Handlers
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            HapticEngine.shared.playLongPressBeginHaptic()
        case .ended:
            Task { @MainActor in
                if arViewModel.isExplodedViewActive {
                    arViewModel.deactivateExplodedView()
                } else {
                    arViewModel.activateExplodedView()
                }
            }
        default:
            break
        }
    }

    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        Task { @MainActor in
            if arViewModel.isExplodedViewActive {
                arViewModel.deactivateExplodedView()
            } else if arViewModel.currentDetectedObject != nil {
                arViewModel.dismissDetectedObject()
            }
        }
    }
}
