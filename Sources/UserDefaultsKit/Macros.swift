//
//  Macros.swift
//  UserDefaultsKit
//
//  Created by 진태영 on 10/28/25.
//

/// 프로퍼티 이름을 자동으로 UserDefaults key로 사용하는 매크로
///
/// 사용 예시:
/// ```swift
/// @AutoKeyUserDefault var userName: String = ""
/// ```
@attached(accessor)
public macro AutoKeyUserDefault() = #externalMacro(
    module: "UserDefaultsKitMacros",
    type: "AutoKeyUserDefaultMacro"
)

/// 클래스에 모든 @AutoKeyUserDefault 프로퍼티를 초기화하는 메서드를 자동 생성
///
/// 사용 예시:
/// ```swift
/// @UserDefaultsContainer
/// final class AppDefaults: ObservableObject {
///     @AutoKeyUserDefault var userName: String = ""
/// }
/// ```
@attached(member, names: named(initializeDefaults))
public macro UserDefaultsContainer() = #externalMacro(
    module: "UserDefaultsKitMacros",
    type: "UserDefaultsContainerMacro"
)
