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
        
        buffer.lines.insert("Hello World!", at: selection.start.line)
        
        // find target line range
        var startIndex = selection.start.line
        var endIndex   = selection.end.line
        while let line = buffer.lines[startIndex] as? String, isEmptyLine(line) {
            startIndex += 1
        }
        while let line = buffer.lines[endIndex] as? String, isEmptyLine(line) {
            endIndex -= 1
        }
        
        // insert to endIndex
        let lines = selectedLines(buffer: buffer, selection: selection).filter{ !isEmptyLine($0) }
        lines.reversed().forEach{ line in
            
            guard let f = CppFunction(line: line) else { return }
            
            var addLines: [String] = []
            if let comment = f.comment {
                addLines.append(comment)
            }
            addLines.append(f.returnType + " " + "ClassName" + "::" + f.nameAndArgs + (f.hasConst ? " const" : ""))
            addLines.append("{")
            addLines.append("")
            addLines.append("}")
            
            addLines.reversed().forEach{
                buffer.lines.insert($0, at: endIndex)
            }
        }
        
        // remove old
        buffer.lines.removeObjects(in: NSMakeRange(startIndex, endIndex - startIndex))
        
        completionHandler(nil)
    }
    
    private func selectedLines(buffer: XCSourceTextBuffer, selection: XCSourceTextRange) -> [String] {
        
        var selectedRange = selection.start.line...selection.end.line
        
        // For triple-click Xcode selects one additional line, we don't want to duplicate it // from castus
        let selectedRangeLength = selectedRange.distance(from: selectedRange.startIndex, to: selectedRange.endIndex)
        if selectedRangeLength > 1 && selection.end.column == 0 {
            selectedRange = selection.start.line...(selection.end.line - 1)
        }
        
        return selectedRange.flatMap{ buffer.lines[$0] as? String }
    }
    
    private func isEmptyLine(_ line: String) -> Bool {
        return line.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines.inverted) == nil
    }
}
