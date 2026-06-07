import ScrechKit

struct ArchiveProCommands: Commands {
    @Environment(\.openWindow) private var openWindow
    
    let nav: NavModel
    
    var body: some Commands {
        CommandGroup(replacing: .appSettings) {
            Button("Settings", systemImage: "gear", action: openSettings)
                .keyboardShortcut(",", modifiers: .command)
        }
    }
    
    private func openSettings() {
        nav.selectedCategory = .settings
        openWindow(id: "main")
    }
}
