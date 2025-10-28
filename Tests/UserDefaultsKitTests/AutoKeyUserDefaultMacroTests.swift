//
//  File.swift
//  UserDefaultsKit
//
//  Created by 진태영 on 10/28/25.
//

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(UserDefaultsKitMacros)
import UserDefaultsKitMacros

final class AutoKeyUserDefaultMacroTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "AutoKeyUserDefault": AutoKeyUserDefaultMacro.self,
    ]
    
    func testStringProperty() throws {
        assertMacroExpansion(
            """
            @AutoKeyUserDefault var userName: String = ""
            """,
            expandedSource: """
            var userName: String = "" {
                get {
                    guard let value = UserDefaults.standard.object(forKey: "userName") else {
                        return ""
                    }
                    return value as? String ?? ""
                }
                set {
                    objectWillChange.send()
                    UserDefaults.standard.set(newValue, forKey: "userName")
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func testBoolProperty() throws {
        assertMacroExpansion(
            """
            @AutoKeyUserDefault var isLoggedIn: Bool = true
            """,
            expandedSource: """
            var isLoggedIn: Bool = true {
                get {
                    if UserDefaults.standard.object(forKey: "isLoggedIn") == nil {
                        return true
                    }
                    return UserDefaults.standard.bool(forKey: "isLoggedIn")
                }
                set {
                    objectWillChange.send()
                    UserDefaults.standard.set(newValue, forKey: "isLoggedIn")
                }
            }
            """,
            macros: testMacros
        )
    }
}
#endif
