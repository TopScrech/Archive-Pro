import Foundation

extension Archiver {
    static func createTarGzArchive(from sourceURLs: [URL], at saveLocation: URL) throws -> URL? {
        let archiveURL = saveLocation.appendingPathComponent("archive.tar.gz")
        
        let folderGroups = Dictionary(grouping: sourceURLs) {
            $0.deletingLastPathComponent()
        }
        
        for (folderURL, files) in folderGroups {
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/tar")
            process.currentDirectoryURL = folderURL
            
            let fileNames = files.map(\.lastPathComponent)
            process.arguments = ["-czf", archiveURL.path] + fileNames
            
            try process.run()
            process.waitUntilExit()
            
            guard process.terminationStatus == 0 else {
                print("tar.gz command failed for folder:", folderURL.path)
                return nil
            }
        }
        
        return archiveURL
    }
    
    static func extractTarGzArchive(at archiveURL: URL, to saveLocation: URL) throws -> Bool {
        try FileManager.default.createDirectory(at: saveLocation, withIntermediateDirectories: true)
        
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/tar")
        process.arguments = ["-xzf", archiveURL.path, "-C", saveLocation.path]
        
        try process.run()
        process.waitUntilExit()
        
        guard process.terminationStatus == 0 else {
            print("Tar GZ extraction failed")
            return false
        }
        
        return true
    }
}
