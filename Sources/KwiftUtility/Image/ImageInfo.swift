import Foundation
/*
 Note:
 https://github.com/xiph/flac/blob/452a44777892086892feb8ed7f1156e9b897b5c3/src/share/grabbag/picture.c
 */

public enum ImageInfoParseError: Error {
  case invalidPNG
  case invalidJPEG
}

public struct ImageInfo {
  public let format: ImageFormat
  public let resolution: Resolution
  public let depth: UInt8
  public let colors: UInt32

  public init<D: DataProtocol>(data: D) throws {
    format = try ImageFormat(data)
    var reader = ByteReader(data)
    switch format {
    case .png:
      var height: UInt32?
      var width: UInt32?
      var depth: UInt8 = 0
      var colors: UInt32?
      var needPalette = false
      guard data.count >= 25 else {
        #if DEBUG
        print("failed to read png info")
        #endif
        throw ImageInfoParseError.invalidPNG
      }
      try reader.skip(8)
      //            width = reader.read(4).joined(UInt32.self)
      //            height = reader.read(4).joined(UInt32.self)
      while reader.restBytesCount > 12 {
        let clen = try reader.readInteger() as UInt32
        let tag = try reader.readInteger() as UInt32
        #if DEBUG
        //                print("\(reader.currentIndex) \(String(decoding: tag, as: UTF8.self))")
        #endif
        if clen == 13, tag == 0x49484452 {
          // IHDR
          width = try reader.readInteger()
          height = try reader.readInteger()
          depth = try reader.readByte()
          let colorType = try reader.readByte()
          try reader.skip(1 + 1 + 1 + 4)
          if colorType == 3 {
            /* even though the bit depth for color_type==3 can be 1,2,4,or 8,
             * the spec in 11.2.2 of http://www.w3.org/TR/PNG/ says that the
             * sample depth is always 8
             */
            depth = 3 * 8
            needPalette = true
          } else {
            switch colorType {
            case 0:
              /* greyscale, 1 sample per pixel */
              break
            case 2:
              /* truecolor, 3 samples per pixel */
              depth *= 3
            case 4:
              /* greyscale+alpha, 2 samples per pixel */
              depth *= 2
            case 6:
              /* truecolor+alpha, 4 samples per pixel */
              depth *= 4
            default: break
            }
            colors = 0
            break
          }
        } else if needPalette, tag == 0x504c5445 {
          // PLTE
          colors = clen / 3
          break
        } else if (clen + 12) > reader.restBytesCount {
          throw ImageInfoParseError.invalidPNG
        } else {
          try reader.skip(Int(4+clen))
        }
      }
      if width == nil {
        throw ImageInfoParseError.invalidPNG
      }
      self.resolution = .init(width: width!, height: height!)
      self.depth = depth
      self.colors = colors!
    case .jpeg:
      /* c.f. http://www.w3.org/Graphics/JPEG/itu-t81.pdf and Q22 of http://www.faqs.org/faqs/jpeg-faq/part1/ */
      var height: UInt32?
      var width: UInt32?
      var depth: UInt8 = 0
      var colors: UInt32?
      try reader.skip(2)
      while true {
        /* look for sync FF byte */
        while !reader.isAtEnd {
          if try reader.readByte() == 0xff {
            break
          }
        }
        if reader.isAtEnd {
          break
        }
        /* eat any extra pad FF bytes before marker */
        while !reader.isAtEnd {
          if try reader.readByte() != 0xff {
            break
          }
        }
        if reader.isAtEnd {
          break
        }
        try reader.skip(-1)
        if reader.currentByte == 0xda || reader.currentByte == 0xd9 {
          throw ImageInfoParseError.invalidJPEG
        } else if [0xc0, 0xc1, 0xc2, 0xc3, 0xc5, 0xc6, 0xc7, 0xc9, 0xca, 0xcb, 0xcd, 0xce, 0xcf].contains(reader.data[reader.currentIndex]) {
          try reader.skip(1)
          if reader.restBytesCount < 2 {
            throw ImageInfoParseError.invalidJPEG
          } else {
            let clen = try reader.read(2).joined(UInt32.self)
            if clen < 8 || reader.restBytesCount < clen {
              throw ImageInfoParseError.invalidJPEG
            }
            depth = try reader.readByte()
            height = try reader.read(2).joined(UInt32.self)
            width = try reader.read(2).joined(UInt32.self)
            depth *= try reader.readByte()
            colors = 0
            break
          }
        } else { // skip it
          try reader.skip(1)
          if reader.restBytesCount < 2 {
            throw ImageInfoParseError.invalidJPEG
          } else {
            let clen = try reader.read(2).joined(UInt32.self)
            if clen < 2 || reader.restBytesCount < clen {
              throw ImageInfoParseError.invalidJPEG
            }
            try reader.skip(Int(clen-2))
          }
        }
      }
      if width == nil {
        throw ImageInfoParseError.invalidJPEG
      }
      self.resolution = .init(width: width!, height: height!)
      self.depth = depth
      self.colors = colors!
      //        case .gif: fatalError("gif not supported")
    }
  }
}
