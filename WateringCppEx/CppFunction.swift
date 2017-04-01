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
    let hasOverride: Bool
    let hasConst: Bool
    let comment: String?
    
    init?(line: String) {
        
        var line = line
        
        // function name & Args
        var ans = line.match(pattern: "\\w+((\\(\\))|\\([\\w*]+\\s[\\w\\s<>&*\\(\\),:]+\\))")
        guard !ans.isEmpty else { return nil }
        let nameAndArgs = ans[0][0]
        self.nameAndArgs = nameAndArgs
        
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
        
        // remove noizy words. // TODO: dirty
        line.removeSubrange(line.range(of: nameAndArgs)!)
        if self.hasOverride {
            line.removeSubrange(line.range(of: "override")!)
        }
        if self.hasConst {
            line.removeSubrange(line.range(of: "const")!)
        }
        
        // virtual & returnType
        ans = line.match(pattern: "[\\w\\(\\)&<>,]+")
        guard !ans.isEmpty else { return nil }
        
        self.hasVirtual = ans[0][0] == "virtual"
        if self.hasVirtual {
            ans.removeFirst()
        }
        
        self.returnType = ans.flatMap{$0}.prefix{ !$0.contains(";") }.joined()
    }
}
