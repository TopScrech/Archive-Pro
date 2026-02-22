import Foundation
import OSLog

extension Archiver {
    static func createGzipArchive(from sourceURLs: [URL], at saveLocation: URL) throws -> URL? {
        guard sourceURLs.count == 1, let sourceURL = sourceURLs.first else {
            Logger().error("Gzip supports exactly one source item")
            return nil
        }
        
        var isDirectory = ObjCBool(false)
        
        guard
            FileManager.default.fileExists(atPath: sourceURL.path, isDirectory: &isDirectory),
            !isDirectory.boolValue
        else {
            Logger().error("Gzip supports file input only")
            return nil
        }
        
        try FileManager.default.createDirectory(at: saveLocation, withIntermediateDirectories: true)
        
        let archiveURL = saveLocation.appendingPathComponent("archive.gz")
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: archiveURL.path) {
            try fileManager.removeItem(at: archiveURL)
        }
        
        _ = fileManager.createFile(atPath: archiveURL.path, contents: nil)
        
        let outputFileHandle = try FileHandle(forWritingTo: archiveURL)
        
        defer {
            try? outputFileHandle.close()
        }
        
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/gzip")
        process.arguments = ["-c", sourceURL.path]
        process.standardOutput = outputFileHandle
        
        try process.run()
        process.waitUntilExit()
        
        guard process.terminationStatus == 0 else {
            Logger().error("Gzip failed with status \(process.terminationStatus)")
            try? fileManager.removeItem(at: archiveURL)
            return nil
        }
        
        return archiveURL
    }
}
