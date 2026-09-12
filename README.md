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

## Pull request beta builds

The **Apple beta builds** GitHub Actions workflow tests every pull request and uploads two artifacts for 7 days:

- An ad-hoc signed, non-notarized macOS app. On first launch, Control-click the app and select **Open**. Gatekeeper can also require **System Settings → Privacy & Security → Open Anyway**.
- An Apple Silicon iOS Simulator app. Boot a simulator and install the unzipped app with `xcrun simctl install booted "Shichida Memory Cards iOS.app"`.

The workflow does not pass secrets to these builds. Fork pull requests receive the same secret-free artifacts but cannot access the protected signing job or its write-capable PR comment job.

### Optional signed iOS beta

Manual workflow runs from the protected `main` branch can also produce an ad hoc IPA for registered test devices. Pull request code never receives signing credentials. Create a GitHub environment named `beta`, restrict it to the protected `main` branch, and add these environment secrets:

| Secret | Value |
| --- | --- |
| `APPLE_TEAM_ID` | Apple Developer team identifier |
| `IOS_DISTRIBUTION_CERTIFICATE_BASE64` | Base64-encoded PKCS#12 Apple Distribution certificate (`.p12`) |
| `IOS_DISTRIBUTION_CERTIFICATE_PASSWORD` | Password for the PKCS#12 certificate |
| `IOS_BETA_PROVISIONING_PROFILE_BASE64` | Base64-encoded ad hoc provisioning profile for `com.dunghd.shichidamemorycards`, including each beta device |

Then add the repository Actions variable `ENABLE_SIGNED_BETA` with the value `true`. Keep it unset or set it to `false` when signing is not configured. Run **Apple beta builds** manually from `main` to create the IPA. The IPA remains a workflow artifact; this workflow does not publish a permanent GitHub Release.
