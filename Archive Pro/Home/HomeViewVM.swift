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
                
                do {
                    guard
                        let archiveURL = try self.createZipArchive(from: [url])
                    else {
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
    
    func getSaveLocation() -> URL? {
        switch ValueStore().savingLocation {
        case .tmpDir:
            createTmpDir()
            
        case .downloads:
            downloadsDir()
        }
    }
    
    private func downloadsDir() -> URL? {
        let fm = FileManager.default
        
        return try? fm.url(
            for: .downloadsDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
    }
    
    func createZipArchive(from sourceURLs: [URL]) throws -> URL? {
        guard
            let saveLocation = getSaveLocation()
        else {
            print("Failed to create tmp dir")
            return nil
        }
        
        let archiveURL = saveLocation.appendingPathComponent("archive.zip")
        
        // Extract folder and file names for grouping by folder
        let folderGroups = Dictionary(grouping: sourceURLs) {
            $0.deletingLastPathComponent()
        }
        
        for (folderURL, files) in folderGroups {
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/zip")
            process.currentDirectoryURL = folderURL
            process.arguments = ["-j", "-r", archiveURL.path] + files.map(\.lastPathComponent)
            
            try process.run()
            process.waitUntilExit()
            
            guard
                process.terminationStatus == 0
            else {
                print("Zip command failed for folder:", folderURL.path)
                return nil
            }
        }
        
        return archiveURL
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
