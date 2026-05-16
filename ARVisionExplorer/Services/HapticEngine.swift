import UIKit
import CoreHaptics

final class HapticEngine {
    static let shared = HapticEngine()

    private var engine: CHHapticEngine?
    private let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    private let selectionFeedback = UISelectionFeedbackGenerator()
    private let notificationFeedback = UINotificationFeedbackGenerator()

    private init() {
        prepareHaptics()
    }

    // MARK: - Setup
    private func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            engine = try CHHapticEngine()
            try engine?.start()

            engine?.stoppedHandler = { [weak self] reason in
                try? self?.engine?.start()
            }

            engine?.resetHandler = { [weak self] in
                try? self?.engine?.start()
            }
        } catch {
            // Haptics not available on this device
        }
    }

    // MARK: - Simple Haptics
    func playImpact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }

    func playSelection() {
        selectionFeedback.prepare()
        selectionFeedback.selectionChanged()
    }

    func playNotification(type: UINotificationFeedbackGenerator.FeedbackType) {
        notificationFeedback.prepare()
        notificationFeedback.notificationOccurred(type)
    }

    // MARK: - Custom Haptic Patterns
    func playExplodeHaptic() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics,
              let engine else {
            playImpact(style: .heavy)
            return
        }

        do {
            var events: [CHHapticEvent] = []

            // Initial strong impact
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.8)
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
            let initialImpact = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [sharpness, intensity],
                relativeTime: 0
            )
            events.append(initialImpact)

            // Cascade of lighter impacts (simulating parts separating)
            for i in 1...6 {
                let delay = Double(i) * 0.08
                let fadeIntensity = CHHapticEventParameter(
                    parameterID: .hapticIntensity,
                    value: Float(1.0 - Double(i) * 0.12)
                )
                let fadeSharpness = CHHapticEventParameter(
                    parameterID: .hapticSharpness,
                    value: Float(0.8 - Double(i) * 0.1)
                )
                let event = CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [fadeIntensity, fadeSharpness],
                    relativeTime: delay
                )
                events.append(event)
            }

            // Continuous subtle vibration during expansion
            let continuousIntensity = CHHapticEventParameter(
                parameterID: .hapticIntensity, value: 0.2
            )
            let continuousSharpness = CHHapticEventParameter(
                parameterID: .hapticSharpness, value: 0.3
            )
            let continuous = CHHapticEvent(
                eventType: .hapticContinuous,
                parameters: [continuousIntensity, continuousSharpness],
                relativeTime: 0.5,
                duration: 0.4
            )
            events.append(continuous)

            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            playImpact(style: .heavy)
        }
    }

    func playScanDetectedHaptic() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics,
              let engine else {
            playNotification(type: .success)
            return
        }

        do {
            var events: [CHHapticEvent] = []

            // Two quick taps (detection confirmed)
            for i in 0..<2 {
                let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.7)
                let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.9)
                let event = CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [intensity, sharpness],
                    relativeTime: Double(i) * 0.12
                )
                events.append(event)
            }

            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            playNotification(type: .success)
        }
    }

    func playLongPressBeginHaptic() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics,
              let engine else {
            playImpact(style: .light)
            return
        }

        do {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.4)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
            let event = CHHapticEvent(
                eventType: .hapticContinuous,
                parameters: [intensity, sharpness],
                relativeTime: 0,
                duration: 0.3
            )

            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            playImpact(style: .light)
        }
    }
}
