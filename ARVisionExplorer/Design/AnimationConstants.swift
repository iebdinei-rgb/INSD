import SwiftUI

enum AnimationConstants {
    // MARK: - Spring Animations
    static let gentleSpring = Animation.spring(response: 0.6, dampingFraction: 0.8)
    static let bouncySpring = Animation.spring(response: 0.5, dampingFraction: 0.65)
    static let snappySpring = Animation.spring(response: 0.35, dampingFraction: 0.75)
    static let heavySpring = Animation.spring(response: 0.8, dampingFraction: 0.7)

    // MARK: - Exploded View
    static let explodeDelay: Double = 0.05
    static let explodeDuration: Double = 0.8
    static let explodeSpring = Animation.spring(response: 0.7, dampingFraction: 0.65)

    // MARK: - Scanning
    static let scanPulseDuration: Double = 1.5
    static let scanLineDuration: Double = 2.0
    static let trackingPointFadeDuration: Double = 0.4

    // MARK: - Card Transitions
    static let cardAppearDuration: Double = 0.4
    static let cardDismissDuration: Double = 0.25

    // MARK: - Avatar
    static let avatarBreathingDuration: Double = 3.0
    static let avatarSpeakingPulseDuration: Double = 0.3
    static let avatarAppearDuration: Double = 0.6

    // MARK: - Glow Effects
    static let glowPulseDuration: Double = 2.0
    static let glowIntensityRange: ClosedRange<Double> = 0.3...0.8
}
