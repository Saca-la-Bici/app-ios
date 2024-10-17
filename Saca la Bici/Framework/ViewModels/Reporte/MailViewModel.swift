import SwiftUI
import MessageUI

class MailViewModel: ObservableObject {
    @Published var isShowingMailView = false
    @Published var mailData: MailModel?
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var isMailSent = false 

    func sendMail() {
        self.mailData = MailModel(
            recipients: ["atencionciudadanaiqt@queretaro.gob.mx"],
            subject: "Consulta Ciudadana",
            body: "Estimado equipo de atención ciudadana..."
        )
        isShowingMailView = true
    }

    func canSendMail() -> Bool {
        let canSend = MFMailComposeViewController.canSendMail()
        if !canSend {
            DispatchQueue.main.async {
                self.alertMessage = "Este dispositivo no puede enviar correos. Por favor, configure una cuenta de correo."
                self.showAlert = true
            }
        }
        return canSend
    }
}
