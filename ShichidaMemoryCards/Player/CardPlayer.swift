import AVFoundation
import Combine
import Foundation

@MainActor
final class CardPlayer: ObservableObject {
    @Published private(set) var sequence: CardSequence
    @Published private(set) var isAnswerVisible = false

    private var revealTask: Task<Void, Never>?
    private var advanceTask: Task<Void, Never>?
    private var audioPlayer: AVPlayer?

    init(cardCount: Int) {
        sequence = CardSequence(count: cardCount)
    }

    func stop() {
        revealTask?.cancel()
        advanceTask?.cancel()
        audioPlayer?.pause()
    }

    func start(with card: MemoryCard) {
        scheduleCurrentCard(card)
    }

    func goBack() {
        sequence.goBack()
    }

    func goForward() {
        sequence.goForward()
    }

    private func scheduleCurrentCard(_ card: MemoryCard) {
        revealTask?.cancel()
        advanceTask?.cancel()
        isAnswerVisible = false
        play(card.mp3)

        revealTask = Task {
            try? await Task.sleep(for: .milliseconds(1_400))
            guard !Task.isCancelled else { return }
            isAnswerVisible = true
        }

        guard sequence.canGoForward else { return }
        advanceTask = Task {
            try? await Task.sleep(for: .seconds(2))
            guard !Task.isCancelled else { return }
            sequence.goForward()
        }
    }

    private func play(_ url: URL) {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        if components?.scheme == "http" {
            components?.scheme = "https"
        }

        guard let secureURL = components?.url else { return }
        audioPlayer?.pause()
        audioPlayer = AVPlayer(url: secureURL)
        audioPlayer?.play()
    }
}
