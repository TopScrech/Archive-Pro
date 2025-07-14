import ScrechKit

@Observable
final class SettingsVM {
    func openTmpDir() {
        let tmpDirURL = tmpDirUrl()
        
        openInFinder(rootedAt: tmpDirURL.path)
    }
    
    private func tmpDirUrl() -> URL {
        FileManager.default.temporaryDirectory
    }
}
