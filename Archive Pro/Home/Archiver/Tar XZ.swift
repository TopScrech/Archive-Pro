import Foundation

extension Archiver {
    static func createTarXzArchive(from sourceURLs: [URL], at saveLocation: URL) throws -> URL? {
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
    
    static func extractTarXzArchive(at archiveURL: URL, to saveLocation: URL) throws -> Bool {
        try FileManager.default.createDirectory(at: saveLocation, withIntermediateDirectories: true)
        
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/tar")
        process.arguments = ["-xJf", archiveURL.path, "-C", saveLocation.path]
        
        try process.run()
        process.waitUntilExit()
        
        guard process.terminationStatus == 0 else {
            print("Tar XZ extraction failed")
            return false
        }
        
        return true
    }
}
