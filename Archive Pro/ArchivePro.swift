import ScrechKit

@main
struct ArchivePro: App {
//    @StateObject private var store = ValueStore()
    private var nav: NavModel = .shared
    
    var body: some Scene {
        WindowGroup {
            AppContainer()
                .environment(nav)
//                .environmentObject(store)
        }
    }
}
