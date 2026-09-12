# Shichida Memory Cards

A native SwiftUI application for iPhone, iPad, and Mac. It is based on the five desks and learning flow in [jellydn/shichida-memory-card](https://github.com/jellydn/shichida-memory-card).

## Behavior

- Select one of five desks containing 498 cards in total.
- See and hear each card, then reveal its answer after 1.4 seconds.
- Advance automatically every 2 seconds, or move with a swipe, arrow button, or keyboard arrow key.
- Stop at the final card. Opening a desk again starts at its first card.

Card images and spoken labels load from the source application's remote media hosts. The manifests, Commit Mono font, and original application icon are bundled with the app.

## Requirements

- Xcode 16 or newer
- [XcodeGen](https://github.com/yonaskolb/XcodeGen)

## Develop

```sh
brew install xcodegen
xcodegen generate
open ShichidaMemoryCards.xcodeproj
```

Select **Shichida Memory Cards iOS** or **Shichida Memory Cards macOS** in Xcode. The iOS app supports iPhone and iPad in landscape orientation.

Run the macOS unit tests from the command line:

```sh
xcodebuild test \
  -project ShichidaMemoryCards.xcodeproj \
  -scheme "Shichida Memory Cards macOS" \
  -destination "platform=macOS" \
  CODE_SIGNING_ALLOWED=NO
```
