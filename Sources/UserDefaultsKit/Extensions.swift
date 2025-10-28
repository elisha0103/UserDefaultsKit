//
//  Extensions.swift
//  UserDefaultsKit
//
//  Created by 진태영 on 10/28/25.
//

import Foundation
import SwiftUI

/// UserDefaults를 위한 편의 확장
public extension UserDefaults {
    /// Codable 객체 저장
    func setCodable<T: Codable>(_ value: T, forKey key: String) throws {
        let data = try JSONEncoder().encode(value)
        set(data, forKey: key)
    }
    
    /// Codable 객체 읽기
    func getCodable<T: Codable>(forKey key: String) throws -> T? {
        guard let data = data(forKey: key) else { return nil }
        return try JSONDecoder().decode(T.self, from: data)
    }
}
