//
//  ImageReader.swift
//  KwiftUtility
//
//  Created by Kojirou on 2019/3/28.
//
// the code is stolen from:
// https://github.com/xiph/flac/blob/452a44777892086892feb8ed7f1156e9b897b5c3/src/share/grabbag/picture.c

import Foundation

public enum ImageFormat: String, CaseIterable {
    
    case jpeg
    
    case png
    //    case gif
    
    internal var headerLength: Int {
        switch self {
        //        case .gif: return 6
        case .jpeg: return 2
        case .png: return 8
        }
    }
    
    private var header: [UInt8] {
        switch self {
        case .jpeg:
            return [0xff, 0xd8]
        case .png:
            return [0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]
        }
    }
    
  private func match<D: DataProtocol>(_ data: D) -> Bool {
    if data.count < headerLength {
      return false
    }
    return header.elementsEqual(data.prefix(headerLength))
  }
    
  public var mimeType: String {
    "image/\(rawValue)"
  }
    
  public init<D: DataProtocol>(_ data: D) throws {
    self = try ImageFormat.allCases.first(where: {$0.match(data)}).unwrap("No matched ImageFormat.")
  }
    
}

public struct Resolution: Hashable, CustomStringConvertible {
    
    public var width: UInt32
    
    public var height: UInt32
    
    public var size: UInt {
        UInt(width) * UInt(height)
    }
    
    public init(width: UInt32, height: UInt32) {
        self.width = width
        self.height = height
    }

    public init?<S>(_ text: S, separator: Character = "x") where S: StringProtocol {
        guard let xIndex = text.firstIndex(of: separator),
            let w = UInt32(text[..<xIndex]),
            let h = UInt32(text[text.index(after: xIndex)...]) else {
            return nil
        }
        self.init(width: w, height: h)
    }
    
    public var description: String {
        "\(width)x\(height)"
    }
    
    public var ratio: Double {
        Double(width) / Double(height)
    }
    
}

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
                let tag = try reader.read(4)
                #if DEBUG
//                print("\(reader.currentIndex) \(String(decoding: tag, as: UTF8.self))")
                #endif
                if clen == 13, tag.elementsEqual([0x49, 0x48, 0x44, 0x52]) {
                    // IHDR
                  width = try reader.readInteger() as UInt32
                  height = try reader.readInteger() as UInt32
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
                } else if needPalette, tag.elementsEqual([0x50, 0x4c, 0x54, 0x45]) {
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
