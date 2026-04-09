import SwiftUI
import MessageUI

struct MailComposer: UIViewControllerRepresentable {
    let passports: [ExtractedPassport]
    @Binding var isPresented: Bool

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients(["bioinformatics@ucalgary.ca"])

        vc.setSubject("MCA Submission")

        let names = passports.enumerated().map { "\($0.offset + 1). \($0.element.taxonName)" }.joined(separator: "\n")
        let body = "Extracted \(passports.count) Taxon Passport(s):\n\(names)\n\nSee attached JSON."
        vc.setMessageBody(body, isHTML: false)

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        if let data = try? encoder.encode(passports) {
            let pmid = passports.first?.sourcePmid ?? "unknown"
            vc.addAttachmentData(data, mimeType: "application/json", fileName: "MCA_extraction_\(pmid).json")
        }
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator(isPresented: $isPresented) }

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var isPresented: Bool
        init(isPresented: Binding<Bool>) { _isPresented = isPresented }
        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult, error: Error?) {
            isPresented = false
        }
    }
}
