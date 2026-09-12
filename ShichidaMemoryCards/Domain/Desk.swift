import Foundation

struct Desk: Identifiable, Hashable {
    let id: Int
    let name: String
    let resourceName: String

    static let all: [Desk] = [
        Desk(id: 1, name: "Animals", resourceName: "set-1-animals"),
        Desk(id: 2, name: "Plants & Fish", resourceName: "set-2-plants-and-fish"),
        Desk(id: 3, name: "Human", resourceName: "set-3-human"),
        Desk(id: 4, name: "Flag 1", resourceName: "set-4-flags-1"),
        Desk(id: 5, name: "Flag 2", resourceName: "set-4-flags-2"),
    ]
}

enum DeskLoader {
    static func cards(for desk: Desk, bundle: Bundle = .main) throws -> [MemoryCard] {
        guard let url = bundle.url(forResource: desk.resourceName, withExtension: "json") else {
            throw CocoaError(.fileNoSuchFile)
        }

        return try JSONDecoder().decode([MemoryCard].self, from: Data(contentsOf: url))
    }
}
