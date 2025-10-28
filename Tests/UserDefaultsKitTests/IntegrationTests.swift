import XCTest
@testable import UserDefaultsKit

final class IntegrationTests: XCTestCase {
    override func tearDown() {
        // 각 테스트 후 UserDefaults 초기화
        let defaults = UserDefaults.standard
        ["testString", "testInt", "testBool", "testURL"].forEach {
            defaults.removeObject(forKey: $0)
        }
        super.tearDown()
    }
    
    func testCodableExtension() throws {
        struct User: Codable, Equatable {
            let name: String
            let age: Int
        }
        
        let user = User(name: "John", age: 30)
        let defaults = UserDefaults.standard
        
        // 저장
        try defaults.setCodable(user, forKey: "testUser")
        
        // 읽기
        let retrieved: User? = try defaults.getCodable(forKey: "testUser")
        XCTAssertEqual(retrieved, user)
        
        // 안전한 읽기
        let safe: User? = defaults.codable(forKey: "testUser")
        XCTAssertEqual(safe, user)
        
        // 정리
        defaults.removeObject(forKey: "testUser")
    }
}
