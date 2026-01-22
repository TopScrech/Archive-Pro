import SwiftUI
import OSLog

struct AppContainer: View {
    @Environment(NavModel.self) private var nav
    
    var body: some View {
        NavigationSplitView {
            Sidebar()
        } detail: {
            NavDetail()
        }
        .frame(minWidth: 400, minHeight: 100)
        .task {
            try? nav.load()
        }
        .onChange(of: nav.selectedCategory) {
            save()
        }
    }
    
    private func save() {
        do {
            try nav.save()
        } catch {
            Logger().error("\(error)")
        }
    }
}
