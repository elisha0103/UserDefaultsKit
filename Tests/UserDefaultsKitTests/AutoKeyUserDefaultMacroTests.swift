//
//  AutoKeyUserDefaultMacroTests.swift
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
    
    func testCustomKey() throws {
        assertMacroExpansion(
            """
            @AutoKeyUserDefault(key: "user_name") var userName: String = ""
            """,
            expandedSource: """
            var userName: String = "" {
                get {
                    guard let value = UserDefaults.standard.object(forKey: "user_name") else {
                        return ""
                    }
                    return value as? String ?? ""
                }
                set {
                    objectWillChange.send()
                    UserDefaults.standard.set(newValue, forKey: "user_name")
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func testURLProperty() throws {
        assertMacroExpansion(
            """
            @AutoKeyUserDefault var homepage: URL = URL(string: "https://example.com")!
            """,
            expandedSource: """
            var homepage: URL = URL(string: "https://example.com")! {
                get {
                    guard let urlString = UserDefaults.standard.string(forKey: "homepage"),
                          let url = URL(string: urlString) else {
                        return URL(string: "https://example.com")!
                    }
                    return url
                }
                set {
                    objectWillChange.send()
                    UserDefaults.standard.set(newValue.absoluteString, forKey: "homepage")
                }
            }
            """,
            macros: testMacros
        )
    }
}
#endif
