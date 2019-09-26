public extension UInt8 {
    
    var bcdEncoded: UInt8 {
        var nibble2: UInt8 = 0
        var nibble1: UInt8 = 0
        var result: UInt8 = 0
        
        if self > 153 { //BCD cannot be greater than 0b10011001, i.e. d153, which translates to BCD 99
            return 0
        }
        if self > 9 {
            nibble1 = (self / 10) << 4
            nibble2 = (self % 10)
            result = nibble1 ^ nibble2
        }
        if self < 10 {
            result = self
        }
        
        return result
    }
    
    var bcdDecoded: UInt8 {
        ((self >> 4) * 10) + (self & 0x0F)
    }
    
}
