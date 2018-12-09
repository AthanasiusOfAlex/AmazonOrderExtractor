//
//  ChromeOperations.swift
//  AmazonOrderExtractor
//
//  Created by Louis Melahn on 12/8/18.
//

import Foundation

public func openLinksInChrome() {
    do {
        func runAppleScript(script: String) {
            let script = NSAppleScript(source: script)!
            var dict = NSDictionary()
            withUnsafeMutablePointer(to: &dict) {
                let errorInfo = AutoreleasingUnsafeMutablePointer<NSDictionary?>($0)
                script.executeAndReturnError(errorInfo)
            }
        }
        
        func fillFirstTab(withUrl url: String) {
            let script = """
            set myLink to "\(url)"
            tell application "Google Chrome"
            set myWindow to (make new window)
            set myTab to active tab of myWindow
            set URL of myTab to myLink
            end tell
            """
            runAppleScript(script: script)
        }
        
        func fillOtherTab(withUrl url: String) {
            let script = """
            set myLink to "\(url)"
            tell application "Google Chrome"
            tell front window to make new tab at after (get active tab) with properties {URL:myLink}
            end tell
            """
            runAppleScript(script: script)
        }
        
        let links = getReceiptMessages().map{ $0.getOrderSummaryLink() }.filter { $0 != nil }.map { $0! }
        
        if let firstLink = links.first {
            print(firstLink)
            fillFirstTab(withUrl: firstLink)
        }
        
        for link in links.dropFirst() {
            fillOtherTab(withUrl: link)
        }
    }
}
