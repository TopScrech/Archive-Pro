import Foundation

extension Archiver {
    static func createZipArchive(
        from sourceURLs: [URL],
        at saveLocation: URL
    ) throws -> URL? {
        
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
}
