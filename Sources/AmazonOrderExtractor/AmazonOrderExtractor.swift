import ScriptingUtilities
import MicrosoftOutlookScripting

enum AmazonOrderConstants: String {
    case receiptCategory = "Receipt to print"
}

func extractTextFromMessages() {
    let outlook = application(name: "Microsoft Outlook") as! MicrosoftOutlookApplication
    
    outlook.activate()
    
    for message in outlook.inbox!.messages!() {
        let message = message as! MicrosoftOutlookMessage
        
        print(message.content ?? "")
    }
}
