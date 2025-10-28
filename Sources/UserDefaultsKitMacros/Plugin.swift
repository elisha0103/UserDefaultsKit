//
//  Plugin.swift
//  UserDefaultsKit
//
//  Created by 진태영 on 10/28/25.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct UserDefaultsKitPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        AutoKeyUserDefaultMacro.self,
        UserDefaultsContainerMacro.self,
    ]
}
