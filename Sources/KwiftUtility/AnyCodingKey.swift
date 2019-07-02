public struct AnyCodingKey: CodingKey {
    
    public let key: String
    
    public init(stringValue: String) {
        key = stringValue
    }
    
    public init(_ key: String) {
        self.key = key
    }
    
    public var stringValue: String { return key }
    
    public var intValue: Int? { return nil }
    
    public init?(intValue: Int) { return nil }
}
