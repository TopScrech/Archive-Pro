import Foundation
import OSLog

extension Archiver {
    static func createZipArchive(from sourceURLs: [URL], at saveLocation: URL) throws -> URL? {
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
                Logger().error("Zip command failed for folder: \(folderURL.path)")
                return nil
            }
        }
        
        return archiveURL
    }
    
    static func extractZipArchive(at archiveURL: URL, to saveLocation: URL) throws -> Bool {
        try FileManager.default.createDirectory(at: saveLocation, withIntermediateDirectories: true)
        
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/unzip")
        process.arguments = [archiveURL.path, "-d", saveLocation.path]
        
        try process.run()
        process.waitUntilExit()
        
        guard process.terminationStatus == 0 else {
            Logger().error("Unzip failed with status \(process.terminationStatus)")
            return false
        }
        
        return true
    }
}
