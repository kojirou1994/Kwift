public struct AnyCodingKey: CodingKey {
    
    public let key: String
    
    public init(stringValue: String) {
        key = stringValue
    }
    
    public init(_ key: String) {
        self.key = key
    }
    
    public var stringValue: String { key }
    
    public var intValue: Int? { nil }
    
    public init?(intValue: Int) { nil }
}
