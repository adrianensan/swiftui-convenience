import SwiftUI

public extension Encodable {
  var jsonEncoded: Data? {
    try? JSONEncoder().encode(self)
  }
}

public extension Data {
  func decoded<DecodedType: Decodable>() -> DecodedType? {
    try? JSONDecoder().decode(DecodedType.self, from: self)
  }
}

extension Dictionary: RawRepresentable where Key: Codable, Value: Codable {
  public init?(rawValue: String) {
    guard let data = rawValue.data(using: .utf8),
          let result = try? JSONDecoder().decode([Key: Value].self, from: data)
    else {
      return nil
    }
    self = result
  }
  
  public var rawValue: String {
    guard let data = try? JSONEncoder().encode(self),
          let result = String(data: data, encoding: .utf8)
    else {
      return "[]"
    }
    return result
  }
}

public protocol AppStorageCodable: Codable {}
public extension AppStorageCodable {
  init?(rawValue: String) {
    guard let data = rawValue.data(using: .utf8),
          let result = try? JSONDecoder().decode(Self.self, from: data)
    else {
      return nil
    }
    self = result
  }
  
  var rawValue: String {
    guard let data = try? JSONEncoder().encode(self),
          let result = String(data: data, encoding: .utf8)
    else {
      return ""
    }
    return result
  }
}
