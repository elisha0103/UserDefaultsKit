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
        // 클래스 내의 모든 @AutoKeyUserDefault 프로퍼티 찾기
        let properties = declaration.memberBlock.members
            .compactMap { $0.decl.as(VariableDeclSyntax.self) }
            .filter { varDecl in
                varDecl.attributes.contains { attr in
                    attr.as(AttributeSyntax.self)?.attributeName.description.contains("AutoKeyUserDefault") ?? false
                }
            }
        
        var initStatements: [String] = []
        for property in properties {
            if
                let binding = property.bindings.first,
                let identifier = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text,
                let initializer = binding.initializer?.value
            {
                let initValue = initializer.description.trimmingCharacters(in: .whitespaces)
                
                // @AutoKeyUserDefault 속성에서 key 파라미터 추출
                let customKey = extractCustomKey(from: property)
                let actualKey = customKey ?? identifier
                
                // 각 프로퍼티에 대해 초기화 코드 생성 (실제 사용되는 key로)
                initStatements.append("""
                    if UserDefaults.standard.object(forKey: "\(actualKey)") == nil {
                        self.\(identifier) = \(initValue)
                    }
                """)
            }
        }
        
        let functionBody = initStatements.joined(separator: "\n        ")
        
        // initializeDefaults() 메서드 생성
        return [
            """
            private func initializeDefaults() {
                \(raw: functionBody)
            }
            """
        ]
    }
    
    /// 프로퍼티의 @AutoKeyUserDefault 속성에서 커스텀 key 추출
    private static func extractCustomKey(from property: VariableDeclSyntax) -> String? {
        for attribute in property.attributes {
            guard
                let attributeSyntax = attribute.as(AttributeSyntax.self),
                attributeSyntax.attributeName.description.contains("AutoKeyUserDefault"),
                let arguments = attributeSyntax.arguments,
                let argumentList = arguments.as(LabeledExprListSyntax.self)
            else {
                continue
            }
            
            for argument in argumentList {
                if
                    argument.label?.text == "key",
                    let stringLiteral = argument.expression.as(StringLiteralExprSyntax.self),
                    let segment = stringLiteral.segments.first,
                    let stringSegment = segment.as(StringSegmentSyntax.self)
                {
                    return stringSegment.content.text
                }
            }
        }
        
        return nil
    }
}
