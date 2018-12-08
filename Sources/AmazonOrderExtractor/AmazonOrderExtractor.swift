import ScriptingBridge
import ScriptingUtilities
import MicrosoftOutlookScripting
import GoogleChromeScripting
import SwiftSoup
import Regex

let receiptCategory = "Receipt to print"
let searchString = "orderID"
let regexPattern = "\(searchString)%3D(\\d{3}-\\d{7}-\\d{7})[^\\d]" //e.g., 408-2248585-7863562

public func getReceiptMessages() -> [MicrosoftOutlookMessage] {
    let outlook = application(name: "Microsoft Outlook") as! MicrosoftOutlookApplication
    
    let messages = outlook.inbox!.messages!() as! [MicrosoftOutlookMessage]
    
    return messages.filter {
        guard let categories = $0.categories else { return false }
        
        for category in categories {
            if let name = category.name, name==receiptCategory {
                return true
            }
        }
        
        return false
    }
}

extension String {
    func contains(substring: String) -> Bool {
        if let _ = self.range(of: substring) {
            return true
        } else {
            return false
        }
    }
}

fileprivate func getOrderNumber(content: String) -> String? {
    guard let document = try? parse(content) else { return nil }
    guard let links = try? document.select("a[href]") else { return nil }
    
    guard let linkWithOrderID = links.first(where: {
        guard let attributes = $0.getAttributes() else { return false }
        let hrefs = attributes.filter { $0.getKey()=="href" }
        
        if let _ = hrefs.first(where: { $0.getValue().contains(substring: searchString) }) {
            return true
        } else {
            return false
        }
    }) else {
        return nil
    }
    
    guard let attributeText = try? linkWithOrderID.attr("href") else { return nil }
    guard let regex = try? Regex(string: regexPattern) else { return nil }
    guard let match = regex.firstMatch(in: attributeText) else { return nil }
    guard let firstCapture = match.captures.first else { return nil }
    
    return firstCapture
}

public struct EmailAddress {
    fileprivate let originalObject: [AnyHashable : Any]
}

public extension EmailAddress {
    var name: String { return originalObject["name"]! as! String }
    var address: String { return originalObject["address"]! as! String }
    var type: MicrosoftOutlookEmailAddressType {
        return MicrosoftOutlookEmailAddressType(rawValue: originalObject["type"] as! AEKeyword)!}
}

public extension MicrosoftOutlookMessage {
    public var senderEmail: EmailAddress {
        return EmailAddress(originalObject: self.sender!)
    }
}

public extension MicrosoftOutlookMessage {
    func getOrderNumber() -> String? {
        guard let content = self.content else { return nil }
        return AmazonOrderExtractor.getOrderNumber(content: content)
    }
}

public extension MicrosoftOutlookMessage {
    func getWebsite() -> String {
        return senderEmail.name.lowercased()
    }
}

func makeOrderSummaryLink(website: String, orderID: String) -> String {
    return "https://www.\(website)/gp/css/summary/print.html/ref=od_aui_print_invoice?ie=UTF8&orderID=\(orderID)"
}

public extension MicrosoftOutlookMessage {
    func getOrderSummaryLink() -> String? {
        guard let orderID = self.getOrderNumber() else { return nil }
        let website = self.getWebsite()
        
        return makeOrderSummaryLink(website: website, orderID: orderID)
    }
}

public func printListOfLinks(outFileUrl url: URL) {
    let messages = getReceiptMessages()
    let links = messages.map { $0.getOrderSummaryLink()! }
    let output = links.reduce(String()) { "\($0)<p><a href=\"\($1)\">\($1)</a></p>" }
    try? output.write(to: url, atomically: false, encoding: .utf8)
}


public func openLinksInChrome() {
    let messages = getReceiptMessages()
    let chrome = application(name: "Google Chrome") as! GoogleChromeApplication
    
    chrome.activate()
}
