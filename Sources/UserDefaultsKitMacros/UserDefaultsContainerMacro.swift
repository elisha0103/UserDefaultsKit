//
//  UserDefaultsContainerMacro.swift
//  UserDefaultsKit
//
//  Created by 진태영 on 10/28/25.
//

import SwiftSyntax
import SwiftSyntaxMacros

public struct UserDefaultsContainerMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let properties = declaration.memberBlock.members
            .compactMap { $0.decl.as(VariableDeclSyntax.self) }
            .filter { varDecl in
                varDecl.attributes.contains { attr in
                    attr.as(AttributeSyntax.self)?.attributeName.description.contains("AutoKeyUserDefault") ?? false
                }
            }
        
        var initStatements: [String] = []
        for property in properties {
            if let binding = property.bindings.first,
               let identifier = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text,
               let initializer = binding.initializer?.value {
                let initValue = initializer.description.trimmingCharacters(in: .whitespaces)
                initStatements.append("""
                    if UserDefaults.standard.object(forKey: "\(identifier)") == nil {
                        self.\(identifier) = \(initValue)
                    }
                """)
            }
        }
        
        let functionBody = initStatements.joined(separator: "\n        ")
        
        return [
            """
            private func initializeDefaults() {
                \(raw: functionBody)
            }
            """
        ]
    }
}
