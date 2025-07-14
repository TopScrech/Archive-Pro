import Foundation

extension Archiver {
    static func createTarBz2Archive(
        from sourceURLs: [URL],
        at saveLocation: URL
    ) throws -> URL? {
        
        let archiveURL = saveLocation.appendingPathComponent("archive.tar.bz2")
        
        let folderGroups = Dictionary(grouping: sourceURLs) {
            $0.deletingLastPathComponent()
        }
        
        for (folderURL, files) in folderGroups {
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/tar")
            process.currentDirectoryURL = folderURL
            
            let fileNames = files.map(\.lastPathComponent)
            process.arguments = ["-cjf", archiveURL.path] + fileNames
            
            try process.run()
            process.waitUntilExit()
            
            guard process.terminationStatus == 0 else {
                print("tar.bz2 command failed for folder:", folderURL.path)
                return nil
            }
        }
        
        return archiveURL
    }
}
