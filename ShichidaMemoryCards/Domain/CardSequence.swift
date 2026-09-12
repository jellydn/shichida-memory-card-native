import Foundation

struct CardSequence: Equatable {
    let count: Int
    private(set) var index = 0

    var canGoBack: Bool { index > 0 }
    var canGoForward: Bool { index + 1 < count }

    mutating func goBack() {
        guard canGoBack else { return }
        index -= 1
    }

    mutating func goForward() {
        guard canGoForward else { return }
        index += 1
    }
}
