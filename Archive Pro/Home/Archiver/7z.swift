import Foundation

extension Archiver {
    static func embedded7zzURL() -> URL? {
        Bundle.main.url(forResource: "7zz", withExtension: nil)
    }
    
    static func create7zArchive(
        from sourceURLs: [URL],
        at saveLocation: URL
    ) throws -> URL? {
        
        guard let sevenZURL = embedded7zzURL() else {
            print("Error: Embedded 7zz not found")
            return nil
        }
        
        try makeExecutable(sevenZURL)
        
        let archiveURL = saveLocation.appendingPathComponent("archive.7z")
        
        let folderGroups = Dictionary(grouping: sourceURLs) {
            $0.deletingLastPathComponent()
        }
        
        for (folderURL, files) in folderGroups {
            let process = Process()
            process.executableURL = sevenZURL
            process.currentDirectoryURL = folderURL
            process.arguments = ["a", archiveURL.path] + files.map(\.lastPathComponent)
            
            try process.run()
            process.waitUntilExit()
            
            guard process.terminationStatus == 0 else {
                print("7zz command failed for folder:", folderURL.path)
                return nil
            }
        }
        
        return archiveURL
    }
    
    static func extract7zArchive(
        at archiveURL: URL,
        to saveLocation: URL
    ) throws -> Bool {
        
        guard let sevenZURL = embedded7zzURL() else {
            print("Error: Embedded 7zz not found")
            return false
        }
        
        try makeExecutable(sevenZURL)
        
        let process = Process()
        process.executableURL = sevenZURL
        process.currentDirectoryURL = saveLocation.deletingLastPathComponent()
        process.arguments = ["x", archiveURL.path, "-o" + saveLocation.path, "-y"]
        
        try process.run()
        process.waitUntilExit()
        
        guard process.terminationStatus == 0 else {
            print("7zz extraction failed")
            return false
        }
        
        return true
    }
}
