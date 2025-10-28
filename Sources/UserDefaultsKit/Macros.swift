//
//  Macros.swift
//  UserDefaultsKit
//
//  Created by 진태영 on 10/28/25.
//

/// 프로퍼티 이름을 자동으로 UserDefaults key로 사용하는 매크로
///
/// # 사용 예시
///
/// ```swift
/// // 프로퍼티명을 key로 자동 사용
/// @AutoKeyUserDefault var userName: String = ""
/// // → UserDefaults key: "userName"
///
/// // 커스텀 key 지정
/// @AutoKeyUserDefault(key: "user_name") var userName: String = ""
/// // → UserDefaults key: "user_name"
/// ```
///
/// # 지원 타입
/// - String, Int, Double, Float, Bool
/// - URL (자동으로 String 변환)
/// - Date, Data
/// - Array, Dictionary (Property List 타입)
///
/// # 요구사항
/// - 프로퍼티는 반드시 초기값을 가져야 함
/// - 클래스는 `ObservableObject`를 준수해야 함
@attached(accessor)
public macro AutoKeyUserDefault(key: String? = nil) = #externalMacro(
    module: "UserDefaultsKitMacros",
    type: "AutoKeyUserDefaultMacro"
)

/// 클래스에 모든 @AutoKeyUserDefault 프로퍼티를 초기화하는 메서드를 자동 생성
///
/// 이 매크로는 `initializeDefaults()` 메서드를 자동으로 생성하며,
/// 각 프로퍼티의 초기값을 UserDefaults에 저장합니다.
///
/// # 사용 예시
///
/// ```swift
/// @MainActor
/// @UserDefaultsContainer
/// final class AppDefaults: ObservableObject {
///     static let shared = AppDefaults()
///
///     private init() {
///         initializeDefaults()  // 자동 생성된 메서드
///     }
///
///     @AutoKeyUserDefault var userName: String = ""
///     @AutoKeyUserDefault var isLoggedIn: Bool = false
/// }
/// ```
@attached(member, names: named(initializeDefaults))
public macro UserDefaultsContainer() = #externalMacro(
    module: "UserDefaultsKitMacros",
    type: "UserDefaultsContainerMacro"
)
