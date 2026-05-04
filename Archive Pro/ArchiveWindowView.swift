import ScrechKit

struct ArchiveWindowView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: ValueStore
    @State private var archiveVM = ArchiveVM()
    
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
