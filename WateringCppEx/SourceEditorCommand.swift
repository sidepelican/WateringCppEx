//
//  SourceEditorCommand.swift
//  WateringCppEx
//
//  Created by kenta on 2017/03/27.
//  Copyright © 2017年 sidepelican. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        
        let buffer: XCSourceTextBuffer = invocation.buffer
        guard let selection = buffer.selections.firstObject as? XCSourceTextRange else {
            completionHandler(NSError(domain: "WateringCpp", code: -1, userInfo: [NSLocalizedDescriptionKey: "No selection"]))
            return
        }
        
        // find ClassName
        guard let secondLine = buffer.lines[1] as? String else {
            completionHandler(NSError(domain: "WateringCpp", code: -1, userInfo: [NSLocalizedDescriptionKey: "cannot read line 2"]))
            return
        }
        let matches = secondLine.match(pattern: "\\w+")
        guard !matches.isEmpty else {
            completionHandler(NSError(domain: "WateringCpp", code: -1, userInfo: [NSLocalizedDescriptionKey: "cannot find ClassName at line 2"]))
            return
        }
        let className = matches[0][0]
    
        // replace from back
        var currentIndex = selection.end.line
        
        while selection.start.line <= currentIndex {
            
            guard let line = buffer.lines[currentIndex] as? String else { break }
            defer {
                currentIndex -= 1
            }
            if isEmptyLine(line) { continue }
            guard let f = CppFunction(line: line) else { continue }
            buffer.lines.removeObject(at: currentIndex)
            
            var addLines: [String] = []
            if let comment = f.comment {
                addLines.append(comment)
            }
            addLines.append(f.returnType + " " + className + "::" + f.nameAndArgs + (f.hasConst ? " const" : ""))
            addLines.append("{")
            addLines.append("")
            addLines.append("}")
            addLines.append("")
            
            addLines.reversed().forEach{
                buffer.lines.insert($0, at: currentIndex)
            }
        }
        
        completionHandler(nil)
    }
    
    private func isEmptyLine(_ line: String) -> Bool {
        return line.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines.inverted) == nil
    }
}
