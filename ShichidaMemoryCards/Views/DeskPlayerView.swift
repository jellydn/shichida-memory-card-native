import SwiftUI

struct DeskPlayerView: View {
    let desk: Desk

    @State private var cards: [MemoryCard] = []
    @State private var loadError: Error?

    var body: some View {
        Group {
            if let loadError {
                ContentUnavailableView(
                    "Unable to load this desk",
                    systemImage: "exclamationmark.triangle",
                    description: Text(loadError.localizedDescription)
                )
            } else if cards.isEmpty {
                ProgressView("Loading…")
            } else {
                CardPlayerView(cards: cards)
            }
        }
        .navigationTitle(desk.name)
        .task {
            do {
                cards = try DeskLoader.cards(for: desk)
            } catch {
                loadError = error
            }
        }
    }
}

private struct CardPlayerView: View {
    let cards: [MemoryCard]
    @StateObject private var player: CardPlayer
    @State private var dragOffset: CGFloat = 0

    init(cards: [MemoryCard]) {
        self.cards = cards
        _player = StateObject(wrappedValue: CardPlayer(cardCount: cards.count))
    }

    private var card: MemoryCard {
        cards[player.sequence.index]
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                cardContent
                    .id(player.sequence.index)
                    .transition(.opacity)
                    .offset(x: dragOffset)
                    .contentShape(Rectangle())
                    .gesture(dragGesture(width: proxy.size.width))

                HStack {
                    navigationButton(
                        systemName: "chevron.left",
                        label: "Previous card",
                        enabled: player.sequence.canGoBack,
                        action: previous
                    )
                    Spacer()
                    navigationButton(
                        systemName: "chevron.right",
                        label: "Next card",
                        enabled: player.sequence.canGoForward,
                        action: next
                    )
                }
                .padding()
            }
        }
        .background(Color.black.opacity(0.04))
        .navigationTitle(card.title.capitalized)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Text("\(player.sequence.index + 1) / \(cards.count)")
                    .monospacedDigit()
                    .accessibilityLabel("Card \(player.sequence.index + 1) of \(cards.count)")
            }
        }
        .task {
            player.start(with: card)
        }
        .onDisappear {
            player.stop()
        }
        .onChange(of: player.sequence.index) {
            player.start(with: card)
        }
    }

    @ViewBuilder
    private var cardContent: some View {
        if player.isAnswerVisible {
            Text(card.displayTitle)
                .font(.custom("CommitMono-Regular", size: 54, relativeTo: .largeTitle))
                .minimumScaleFactor(0.4)
                .multilineTextAlignment(.center)
                .padding(48)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .accessibilityAddTraits(.isHeader)
        } else {
            RemoteCardImage(url: card.imageSrc, label: card.title)
                .padding(20)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private func navigationButton(
        systemName: String,
        label: String,
        enabled: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.title2.bold())
                .frame(width: 48, height: 48)
                .background(.regularMaterial, in: Circle())
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
        .opacity(enabled ? 1 : 0)
        .accessibilityLabel(label)
        .keyboardShortcut(systemName == "chevron.left" ? .leftArrow : .rightArrow, modifiers: [])
    }

    private func dragGesture(width: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 20)
            .onChanged { dragOffset = $0.translation.width }
            .onEnded { value in
                defer { dragOffset = 0 }
                guard abs(value.translation.width) > width * 0.18 else { return }
                value.translation.width < 0 ? next() : previous()
            }
    }

    private func previous() {
        guard player.sequence.canGoBack else { return }
        player.goBack()
    }

    private func next() {
        guard player.sequence.canGoForward else { return }
        player.goForward()
    }
}
