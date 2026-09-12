import Foundation

struct MemoryCard: Codable, Identifiable, Equatable {
    let imageSrc: URL
    let title: String
    let mp3: URL

    var id: URL { imageSrc }

    var displayTitle: String {
        title.prefix(1).uppercased() + title.dropFirst()
    }
}
