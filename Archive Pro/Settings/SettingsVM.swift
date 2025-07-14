import ScrechKit

@Observable
final class SettingsVM {
    func openTmpDir() {
        let tmpDirURL = tmpDirUrl()
        
        openInFinder(rootedAt: tmpDirURL.path)
    }
    
    func clearTmpDir() {
        let fm = FileManager.default
        let tmpDirURL = tmpDirUrl()
        
        guard
            let contents = try? fm.contentsOfDirectory(atPath: tmpDirURL.path)
        else {
            print("Tmp dir is empty")
            return
        }
        
        for path in contents {
            guard !path.contains("dev.topscrech.Archive-Pro.savedState") else {
                return
            }
            
            try? fm.removeItem(atPath: path)
        }
    }
    
    private func tmpDirUrl() -> URL {
        FileManager.default.temporaryDirectory
    }
}
