# JumpWhileLoad

![demo](https://github.com/user-attachments/assets/e7b45fdb-68da-459d-9359-77a222e3e2d7)

JumpWhileLoad is an iOS library that turns your loading screen into a playable penguin jumping game — inspired by the classic Dinosaur T-Rex game. Instead of showing a static spinner, a penguin character jumps over obstacles while the background task completes. The character and obstacles are fully customizable with your own images.

## Requirements

- iOS 14.0+

## Installation

### Swift Package Manager

Use [Swift Package Manager](https://swift.org/package-manager/) by adding the following line to `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Chaehui-Seo/JumpWhileLoad.git", from: "1.0.0")
]
```

Or add it directly in Xcode via **File > Add Package Dependencies**.

## Usage

### UIKit

**1. Import the module and present the loading screen**

```swift
import JumpWhileLoad

let loadingVC = JumpWhileLoad.Builder().build()
self.present(loadingVC, animated: true)
```

**2. Dismiss when your background task completes**

```swift
// Can be called from any thread
JumpWhileLoad.finishLoading()
```

> Calling `finishLoading()` does not immediately dismiss the overlay — it shows a "Loading Finished!" banner and lets the user close it manually, so they can finish the current run.

---

### SwiftUI

**Present modally**

```swift
import JumpWhileLoad

JumpWhileLoadSwiftUI.present()

// Can be called from any thread
JumpWhileLoadSwiftUI.finishLoading()
```

> Calling `finishLoading()` does not immediately dismiss the overlay — it shows a "Loading Finished!" banner and lets the user close it manually, so they can finish the current run.

**Embed as a full-screen view**

Use `fullScreenView()` when you want to embed the game directly into your SwiftUI view hierarchy — for example, as the entire content of a screen — rather than presenting it as a modal overlay.

```swift
var body: some View {
    JumpWhileLoadSwiftUI.fullScreenView()
}
```

Call `finishLoading()` when your background task completes, just like with `present()`.

```swift
// Can be called from any thread
JumpWhileLoadSwiftUI.finishLoading()
```

---

### Custom Images

You can replace the default character and obstacles with your own images using the builder. Both UIKit and SwiftUI use the same `Builder` API.

**UIKit**

```swift
let loadingVC = JumpWhileLoad.Builder()
    .withCharacter(UIImage(named: "my_character")!)
    .withJumpCharacter(UIImage(named: "my_jump_character")!)
    .withNormalObstacles([UIImage(named: "obstacle_1")!, UIImage(named: "obstacle_2")!])
    .withWideObstacles([UIImage(named: "wide_obstacle_1")!, UIImage(named: "wide_obstacle_2")!])
    .build()
self.present(loadingVC, animated: true)
```

**SwiftUI**

```swift
JumpWhileLoadSwiftUI.present(
    JumpWhileLoad.Builder()
        .withCharacter(UIImage(named: "my_character")!)
        .withJumpCharacter(UIImage(named: "my_jump_character")!)
        .withNormalObstacles([UIImage(named: "obstacle_1")!, UIImage(named: "obstacle_2")!])
        .withWideObstacles([UIImage(named: "wide_obstacle_1")!, UIImage(named: "wide_obstacle_2")!])
)
```

| Parameter | Description | Recommended size |
|---|---|---|
| `withCharacter` | Idle character image | 50×50 pt |
| `withJumpCharacter` | Character image while jumping | 50×50 pt |
| `withNormalObstacles` | One or more normal obstacle images (chosen randomly) | 40×40 pt |
| `withWideObstacles` | One or more wide obstacle images (chosen randomly) | 70×70 pt |
<img width="400" height="600" alt="Group 15" src="https://github.com/user-attachments/assets/4cc88f12-54bd-4f30-8463-91028f2b72db" />

All parameters are optional. Any omitted parameter falls back to the built-in default asset.


## SampleApp

You can run the SampleApp projects located in `SampleApp-UIKit` and `SampleApp-SwiftUI` folders. Both the default and custom-image flows are demonstrated.

## Caution

- `finishLoading()` is safe to call from a background thread — it automatically dispatches to the main thread.
- The overlay is presented with `modalPresentationStyle = .overCurrentContext`, so the view behind it remains visible.
- Double-jump is supported: tap again while already in the air to jump higher.
