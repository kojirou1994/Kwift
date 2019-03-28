//
//  ImageReader.swift
//  KwiftUtility
//
//  Created by Kojirou on 2019/3/28.
//

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
    
    private func match(data: Data) -> Bool {
        
        if data.count < headerLength {
            return false
        }
        let header = data[..<(data.startIndex+headerLength)]
        switch self {
        //        case .gif: return [0xff, 0xd8].elementsEqual(header)
        case .jpeg: return [0xff, 0xd8].elementsEqual(header)
        case .png: return [0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a].elementsEqual(header)
        }
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

public struct ImageInfo {
    public let format: ImageFormat
    public let height: UInt32
    public let width: UInt32
    public let depth: UInt8
    public let colors: UInt32
    
    public init?(data: Data) {
        guard let format = ImageFormat.init(data: data) else {
            return nil
        }
        self.format = format
        let reader = DataHandle.init(data: data)
        reader.skip(format.headerLength)
        var height: UInt32?
        var width: UInt32?
        var depth: UInt8 = 0
        var colors: UInt32?
        var needPalette = false
        switch format {
        case .png:
            while reader.restBytesCount > 12 {
                let clen = reader.read(4).joined(UInt32.self)
                let tag = reader.read(4)
                //                print(String.init(decoding: tag, as: UTF8.self))
                //                print(clen)
                if tag.elementsEqual([0x49, 0x48, 0x44, 0x52]) && clen == 13 {
                    // IHDR
                    width = reader.read(4).joined(UInt32.self)
                    height = reader.read(4).joined(UInt32.self)
                    depth = reader.readByte()
                    let colorType = reader.readByte()
                    if colorType == 3 {
                        /* even though the bit depth for color_type==3 can be 1,2,4,or 8,
                         * the spec in 11.2.2 of http://www.w3.org/TR/PNG/ says that the
                         * sample depth is always 8
                         */
                        depth = 3 * 8
                        needPalette = true
                    } else {
                        switch colorType {
                        case 0: break
                        case 2: depth *= 3
                        case 4: depth *= 2
                        case 6: depth *= 4
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
        case .jpeg:
            /* c.f. http://www.w3.org/Graphics/JPEG/itu-t81.pdf and Q22 of http://www.faqs.org/faqs/jpeg-faq/part1/ */
            while true {
                /* look for sync FF byte */
                while !reader.isAtEnd, reader.readByte() != 0xff { }
                if reader.isAtEnd {
                    break
                }
                /* eat any extra pad FF bytes before marker */
                while !reader.isAtEnd, reader.readByte() == 0xff { }
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
            //        case .gif: fatalError("gif not supported")
        }
        if width == nil {
            return nil
        }
        self.width = width!
        self.height = height!
        self.depth = depth
        self.colors = colors!
    }
}
