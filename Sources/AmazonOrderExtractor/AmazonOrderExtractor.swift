import ScriptingUtilities
import MicrosoftOutlookScripting

enum AmazonOrderConstants: String {
    case receiptCategory = "Receipt to print"
}

func extractTextFromMessages() -> [String] {
    let outlook = application(name: "Microsoft Outlook") as! MicrosoftOutlookApplication
    
    outlook.activate()
    
    var result = [String]()
    
    for message in outlook.inbox!.messages!() {
        let message = message as! MicrosoftOutlookMessage
        
        if let content = message.content {
            result.append(content)
        }
    }
    
    return result
}
