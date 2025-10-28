//
//  AutoKeyUserDefaultMacro.swift
//  UserDefaultsKit
//
//  Created by 진태영 on 10/28/25.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct AutoKeyUserDefaultMacro: AccessorMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AccessorDeclSyntax] {
        guard let varDecl = declaration.as(VariableDeclSyntax.self),
              let binding = varDecl.bindings.first,
              let identifier = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier,
              let initializer = binding.initializer?.value else {
            throw MacroError.message("@UserDefault는 초기값이 있는 변수에만 사용 가능합니다")
        }
        
        let propertyName = identifier.text
        
        return [
            """
            get {
                UserDefaults.standard.object(forKey: "\(raw: propertyName)") as? \(raw: binding.typeAnnotation?.type.description ?? "Unknown") ?? \(initializer)
            }
            """,
            """
            set {
                objectWillChange.send()
                UserDefaults.standard.set(newValue, forKey: "\(raw: propertyName)")
            }
            """
        ]
    }
}

enum MacroError: Error, CustomStringConvertible {
    case message(String)
    
    var description: String {
        switch self {
        case .message(let text):
            return text
        }
    }
}
