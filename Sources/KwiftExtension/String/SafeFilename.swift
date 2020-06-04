// characterSet contains all illegal characters on OS X and Windows
@usableFromInline let illegalFilenameCharacterSet: Set<Character> = .init("\"\\/?<>:*|\n\r")

extension StringProtocol {

  public func safeFilename(_ replacingString: String = "_") -> String {
    // TODO: use reserveCapacity method
    var result = ""
    result.reserveCapacity(utf8.count)
    forEach { char in
      if illegalFilenameCharacterSet.contains(char) {
        result.append(replacingString)
      } else {
        result.append(char)
      }
    }
    return result
  }
  
}
