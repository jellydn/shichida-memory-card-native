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
        cancelScheduledTasks()
        audioPlayer?.pause()
    }

    func start(with card: MemoryCard) {
        scheduleCurrentCard(card)
    }

    func goBack() {
        cancelScheduledTasks()
        sequence.goBack()
    }

    func goForward() {
        cancelScheduledTasks()
        sequence.goForward()
    }

    private func scheduleCurrentCard(_ card: MemoryCard) {
        cancelScheduledTasks()
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

    private func cancelScheduledTasks() {
        revealTask?.cancel()
        advanceTask?.cancel()
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
