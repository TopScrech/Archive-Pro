import Foundation

extension Archiver {
    static func createCpioArchive(
        from sourceURLs: [URL],
        at saveLocation: URL
    ) throws -> URL? {
        
        let archiveURL = saveLocation.appendingPathComponent("archive.cpio")
        
        let folderGroups = Dictionary(grouping: sourceURLs) {
            $0.deletingLastPathComponent()
        }
        
        for (folderURL, files) in folderGroups {
            let fileNames = files.map(\.lastPathComponent)
            let command = "echo \(fileNames.joined(separator: " ")) | tr ' ' '\\n' | cpio -o > \(archiveURL.path.escapedShellArg())"
            
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/bin/sh")
            process.arguments = ["-c", command]
            process.currentDirectoryURL = folderURL
            
            try process.run()
            process.waitUntilExit()
            
            guard process.terminationStatus == 0 else {
                print("cpio command failed for folder:", folderURL.path)
                return nil
            }
        }
        
        return archiveURL
    }
}

fileprivate extension String {
    func escapedShellArg() -> String {
        "'\(self.replacingOccurrences(of: "'", with: "'\"'\"'"))'"
    }
}
