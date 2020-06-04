extension CollectionOfOne: Equatable where Element: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.first! == rhs.first!
  }
}
