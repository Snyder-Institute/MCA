import SwiftUI
import MessageUI

struct MailComposer: UIViewControllerRepresentable {
    let pmid: String
    let note: String
    let appVersion: String
    @Binding var isPresented: Bool
    var onResult: (MFMailComposeResult) -> Void

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients(["bioinformatics@ucalgary.ca"])
        vc.setSubject("[MCA Submission] PMID \(pmid)")

        let trimmedNote = note.trimmingCharacters(in: .whitespacesAndNewlines)
        let noteLine = trimmedNote.isEmpty ? "(no note)" : trimmedNote
        let body = """
        PMID: \(pmid)

        Note: \(noteLine)

        ---
        Sent from MCA iOS v\(appVersion)
        """
        vc.setMessageBody(body, isHTML: false)
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(isPresented: $isPresented, onResult: onResult)
    }

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var isPresented: Bool
        let onResult: (MFMailComposeResult) -> Void

        init(isPresented: Binding<Bool>, onResult: @escaping (MFMailComposeResult) -> Void) {
            _isPresented = isPresented
            self.onResult = onResult
        }

        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult, error: Error?) {
            isPresented = false
            onResult(result)
        }
    }
}

enum MailAvailability {
    static var canSendMail: Bool { MFMailComposeViewController.canSendMail() }
}
