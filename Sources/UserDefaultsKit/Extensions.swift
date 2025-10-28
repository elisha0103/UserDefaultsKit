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
    /// Codable 객체를 UserDefaults에 저장
    ///
    /// - Parameters:
    ///   - value: 저장할 Codable 객체
    ///   - key: UserDefaults key
    /// - Throws: 인코딩 실패 시 에러
    func setCodable<T: Codable>(_ value: T, forKey key: String) throws {
        let data = try JSONEncoder().encode(value)
        set(data, forKey: key)
    }
    
    /// UserDefaults에서 Codable 객체 읽기
    ///
    /// - Parameter key: UserDefaults key
    /// - Returns: 디코딩된 객체 또는 nil
    /// - Throws: 디코딩 실패 시 에러
    func getCodable<T: Codable>(forKey key: String) throws -> T? {
        guard let data = data(forKey: key) else { return nil }
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    /// 안전하게 Codable 객체 읽기 (에러 무시)
    ///
    /// - Parameter key: UserDefaults key
    /// - Returns: 디코딩된 객체 또는 nil (에러 발생 시에도 nil 반환)
    func codable<T: Codable>(forKey key: String) -> T? {
        try? getCodable(forKey: key)
    }
}
