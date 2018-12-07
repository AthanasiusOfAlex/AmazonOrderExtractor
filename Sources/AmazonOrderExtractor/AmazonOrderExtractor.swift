import ScriptingUtilities
import MicrosoftOutlookScripting
import SwiftSoup

let receiptCategory = "Receipt to print"
let searchString = "orderID"

public func getMessages() -> [String] {
    let outlook = application(name: "Microsoft Outlook") as! MicrosoftOutlookApplication
    
    outlook.activate()
    
    var result = [String]()
    
    let messages = outlook.inbox!.messages!().filter {
        let message = $0 as! MicrosoftOutlookMessage
        guard let categories = message.categories else { return false }
        
        for category in categories {
            if let name = category.name, name==receiptCategory {
                return true
            }
        }
        
        return false
    }
    
    for message in messages {
        let message = message as! MicrosoftOutlookMessage
        
        if let content = message.content {
            result.append(content)
        }
    }
    
    return result
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

public func getOrderNumber(content: String) -> String? {
    guard let document = try? parse(content) else { return nil }
    guard let links = try? document.select("a[href]") else { return nil }
    
//    let linksWithOrderID = links.filter {
//        guard let attributes = $0.getAttributes() else { return false }
//        let hrefs = attributes.filter { $0.getKey()=="href" }
//
//        let withOrderID = hrefs.filter {
//            let value = $0.getValue()
//            if let _ = value.range(of: "OrderID") {
//                return true
//            } else {
//                return false
//            }
//        }
//
//        guard !withOrderID.isEmpty else { return false }
//
//        return true
//    }
//
//    guard let link = linksWithOrderID.first else { return nil }
//    guard let text = try? link.text() else { return nil }
    
    
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
    
    return try? linkWithOrderID.attr("href")
}
