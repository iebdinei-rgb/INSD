import SwiftUI
import Combine

@MainActor
final class AvatarViewModel: ObservableObject {
    // MARK: - Published State
    @Published var isVisible = false
    @Published var isSpeaking = false
    @Published var currentMessage: String = ""
    @Published var avatarMood: AvatarMood = .neutral
    @Published var breathingScale: CGFloat = 1.0
    @Published var glowIntensity: Double = 0.5

    // MARK: - Internal
    private var speechTimer: Timer?
    private var breathingTimer: Timer?
    private var messageQueue: [AvatarMessage] = []
    private var cancellables = Set<AnyCancellable>()

    enum AvatarMood {
        case neutral
        case happy
        case thinking
        case excited

        var emoji: String {
            switch self {
            case .neutral: return "🤖"
            case .happy: return "😊"
            case .thinking: return "🤔"
            case .excited: return "✨"
            }
        }

        var glowColor: Color {
            switch self {
            case .neutral: return .accentGlow
            case .happy: return Color(red: 0.3, green: 0.9, blue: 0.5)
            case .thinking: return .secondaryGlow
            case .excited: return .tertiaryGlow
            }
        }
    }

    struct AvatarMessage {
        let text: String
        let mood: AvatarMood
        let duration: TimeInterval
    }

    // MARK: - Initialization
    init() {
        startBreathingAnimation()
    }

    // MARK: - Show/Hide
    func show(withGreeting: Bool = true) {
        isVisible = true
        if withGreeting {
            speak(
                message: "أهلاً بك! وجّه الكاميرا نحو أي جسم وسأساعدك في التعرف عليه وتفكيكه.",
                mood: .happy,
                duration: 4.0
            )
        }
    }

    func hide() {
        isVisible = false
        isSpeaking = false
        currentMessage = ""
    }

    // MARK: - Speaking
    func speak(message: String, mood: AvatarMood = .neutral, duration: TimeInterval = 3.0) {
        let avatarMessage = AvatarMessage(text: message, mood: mood, duration: duration)
        messageQueue.append(avatarMessage)

        if !isSpeaking {
            processNextMessage()
        }
    }

    func speakAboutDetection(objectName: String) {
        speak(
            message: "أرى أمامك \(objectName). اضغط مطولاً لتفكيكه ومعرفة مكوناته الداخلية!",
            mood: .excited,
            duration: 4.0
        )
    }

    func speakAboutExplodedView(objectName: String, componentCount: Int) {
        speak(
            message: "تم تفكيك \(objectName) إلى \(componentCount) قطعة. اضغط على أي قطعة لمعرفة تفاصيلها!",
            mood: .happy,
            duration: 4.0
        )
    }

    // MARK: - Message Processing
    private func processNextMessage() {
        guard !messageQueue.isEmpty else {
            isSpeaking = false
            return
        }

        let message = messageQueue.removeFirst()
        currentMessage = message.text
        avatarMood = message.mood
        isSpeaking = true

        // Synthesize speech
        SpeechService.shared.speak(message.text)

        speechTimer?.invalidate()
        speechTimer = Timer.scheduledTimer(withTimeInterval: message.duration, repeats: false) { [weak self] _ in
            Task { @MainActor in
                guard let self else { return }
                self.isSpeaking = false
                self.currentMessage = ""
                self.processNextMessage()
            }
        }
    }

    // MARK: - Breathing Animation
    private func startBreathingAnimation() {
        breathingTimer = Timer.scheduledTimer(
            withTimeInterval: AnimationConstants.avatarBreathingDuration / 2,
            repeats: true
        ) { [weak self] _ in
            Task { @MainActor in
                guard let self else { return }
                withAnimation(.easeInOut(duration: AnimationConstants.avatarBreathingDuration / 2)) {
                    self.breathingScale = self.breathingScale == 1.0 ? 1.03 : 1.0
                    self.glowIntensity = self.glowIntensity == 0.5 ? 0.8 : 0.5
                }
            }
        }
    }

    deinit {
        speechTimer?.invalidate()
        breathingTimer?.invalidate()
    }
}
