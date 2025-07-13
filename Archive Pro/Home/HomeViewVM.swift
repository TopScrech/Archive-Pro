import ScrechKit

@Observable
final class HomeViewVM {
    func handleDrop(_ providers: [NSItemProvider]) {
        for provider in providers {
            if let name = provider.suggestedName {
                print("Name:", name)
            }
            
            guard provider.canLoadObject(ofClass: URL.self) else {
                return
            }
            
            _ = provider.loadObject(ofClass: URL.self) { url, error in
                if let error {
                    print("Error:", error)
                }
                
                guard let url else {
                    return
                }
                
                print("Dropped file URL:", url)
                
                self.fileSize(url)
            }
            
            //if provider.hasItemConformingToTypeIdentifier(type) {
            //    provider.loadDataRepresentation(forTypeIdentifier: type) { data, error in
            //
            //    }
            //}
        }
    }
    
    private func isDirectory(_ url: URL) -> Bool {
        let fm = FileManager.default
        var isDir: ObjCBool = false
        
        fm.fileExists(
            atPath: url.path,
            isDirectory: &isDir
        )
        
        return isDir.boolValue
    }
    
    func fileSize(_ url: URL) {
        let fm = FileManager.default
        
        let attributes = try? fm.attributesOfItem(atPath: url.path)
        let size = attributes?[.size] as? Int ?? 0
        
        print(formatBytes(size))
        //        return formatBytes(size)
    }
    
    func createTmpDir() {
        let fm = FileManager.default
        let name = UUID().uuidString
        
        let tmpDir = fm.temporaryDirectory.appendingPathComponent(name)
        
        do {
            try fm.createDirectory(
                at: tmpDir,
                withIntermediateDirectories: true
            )
            
            openInFinder(rootedAt: tmpDir.path)
        } catch {
            print("Error:", error)
        }
    }
}
