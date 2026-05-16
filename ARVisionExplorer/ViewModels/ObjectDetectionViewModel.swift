import Foundation
import Vision
import ARKit
import CoreML
import UIKit

final class ObjectDetectionViewModel {
    // MARK: - Properties
    private var classificationRequest: VNCoreMLRequest?
    private var objectDetectionRequest: VNDetectRectanglesRequest?
    private var lastProcessedTime: TimeInterval = 0
    private let processingInterval: TimeInterval = 0.5

    // MARK: - Initialization
    init() {
        setupVisionRequests()
    }

    // MARK: - Vision Setup
    private func setupVisionRequests() {
        // Try to load a custom Core ML model if bundled
        if let modelURL = Bundle.main.url(forResource: "ObjectClassifier", withExtension: "mlmodelc"),
           let coreModel = try? MLModel(contentsOf: modelURL),
           let vnModel = try? VNCoreMLModel(for: coreModel) {
            classificationRequest = VNCoreMLRequest(model: vnModel)
            classificationRequest?.imageCropAndScaleOption = .centerCrop
        }

        // Rectangle detection for identifying device screens/shapes
        objectDetectionRequest = VNDetectRectanglesRequest()
        objectDetectionRequest?.minimumSize = 0.1
        objectDetectionRequest?.maximumObservations = 5
        objectDetectionRequest?.minimumConfidence = 0.6
    }

    // MARK: - Object Detection
    func detectObjects(in frame: ARFrame, completion: @escaping (DetectedObject?) -> Void) {
        let currentTime = frame.timestamp
        guard currentTime - lastProcessedTime >= processingInterval else {
            return
        }
        lastProcessedTime = currentTime

        let pixelBuffer = frame.capturedImage

        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.performClassification(on: pixelBuffer, frame: frame, completion: completion)
        }
    }

    private func performClassification(
        on pixelBuffer: CVPixelBuffer,
        frame: ARFrame,
        completion: @escaping (DetectedObject?) -> Void
    ) {
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .right)

        if let coreMLRequest = classificationRequest {
            performCoreMLClassification(
                handler: handler,
                request: coreMLRequest,
                frame: frame,
                completion: completion
            )
        } else {
            performBuiltInClassification(
                handler: handler,
                frame: frame,
                completion: completion
            )
        }
    }

    // MARK: - Core ML Classification
    private func performCoreMLClassification(
        handler: VNImageRequestHandler,
        request: VNCoreMLRequest,
        frame: ARFrame,
        completion: @escaping (DetectedObject?) -> Void
    ) {
        do {
            try handler.perform([request])

            guard let results = request.results as? [VNClassificationObservation] else {
                performBuiltInClassification(handler: handler, frame: frame, completion: completion)
                return
            }

            let topResults = results
                .filter { $0.confidence > 0.3 }
                .prefix(5)

            let labels = topResults.map { $0.identifier }

            if let product = ProductDatabase.findProduct(forLabels: labels) {
                let worldPosition = estimateWorldPosition(from: frame)
                let detectedObject = DetectedObject(
                    id: UUID(),
                    name: product.name,
                    nameArabic: product.nameArabic,
                    manufacturer: product.manufacturer,
                    category: product.category,
                    releaseYear: product.releaseYear,
                    confidence: results.first?.confidence ?? 0,
                    boundingBox: CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6),
                    worldPosition: worldPosition
                )
                completion(detectedObject)
            } else {
                completion(nil)
            }
        } catch {
            performBuiltInClassification(handler: handler, frame: frame, completion: completion)
        }
    }

    // MARK: - Built-in Vision Classification
    private func performBuiltInClassification(
        handler: VNImageRequestHandler,
        frame: ARFrame,
        completion: @escaping (DetectedObject?) -> Void
    ) {
        let classifyRequest = VNClassifyImageRequest()

        do {
            try handler.perform([classifyRequest])

            guard let results = classifyRequest.results else {
                completion(nil)
                return
            }

            let topResults = results
                .filter { $0.confidence > 0.3 }
                .prefix(5)

            let labels = topResults.map { $0.identifier }

            if let product = ProductDatabase.findProduct(forLabels: labels) {
                let worldPosition = estimateWorldPosition(from: frame)
                let detectedObject = DetectedObject(
                    id: UUID(),
                    name: product.name,
                    nameArabic: product.nameArabic,
                    manufacturer: product.manufacturer,
                    category: product.category,
                    releaseYear: product.releaseYear,
                    confidence: topResults.first?.confidence ?? 0,
                    boundingBox: CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6),
                    worldPosition: worldPosition
                )
                completion(detectedObject)
            } else {
                completion(nil)
            }
        } catch {
            completion(nil)
        }
    }

    // MARK: - World Position Estimation
    private func estimateWorldPosition(from frame: ARFrame) -> SIMD3<Float> {
        let cameraTransform = frame.camera.transform
        let forwardDirection = SIMD3<Float>(
            -cameraTransform.columns.2.x,
            -cameraTransform.columns.2.y,
            -cameraTransform.columns.2.z
        )
        let cameraPosition = SIMD3<Float>(
            cameraTransform.columns.3.x,
            cameraTransform.columns.3.y,
            cameraTransform.columns.3.z
        )

        return cameraPosition + forwardDirection * 0.5
    }
}
