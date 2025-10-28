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
        guard
            let varDecl = declaration.as(VariableDeclSyntax.self),
            let binding = varDecl.bindings.first,
            let identifier = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier,
            let initializer = binding.initializer?.value
        else {
            throw MacroError.message("@AutoKeyUserDefault는 초기값이 있는 변수에만 사용 가능합니다")
        }
        
        let propertyName = identifier.text
        let typeName = binding.typeAnnotation?.type.description.trimmingCharacters(in: .whitespaces) ?? "Unknown"
        let defaultValue = initializer.description.trimmingCharacters(in: .whitespaces)
        
        // key 파라미터 추출: 있으면 사용, 없으면 프로퍼티명 사용
        let customKey = extractKeyParameter(from: node)
        let actualKey = customKey ?? propertyName
        
        return [
            """
            get {
                UserDefaults.standard.object(forKey: "\(raw: actualKey)") as? \(raw: typeName) ?? \(defaultValue)
            }
            """,
            """
            set {
                objectWillChange.send()
                UserDefaults.standard.set(newValue, forKey: "\(raw: actualKey)")
            }
            """
        ]
    }
    
    /// 매크로 파라미터에서 key 값을 추출하는 헬퍼 메서드
    ///
    /// @AutoKeyUserDefault(key: "custom_key") 형태에서 "custom_key" 추출
    private static func extractKeyParameter(from node: AttributeSyntax) -> String? {
        guard
            let arguments = node.arguments,
            let argumentList = arguments.as(LabeledExprListSyntax.self)
        else {
            return nil
        }
        
        for argument in argumentList {
            // key: "custom_key" 형태 찾기
            if
                argument.label?.text == "key",
                let stringLiteral = argument.expression.as(StringLiteralExprSyntax.self),
                let segment = stringLiteral.segments.first,
                let stringSegment = segment.as(StringSegmentSyntax.self)
            {
                return stringSegment.content.text
            }
        }
        
        return nil
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
