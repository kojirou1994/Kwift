extension Dictionary {
  public init(_ optionalDictionary: Dictionary<Key, Value?>) {
    self.init()
    for (k, v) in optionalDictionary where v != nil {
      self[k] = v
    }
  }
}
