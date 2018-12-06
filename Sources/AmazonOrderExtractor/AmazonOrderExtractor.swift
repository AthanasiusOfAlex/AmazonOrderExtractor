import ScriptingUtilities
import MicrosoftOutlookScripting

let receiptCategory = "Receipt to print"

public func getMessageText() -> [String] {
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
