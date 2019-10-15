# Once

Once is a slim iOS framework for executing code... well - once.
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

## Usage

### Define your own tokens by extending `Once.Token`:
```swift
extension Once.Token {
    static let myToken = Once.Token(rawValue: "...")
}
```

### Executing code only once per app lifcycle (e.g. shared instance initialization)

```swift
Once.perform(.myToken) { 
    // 
}
```

### Executing code only once every `x` seconds (e.g. optimizing frequent fetches)

```swift
Once.perform(.myToken, per: .interval(10)) { 
    //
}
```

### Executing code only once while the application is installed (e.g. initial setup)

```swift
Once.perform(.myToken, per: .launch) { 
    // 
}
```

### Executing code only once every `x` but persisted between app launches (e.g. ask for App review only once every 3 months)

```swift
Once.perform(.myToken, per: .persistentInterval(60 * 60 * 24 * 30 * 3)) { 
    // 
}
```
