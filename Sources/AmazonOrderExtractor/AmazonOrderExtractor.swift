import ScriptingUtilities
import MicrosoftOutlookScripting
import SwiftSoup
import Regex

let receiptCategory = "Receipt to print"
let searchString = "orderID"
let regexPattern = "\(searchString)%3D\\d{3}-\\d{6}-\\d{7}[^\\d]"

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
    
    print(regexPattern)
    guard let attributeText = try? linkWithOrderID.attr("href") else { return nil }
    guard let regex =  try? Regex(string: regexPattern) else { return nil }
    guard let match = regex.firstMatch(in: attributeText) else { return nil }
    
    return match.matchedString
}
