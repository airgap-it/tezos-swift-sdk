import Foundation

public extension Encodable {
    
    func toJSON() throws -> String {
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(self)
        
        return .init(data: jsonData, encoding: .utf8)!
    }
}

public extension String {
    
    func decodeJSON<T: Decodable>(_ type: T.Type) throws -> T {
        let decoder = JSONDecoder()
        let jsonData = Data(self.utf8)
        
        return try decoder.decode(type, from: jsonData)
    }
}
