import ScrechKit

struct ArchiveWindowView: View {
    @State private var archiveVM = ArchiveVM()
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: ValueStore
    
    var body: some View {
        AppContainer()
            .onOpenURL { url in
                Task {
                    let didExtractArchive = await archiveVM.handleIncomingURL(
                        url,
                        preferredArchiveFormat: store.archiveFormat
                    )
                    
                    if didExtractArchive {
                        dismiss()
                    }
                }
            }
    }
}
