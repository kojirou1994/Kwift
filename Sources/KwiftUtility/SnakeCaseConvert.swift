import Foundation

public enum SnakeCaseConvert {}

public extension SnakeCaseConvert {
  static func convertFromSnakeCase(_ string: String) -> String {
    let json = """
    {
    \(try! JSONEncoder().encode(string).utf8String) : 1
    }
    """
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    let model = try! decoder.decode(KeyModel.self, from: Data(json.utf8))
    return model.key
  }

  static func convertToSnakeCase(_ string: String) -> String {
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    let model = KeyModel(key: string)
    let encoded = try! encoder.encode(model)
    let dic = try! JSONDecoder().decode([String: Bool].self, from: encoded)
    return dic.keys.first!
  }
}
fileprivate struct KeyModel: Codable {
  init(key: String) {
    self.key = key
  }

  let key: String

  struct Key: CodingKey {
    var stringValue: String

    init(stringValue: String) {
      self.stringValue = stringValue
    }

    var intValue: Int? { nil }

    init?(intValue: Int) {
      nil
    }
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: Key.self)
    key = container.allKeys[0].stringValue
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: Key.self)
    try container.encode(true, forKey: Key(stringValue: key))
  }
}
