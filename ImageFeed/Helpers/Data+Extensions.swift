import Foundation

private let decoder = JSONDecoder()
private let encoder = JSONEncoder()

extension Data {
    static func toJson<T: Encodable>(from dto: T) -> Data? {
        try? encoder.encode(dto)
    }

    func fromJson<T: Decodable>(to dtoType: T.Type) -> T? {
        try? decoder.decode(dtoType, from: self)
    }
}
