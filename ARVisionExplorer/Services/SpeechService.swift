import AVFoundation

final class SpeechService: NSObject {
    static let shared = SpeechService()

    private let synthesizer = AVSpeechSynthesizer()
    private var currentUtterance: AVSpeechUtterance?

    override private init() {
        super.init()
        synthesizer.delegate = self
        configureAudioSession()
    }

    // MARK: - Audio Session
    private func configureAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try audioSession.setActive(true)
        } catch {
            // Audio session configuration failed
        }
    }

    // MARK: - Speech
    func speak(_ text: String, language: String = "ar-SA") {
        stop()

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 0.9
        utterance.pitchMultiplier = 1.1
        utterance.volume = 0.8
        utterance.preUtteranceDelay = 0.1
        utterance.postUtteranceDelay = 0.2

        currentUtterance = utterance
        synthesizer.speak(utterance)
    }

    func stop() {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
    }

    var isSpeaking: Bool {
        synthesizer.isSpeaking
    }
}

// MARK: - AVSpeechSynthesizerDelegate
extension SpeechService: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer,
        didFinish utterance: AVSpeechUtterance
    ) {
        currentUtterance = nil
    }

    func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer,
        didCancel utterance: AVSpeechUtterance
    ) {
        currentUtterance = nil
    }
}
