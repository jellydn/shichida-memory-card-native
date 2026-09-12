import SwiftUI

struct RemoteCardImage: View {
    let url: URL
    let label: String

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case let .success(image):
                image
                    .resizable()
                    .scaledToFit()
            case .failure:
                ContentUnavailableView(
                    "Image unavailable",
                    systemImage: "photo",
                    description: Text(label)
                )
            default:
                ProgressView()
            }
        }
        .accessibilityLabel(label)
    }
}
