# UserDefaultsKit

Swift Macro를 사용한 타입 안전한 UserDefaults 래퍼

## 특징

- 🎯 프로퍼티 이름이 자동으로 UserDefaults key가 됨
- 🔑 커스텀 key 지정 가능
- 🔒 타입 안전성 보장
- 🔄 SwiftUI ObservableObject 자동 지원
- ⚡️ 초기값 자동 설정
- 🧪 Bool, URL, Date 타입 특별 처리
- 📦 Codable 객체 저장 지원

## 설치

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/elisha0103/UserDefaultsKit.git", from: "1.1.0")
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
    
    // 자동 키: 프로퍼티명이 key가 됨
    @AutoKeyUserDefault var userName: String = ""
    @AutoKeyUserDefault var userAge: Int = 18
    @AutoKeyUserDefault var isLoggedIn: Bool = false
    
    // 커스텀 키 지정
    @AutoKeyUserDefault(key: "user_email") var email: String = ""
    @AutoKeyUserDefault(key: "app.theme") var theme: String = "light"
    
    // URL 타입 (자동으로 String 변환)
    @AutoKeyUserDefault var homepage: URL = URL(string: "https://example.com")!
}
```

## SwiftUI에서 사용

```swift
import SwiftUI

struct ContentView: View {
    @ObservedObject var defaults = AppDefaults.shared
    
    var body: some View {
        Form {
            TextField("Name", text: defaults.binding(\.userName))
            
            Stepper("Age: \(defaults.userAge)", 
                    value: defaults.binding(\.userAge))
            
            Toggle("Logged In", isOn: defaults.binding(\.isLoggedIn))
        }
    }
}
```

## UIKit에서 사용

```swift
import Combine

class ViewController: UIViewController {
    private let defaults = AppDefaults.shared
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 값 읽기
        print(defaults.userName)
        
        // 값 쓰기
        defaults.userName = "John"
        
        // 변경 감지
        defaults.objectWillChange
            .sink { [weak self] _ in
                self?.updateUI()
            }
            .store(in: &cancellables)
    }
}
```

## Codable 객체 저장

```swift
struct User: Codable {
    let name: String
    let age: Int
}

let user = User(name: "John", age: 30)

// 저장
try? UserDefaults.standard.setCodable(user, forKey: "currentUser")

// 읽기
let retrieved: User? = try? UserDefaults.standard.getCodable(forKey: "currentUser")

// 안전한 읽기 (에러 무시)
let safe: User? = UserDefaults.standard.codable(forKey: "currentUser")
```

## 지원 타입

- ✅ String, Int, Double, Float, Bool
- ✅ URL (자동 String 변환)
- ✅ Date
- ✅ Data
- ✅ Array, Dictionary (Property List 타입)
- ✅ Codable 객체 (Extension 사용)

## 요구사항

- iOS 13.0+ / macOS 10.15+ / tvOS 13.0+ / watchOS 6.0+
- Swift 5.9+
- Xcode 15.0+

## 라이선스

MIT License

Copyright (c) 2024

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/
