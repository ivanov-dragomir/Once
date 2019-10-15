# Once

A small iOS library to manage one-off operations.
Once uses UserDefaults.standard to persist tokens between app launches. (see [Usage](#usage))

- [Features](#features)
- [Requirements](#requirements)
- [Usage](#usage)
- [License](#license)

## Features

- [x] Execute code only once per app lifecycle
- [x] Execute code only once per interval
- [x] Execute code only once while the app installed
- [x] Execute code only once per interval even between app restarts

## Requirements

- iOS 10.0+
- Xcode 11.0+
- Swift 5.1+

## Installation

Update your Package.swift to include this to your package dependencies:

```
.package(url: "https://github.com/ivanov-dragomir/Once.git")
```

## Usage

Define your own tokens by extending `Once.Token`:
```swift
extension Once.Token {
    static let myToken = Once.Token(rawValue: "...")
}
```

Executing code only once per app lifecycle (e.g. shared instance initialization)

```swift
Once.perform(.myToken) { 
    // 
}
```

Executing code only once every `x` seconds. Your app should only phone home to update content once every hour.

```swift
Once.perform(.myToken, per: .interval(60 * 60)) { 
    //
}
```

Executing code only once while the application is installed. Users should only get the guided tour once.

```swift
Once.perform(.tour, per: .launch) { 
    // 
}
```

Executing code only once every `x` seconds, persisted between app launches. You should ask for App reviews only once every 3 months.

```swift
Once.perform(.myToken, per: .persistentInterval(60 * 60 * 24 * 30 * 3)) { 
    // 
}
```

## License

Once is released under the MIT license. [See LICENSE](https://github.com/ivanov-dragomir/Once/blob/master/LICENSE) for details.
