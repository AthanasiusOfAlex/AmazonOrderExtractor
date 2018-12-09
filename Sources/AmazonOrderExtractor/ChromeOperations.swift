//
//  ChromeOperations.swift
//  AmazonOrderExtractor
//
//  Created by Louis Melahn on 12/8/18.
//

import Foundation
//import GoogleChromeScripting
//import ScriptingUtilities
import ScriptingBridge

public func openLinksInChrome() {
    let script = NSAppleScript(source: """
        set myLink to "https://www.google.com/"
        tell application "Google Chrome"
            set myWindow to (make new window)
            tell front window to make new tab at after (get active tab) with properties {URL:myLink}
        end tell
    """)!
    
    var dict = NSDictionary()
    withUnsafeMutablePointer(to: &dict) {
        let errorInfo = AutoreleasingUnsafeMutablePointer<NSDictionary?>($0)
        //script.compileAndReturnError(errorInfo)
        script.executeAndReturnError(errorInfo)
    }
}
