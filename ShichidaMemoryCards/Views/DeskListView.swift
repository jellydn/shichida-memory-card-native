import SwiftUI

struct DeskListView: View {
    var body: some View {
        NavigationStack {
            List(Desk.all) { desk in
                NavigationLink(value: desk) {
                    DeskRow(desk: desk)
                }
                .accessibilityLabel("Desk \(desk.id), \(desk.name)")
            }
            .navigationTitle("Shichida Flash Cards")
            .navigationDestination(for: Desk.self) { desk in
                DeskPlayerView(desk: desk)
            }
        }
    }
}

private struct DeskRow: View {
    let desk: Desk
    @State private var thumbnailURL: URL?

    var body: some View {
        HStack(spacing: 16) {
            Group {
                if let thumbnailURL {
                    RemoteCardImage(url: thumbnailURL, label: desk.name)
                } else {
                    Image(systemName: "rectangle.stack")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 96, height: 72)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 5) {
                Text("Desk #\(desk.id)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(desk.name)
                    .font(.title2.weight(.semibold))
            }
        }
        .padding(.vertical, 6)
        .task {
            thumbnailURL = try? DeskLoader.cards(for: desk).randomElement()?.imageSrc
        }
    }
}
