import Foundation
import simd

struct DetectedObject: Identifiable, Equatable {
    let id: UUID
    let name: String
    let nameArabic: String
    let manufacturer: String
    let category: ObjectCategory
    let releaseYear: String
    let confidence: Float
    let boundingBox: CGRect
    var worldPosition: SIMD3<Float>

    static func == (lhs: DetectedObject, rhs: DetectedObject) -> Bool {
        lhs.id == rhs.id
    }
}

enum ObjectCategory: String, CaseIterable {
    case smartphone = "smartphone"
    case watch = "watch"
    case laptop = "laptop"
    case camera = "camera"
    case headphones = "headphones"
    case tablet = "tablet"
    case engine = "engine"
    case generic = "generic"

    var icon: String {
        switch self {
        case .smartphone: return "iphone"
        case .watch: return "applewatch"
        case .laptop: return "laptopcomputer"
        case .camera: return "camera.fill"
        case .headphones: return "headphones"
        case .tablet: return "ipad"
        case .engine: return "engine.combustion.fill"
        case .generic: return "cube.fill"
        }
    }

    var nameArabic: String {
        switch self {
        case .smartphone: return "هاتف ذكي"
        case .watch: return "ساعة ذكية"
        case .laptop: return "حاسوب محمول"
        case .camera: return "كاميرا"
        case .headphones: return "سماعات"
        case .tablet: return "جهاز لوحي"
        case .engine: return "محرك"
        case .generic: return "جسم"
        }
    }
}
