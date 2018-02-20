//
//  String+Extension.swift
//  Kwift
//
//  Created by Kojirou on 2016/11/28.
//
//

import Foundation

extension String {
    
    public subscript(bounds: Range<Int>) -> String.SubSequence {
        return self[index(startIndex, offsetBy: bounds.lowerBound)..<index(startIndex, offsetBy: bounds.upperBound)]
    }
    
    public subscript(bounds: ClosedRange<Int>) -> String.SubSequence {
        return self[index(startIndex, offsetBy: bounds.lowerBound)...index(startIndex, offsetBy: bounds.upperBound)]
    }
    
    public subscript(i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
}
