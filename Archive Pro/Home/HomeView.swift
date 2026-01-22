import ScrechKit
import OSLog
import UniformTypeIdentifiers

struct HomeView: View {
    @State private var archiveVM = ArchiveVM()
    @EnvironmentObject private var store: ValueStore
    
    @State private var isTargeted = false
    
    var body: some View {
        DropZoneView(isTargeted: isTargeted)
            .padding(16)
            .onDrop(of: [.fileURL], isTargeted: $isTargeted) { providers in
                Task {
                    await handleDrop(providers)
                }
                
                return true
            }
    }
    
    private func handleDrop(_ providers: [NSItemProvider]) async {
        for provider in providers {
            guard let url = await loadURL(from: provider) else {
                continue
            }
            
            await handleURL(url)
        }
    }
    
    private func loadURL(from provider: NSItemProvider) async -> URL? {
        guard provider.canLoadObject(ofClass: URL.self) else {
            return nil
        }
        
        return await withCheckedContinuation { continuation in
            _ = provider.loadObject(ofClass: URL.self) { url, error in
                if let error {
                    Logger().error("\(error)")
                }
                
                continuation.resume(returning: url)
            }
        }
    }
    
    private func handleURL(_ url: URL) async {
        do {
            if archiveVM.isArchive(url) {
                let format = archiveVM.archiveType(url)
                let password = await passwordIfNeeded(for: format)
                
                if format == .appleEncryptedArchive, password == nil {
                    return
                }
                
                guard
                    let saveLocation = archiveVM.getSaveLocation(),
                    let extractedURL = try archiveVM.unarchive(at: url, to: saveLocation, password: password)
                else {
                    return
                }
                
                openInFinder(rootedAt: extractedURL.path)
            } else {
                let format = store.archiveFormat
                let password = await passwordIfNeeded(for: format)
                
                if format == .appleEncryptedArchive, password == nil {
                    return
                }
                
                guard
                    let saveLocation = archiveVM.getSaveLocation(),
                    let archiveURL = try archiveVM.createArchive(from: [url], at: saveLocation, password: password)
                else {
                    return
                }
                
                openInFinder(rootedAt: archiveURL.deletingLastPathComponent().path)
            }
        } catch {
            Logger().error("\(error)")
        }
    }
    
    private func passwordIfNeeded(for format: ArchiveFormat?) async -> String? {
        guard format == .appleEncryptedArchive else {
            return nil
        }
        
        return promptForAppleArchivePassword()
    }
    
    private func promptForAppleArchivePassword() -> String? {
        while true {
            let alert = NSAlert()
            alert.messageText = "Apple Encrypted Archive password"
            alert.informativeText = "Minimum 20 characters"
            
            let input = NSSecureTextField(frame: NSRect(x: 0, y: 0, width: 240, height: 24))
            alert.accessoryView = input
            alert.addButton(withTitle: "Continue")
            alert.addButton(withTitle: "Cancel")
            
            let response = alert.runModal()
            
            guard response == .alertFirstButtonReturn else {
                return nil
            }
            
            let password = input.stringValue
            
            guard password.count >= 20 else {
                let warning = NSAlert()
                warning.messageText = "Password too short"
                warning.informativeText = "Use at least 20 characters"
                warning.addButton(withTitle: "OK")
                warning.runModal()
                continue
            }
            
            return password
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(ValueStore())
}
