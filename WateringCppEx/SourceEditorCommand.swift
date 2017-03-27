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
        
        completionHandler(nil)
    }
    
}
