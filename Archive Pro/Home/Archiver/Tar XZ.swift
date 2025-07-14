import Foundation

extension Archiver {
    static func createTarXzArchive(
        from sourceURLs: [URL],
        at saveLocation: URL
    ) throws -> URL? {
        
        let archiveURL = saveLocation.appendingPathComponent("archive.tar.xz")
        
        let folderGroups = Dictionary(grouping: sourceURLs) {
            $0.deletingLastPathComponent()
        }
        
        for (folderURL, files) in folderGroups {
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/tar")
            process.currentDirectoryURL = folderURL
            
            let fileNames = files.map(\.lastPathComponent)
            process.arguments = ["-cJf", archiveURL.path] + fileNames
            
            try process.run()
            process.waitUntilExit()
            
            guard process.terminationStatus == 0 else {
                print("tar.xz command failed for folder:", folderURL.path)
                return nil
            }
        }
        
        return archiveURL
    }
}
