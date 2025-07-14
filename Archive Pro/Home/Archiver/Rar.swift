import Foundation

extension Archiver {
    static func embeddedRarURL() -> URL? {
        Bundle.main.url(forResource: "rar", withExtension: nil)
    }
    
    static func makeExecutable(_ url: URL) throws {
        let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
        
        if (attributes[.posixPermissions] as? Int ?? 0) & 0o111 == 0 {
            try FileManager.default.setAttributes([.posixPermissions: 0o755], ofItemAtPath: url.path)
        }
    }
    
    static func createRarArchive(from sourceURLs: [URL], at saveLocation: URL) throws -> URL? {
        guard let rarURL = embeddedRarURL() else {
            print("Error: Embedded rar not found")
            return nil
        }
        
        try makeExecutable(rarURL)
        
        let archiveURL = saveLocation.appendingPathComponent("archive.rar")
        let folderGroups = Dictionary(grouping: sourceURLs) {
            $0.deletingLastPathComponent()
        }
        
        for (folderURL, files) in folderGroups {
            let process = Process()
            process.executableURL = rarURL
            process.currentDirectoryURL = folderURL
            process.arguments = ["a", "-ep1", archiveURL.path] + files.map(\.lastPathComponent)
            
            try process.run()
            process.waitUntilExit()
            
            guard process.terminationStatus == 0 else {
                print("RAR command failed for folder:", folderURL.path)
                return nil
            }
        }
        
        return archiveURL
    }
    
    //    static func createRarArchive(
    //        from sourceURLs: [URL],
    //        at saveLocation: URL
    //    ) throws -> URL? {
    //
    //        let archiveURL = saveLocation.appendingPathComponent("archive.rar")
    //
    //        let folderGroups = Dictionary(grouping: sourceURLs) {
    //            $0.deletingLastPathComponent()
    //        }
    //
    //        for (folderURL, files) in folderGroups {
    //            let process = Process()
    //            process.executableURL = URL(fileURLWithPath: "/opt/homebrew/bin/rar") // Apple Silicon
    ////            process.executableURL = URL(fileURLWithPath: "/usr/local/bin/rar")
    //            process.currentDirectoryURL = folderURL
    //            process.arguments = ["a", "-ep1", archiveURL.path] + files.map(\.lastPathComponent)
    //
    //            try process.run()
    //            process.waitUntilExit()
    //
    //            guard process.terminationStatus == 0 else {
    //                print("RAR command failed for folder:", folderURL.path)
    //                return nil
    //            }
    //        }
    //
    //        return archiveURL
    //    }
}
