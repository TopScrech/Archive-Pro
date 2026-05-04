import ScrechKit

@main
struct ArchivePro: App {
    @StateObject private var store = ValueStore()
    private var nav: NavModel = .shared
    
    var body: some Scene {
        Window("Archive Pro", id: "main") {
            ArchiveWindowView()
                .environment(nav)
                .environmentObject(store)
        }
    }
}
