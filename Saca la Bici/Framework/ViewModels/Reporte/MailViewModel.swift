import SwiftUI
import MessageUI

class MailViewModel: ObservableObject {
    @Published var isShowingMailView = false
    @Published var mailData: MailModel?

    func sendMail() {
        self.mailData = MailModel(
            recipients: ["atencionciudadanaiqt@queretaro.gob.mx"],
            subject: "",
            body: ""
        )
        isShowingMailView = true
    }

    func canSendMail() -> Bool {
        return MFMailComposeViewController.canSendMail()
    }
}
