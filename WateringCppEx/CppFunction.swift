//
//  CppFunction.swift
//  WateringCpp
//
//  Created by kenta on 2017/03/28.
//  Copyright © 2017年 sidepelican. All rights reserved.
//

import Foundation

struct CppFunction {
    
    let nameAndArgs: String
    let returnType: String
    let hasVirtual: Bool
    let hasStatic: Bool
    let hasOverride: Bool
    let hasConst: Bool
    let comment: String?
    
    init?(line: String) {
        
        var line = line
        var ans: [[String]] = []
        
        // remove default value
        line = line.replacingOccurrences(of: "\\s*?=\\s*?[\\w\"\\.f]+", with: "", options: .regularExpression, range: nil)
        
        // function name & Args
        do {
            // CONSTREF(T)マクロが正規表現じゃどうしようもないためエスケープ
            let macroUnwrapped = line.replacingOccurrences(of: "CONSTREF\\((\\w+)\\)", with: "const $1&", options: .regularExpression, range: nil)
            
            ans = macroUnwrapped.match(pattern: "\\w+((\\(\\))|\\([\\w<>&*]+\\s[\\w\\s<>&*\\(\\),:=\"]+\\))")
            guard !ans.isEmpty else { return nil }
            
            var nameAndArgs = ans[0][0]
            
            // 展開したものを戻す
            if macroUnwrapped != line {
                nameAndArgs = nameAndArgs.replacingOccurrences(of: "const (\\w+)&", with: "CONSTREF($1)", options: .regularExpression, range: nil)
            }
            
            self.nameAndArgs = nameAndArgs
        }
        
        // has overrride
        self.hasOverride = !line.match(pattern: "\\).*override").isEmpty
        
        // has const
        self.hasConst = !line.match(pattern: "\\).*const").isEmpty
        
        // has comment
        ans = line.match(pattern: "//.*")
        if !ans.isEmpty {
            self.comment = ans[0][0]
            line.removeSubrange(line.range(of: self.comment!)!)
        }else{
            self.comment = nil
        }
        
        // remove noizy words
        line = line.replacingOccurrences(of: self.nameAndArgs, with: "")
        if self.hasOverride {
            line = line.replacingOccurrences(of: "override", with: "")
        }
        if self.hasConst {
            line = line.replacingOccurrences(of: "const", with: "")
        }
        
        // virtual & static & returnType
        ans = line.match(pattern: "[\\w\\(\\)&<>,:]+")
        guard !ans.isEmpty else { return nil }
        
        self.hasVirtual = ans[0][0] == "virtual"
        if self.hasVirtual {
            ans.removeFirst()
        }
        
        self.hasStatic = ans[0][0] == "static"
        if self.hasStatic {
            ans.removeFirst()
        }
        
        self.returnType = ans.flatMap{$0}.prefix{ !$0.contains(";") }.joined()
    }
}
