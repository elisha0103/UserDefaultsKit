# UserDefaultsKit

Swift Macro를 사용한 타입 안전한 UserDefaults 래퍼

## 특징

- 🎯 프로퍼티 이름이 자동으로 UserDefaults key가 됨
- 🔒 타입 안전성 보장
- 🔄 SwiftUI ObservableObject 자동 지원
- ⚡️ 초기값 자동 설정

## 설치

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/elisha0103/UserDefaultsKit.git", from: "1.0.0")
]
```

## 사용법

```swift
import UserDefaultsKit

@MainActor
@UserDefaultsContainer
final class AppDefaults: ObservableObject {
    static let shared = AppDefaults()
    
    private init() {
        initializeDefaults()
    }
    
    @AutoKeyUserDefault var userName: String = ""
    @AutoKeyUserDefault var userAge: Int = 18
    @AutoKeyUserDefault var isLoggedIn: Bool = false

    func binding<T>(_ keyPath: ReferenceWritableKeyPath<AppDefaults, T>) -> Binding<T> {
        Binding(
            get: { self[keyPath: keyPath] },
            set: { newValue in
                self.objectWillChange.send()
                self[keyPath: keyPath] = newValue
            }
        )
    }
}

// SwiftUI
struct ContentView: View {
    @ObservedObject var defaults = AppDefaults.shared
    
    var body: some View {
        TextField("Name", text: defaults.binding(\.userName))
    }
}
```

## 요구사항

- iOS 13.0+ / macOS 10.15+
- Swift 5.9+
- Xcode 15.0+

## 라이선스

MIT
