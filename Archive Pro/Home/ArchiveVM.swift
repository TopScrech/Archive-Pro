import ScrechKit

@Observable
final class ArchiveVM {
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
                
                do {
                    guard
                        let saveLocation = self.getSaveLocation()
                    else {
                        print("Failed to create tmp dir")
                        return
                    }
                    
                    let archiveURL = try self.createArchive(
                        from: [url],
                        at: saveLocation
                    )
                    
                    guard let archiveURL else {
                        return
                    }
                    
                    openInFinder(
                        rootedAt: archiveURL.deletingLastPathComponent().path
                    )
                } catch {
                    print(error)
                }
            }
            
            //if provider.hasItemConformingToTypeIdentifier(type) {
            //    provider.loadDataRepresentation(forTypeIdentifier: type) { data, error in
            //
            //    }
            //}
        }
    }
    
    func createArchive(
        from sourceURLs: [URL],
        at saveLocation: URL
    ) throws -> URL? {
        
        switch ValueStore().archiveFormat {
        case .tar: try Archiver.createTarArchive(from: sourceURLs, at: saveLocation)
        case .zip: try Archiver.createZipArchive(from: sourceURLs, at: saveLocation)
        case .tarGz: try Archiver.createTarGzArchive(from: sourceURLs, at: saveLocation)
        case .tarBz2: try Archiver.createTarBz2Archive(from: sourceURLs, at: saveLocation)
        case .tarXz: try Archiver.createTarXzArchive(from: sourceURLs, at: saveLocation)
        case .cpio: try Archiver.createCpioArchive(from: sourceURLs, at: saveLocation)
        }
    }
    
    func getSaveLocation() -> URL? {
        switch ValueStore().savingLocation {
        case .tmpDir:
            createTmpDir()
            
        case .downloads:
            URL.downloadsDirectory
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
    
    func createTmpDir() -> URL? {
        let fm = FileManager.default
        let name = UUID().uuidString
        
        let tmpDir = fm.temporaryDirectory.appendingPathComponent(name)
        
        do {
            try fm.createDirectory(
                at: tmpDir,
                withIntermediateDirectories: true
            )
            
            return tmpDir
        } catch {
            print("Error:", error)
            return nil
        }
    }
}
