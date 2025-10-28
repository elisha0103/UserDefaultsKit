//
//  main.swift
//  UserDefaultsKit
//
//  Created by 진태영 on 10/28/25.
//

import UserDefaultsKit
import SwiftUI

@MainActor
@UserDefaultsContainer
final class AppDefaults: ObservableObject {
    static let shared = AppDefaults()
    
    private init() {
        initializeDefaults()
    }
    
    @AutoKeyUserDefault var userName: String = ""
    @AutoKeyUserDefault var userAge: Int = 10
    @AutoKeyUserDefault var isLoggedIn: Bool = true
    @AutoKeyUserDefault var loginCount: Int = 5
    
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

// 테스트
print("=== UserDefaultsKit Example ===")
let defaults = AppDefaults.shared
print("Initial userName: \(defaults.userName)")
print("Initial isLoggedIn: \(defaults.isLoggedIn)")

defaults.userName = "John Doe"
defaults.loginCount = 100

print("Updated userName: \(defaults.userName)")
print("Updated loginCount: \(defaults.loginCount)")
