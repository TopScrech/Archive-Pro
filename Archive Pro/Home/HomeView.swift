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
        await archiveVM.handleIncomingURL(url, preferredArchiveFormat: store.archiveFormat)
    }
}

#Preview {
    HomeView()
        .environmentObject(ValueStore())
}
