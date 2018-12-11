//
//  ChromeOperations.swift
//  AmazonOrderExtractor
//
//  Created by Louis Melahn on 12/8/18.
//

import Foundation

public extension Date {
    
    private func getName(withFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    public func getMonthName() -> String { return getName(withFormat: "MM") }
    public func getYearName() -> String { return getName(withFormat: "yyyy") }
    public func getDayName() -> String { return getName(withFormat: "dd") }
}

public func runAppleScript(appleScript: String) -> [NSObject: AnyObject] {
    let script = NSAppleScript(source: appleScript)!
    var errorInfo = NSDictionary()
    withUnsafeMutablePointer(to: &errorInfo) {
        let errorInfoPointer = AutoreleasingUnsafeMutablePointer<NSDictionary?>($0)
        script.executeAndReturnError(errorInfoPointer)
    }
    return errorInfo as [NSObject: AnyObject]
}

public func openLinksInChrome() {
    do {
        func fillFirstTab(withUrl url: String) {
            let script = """
            set myLink to "\(url)"
            tell application "Google Chrome"
            set myWindow to (make new window)
            set myTab to active tab of myWindow
            set URL of myTab to myLink
            end tell
            """
            _ = runAppleScript(appleScript: script)
        }
        
        func fillOtherTab(withUrl url: String) {
            let script = """
            set myLink to "\(url)"
            tell application "Google Chrome"
            tell front window to make new tab at after (get active tab) with properties {URL:myLink}
            end tell
            """
            _ = runAppleScript(appleScript: script)
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
