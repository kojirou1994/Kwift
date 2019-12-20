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
    
    private func match(data: Data) -> Bool {
        if data.count < headerLength {
            return false
        }
        let currentHeader = data[..<(data.startIndex+headerLength)]
        return header.elementsEqual(currentHeader)
    }
    
    public var mimeType: String {
        return "image/\(rawValue)"
    }
    
    public init?(data: Data) {
        if let r = ImageFormat.allCases.first(where: {$0.match(data: data)}) {
            self = r
        } else {
            return nil
        }
    }
    
}

public struct Resolution<T: UnsignedInteger & LosslessStringConvertible>: Hashable, LosslessStringConvertible {
    
    public var width: T
    
    public var height: T
    
    public var size: UInt {
        return UInt(width) * UInt(height)
    }
    
    public init(width: T, height: T) {
        self.width = width
        self.height = height
    }
    
    public init?(_ description: String) {
        let splited = description.split(separator: "x")
        guard splited.count == 2,
            let w = T(String(splited[0])), let h = T(String(splited[1])) else {
            return nil
        }
        self.init(width: w, height: h)
    }
    
    public var description: String {
        return "\(width)x\(height)"
    }
    
    public var ratio: Double {
        return Double(width) / Double(height)
    }
    
}

public struct ImageInfo {
    public let format: ImageFormat
    public let resolution: Resolution<UInt32>
    public let depth: UInt8
    public let colors: UInt32
    
    public init?(data: Data) {
        guard let format = ImageFormat(data: data) else {
            return nil
        }
        self.format = format
        let reader = ByteReader(data: data)
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
                return nil
            }
            reader.skip(8)
//            width = reader.read(4).joined(UInt32.self)
//            height = reader.read(4).joined(UInt32.self)
            while reader.restBytesCount > 12 {
                let clen = reader.read(4).joined(UInt32.self)
                let tag = reader.read(4)
                #if DEBUG
//                print("\(reader.currentIndex) \(String(decoding: tag, as: UTF8.self))")
                #endif
                if clen == 13, tag.elementsEqual([0x49, 0x48, 0x44, 0x52]) {
                    // IHDR
                    width = reader.read(4).joined(UInt32.self)
                    height = reader.read(4).joined(UInt32.self)
                    depth = reader.readByte()
                    let colorType = reader.readByte()
                    reader.skip(1 + 1 + 1 + 4)
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
                    return nil
                } else {
                    reader.skip(Int(4+clen))
                }
            }
            if width == nil {
                return nil
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
            reader.skip(2)
            while true {
                /* look for sync FF byte */
                while !reader.isAtEnd {
                    if reader.readByte() == 0xff {
                        break
                    }
                }
                if reader.isAtEnd {
                    break
                }
                /* eat any extra pad FF bytes before marker */
                while !reader.isAtEnd {
                    if reader.readByte() != 0xff {
                        break
                    }
                }
                if reader.isAtEnd {
                    break
                }
                reader.skip(-1)
                if reader.currentByte == 0xda || reader.currentByte == 0xd9 {
                    return nil
                } else if [0xc0, 0xc1, 0xc2, 0xc3, 0xc5, 0xc6, 0xc7, 0xc9, 0xca, 0xcb, 0xcd, 0xce, 0xcf].contains(reader.data[reader.currentIndex]) {
                    reader.skip(1)
                    if reader.restBytesCount < 2 {
                        return nil
                    } else {
                        let clen = reader.read(2).joined(UInt32.self)
                        if clen < 8 || reader.restBytesCount < clen {
                            return nil
                        }
                        depth = reader.readByte()
                        height = reader.read(2).joined(UInt32.self)
                        width = reader.read(2).joined(UInt32.self)
                        depth *= reader.readByte()
                        colors = 0
                        break
                    }
                } else { // skip it
                    reader.skip(1)
                    if reader.restBytesCount < 2 {
                        return nil
                    } else {
                        let clen = reader.read(2).joined(UInt32.self)
                        if clen < 2 || reader.restBytesCount < clen {
                            return nil
                        }
                        reader.skip(Int(clen-2))
                    }
                }
            }
            if width == nil {
                return nil
            }
            self.resolution = .init(width: width!, height: height!)
            self.depth = depth
            self.colors = colors!
            //        case .gif: fatalError("gif not supported")
        }
    }
}
