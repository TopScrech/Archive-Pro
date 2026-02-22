import ScrechKit

@main
struct ArchivePro: App {
    @StateObject private var store = ValueStore()
    @State private var archiveVM = ArchiveVM()
    private var nav: NavModel = .shared
    
    var body: some Scene {
        Window("Archive Pro", id: "main") {
            AppContainer()
                .environment(nav)
                .environmentObject(store)
                .onOpenURL { url in
                    Task {
                        await archiveVM.handleIncomingURL(
                            url,
                            preferredArchiveFormat: store.archiveFormat
                        )
                    }
                }
        }
    }
}
