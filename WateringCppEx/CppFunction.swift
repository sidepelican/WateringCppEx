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
    let hasConst: Bool
    let comment: String?
    
    init?(line: String) {
        
        // function name & Args
        var ans = line.match(pattern: "\\w+((\\(\\))|\\([\\w*]+\\s[\\w\\s<>&*\\(\\),:]+\\))")
        guard !ans.isEmpty else { return nil }
        let nameAndArgs = ans[0][0]
        self.nameAndArgs = nameAndArgs
        
        // virtual & returnType
        ans = line.match(pattern: "[\\w\\(\\)&<>,]+")
        guard !ans.isEmpty else { return nil }
        
        self.hasVirtual = ans[0][0] == "virtual"
        if self.hasVirtual {
            ans.removeFirst()
        }
        
        self.returnType = ans.flatMap{$0}.prefix{ !nameAndArgs.contains($0) }.joined()
        
        // has const
        self.hasConst = !line.match(pattern: "\\)\\s*const").isEmpty
        
        // has comment
        ans = line.match(pattern: "//.*")
        if !ans.isEmpty {
            self.comment = ans[0][0]
        }else{
            self.comment = nil
        }
    }
}
