//
//  String+regexp.swift
//  WateringCpp
//
//  Created by kenta on 2017/03/28.
//  Copyright © 2017年 sidepelican. All rights reserved.
//

import Foundation

extension String {
    func match(pattern: String, options: NSRegularExpression.Options = []) -> [[String]] {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else {
            return []
        }

        let nsself = self as NSString
        let results = regex.matches(in: self, range: NSMakeRange(0, nsself.length))
        
        return results.flatMap { result -> [String]? in
            let ranges: [NSRange] = (0..<result.numberOfRanges).flatMap{
                let range = result.rangeAt($0)
                guard range.location + range.length <= nsself.length else { return nil }
                return range
            }
            let submatches: [String] = ranges.map{ nsself.substring(with: $0) }
            if submatches.isEmpty { return nil }
            
            return submatches
        }
    }
}
