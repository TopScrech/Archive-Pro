import Foundation

struct Archiver {
    static func makeExecutable(_ url: URL) throws {
        let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
        
        if (attributes[.posixPermissions] as? Int ?? 0) & 0o111 == 0 {
            try FileManager.default.setAttributes([.posixPermissions: 0o755], ofItemAtPath: url.path)
        }
    }
}

extension Archiver {
    static func createAppleArchive(
        from sourceURLs: [URL],
        at saveLocation: URL
    ) throws -> URL? {
        
        guard !sourceURLs.isEmpty else {
            return nil
        }
        
        let fm = FileManager.default
        try fm.createDirectory(at: saveLocation, withIntermediateDirectories: true)
        
        let archiveURL = saveLocation.appendingPathComponent("archive.aar")
        let folderGroups = Dictionary(grouping: sourceURLs) {
            $0.deletingLastPathComponent()
        }
        
        let sortedFolders = folderGroups.keys.sorted { $0.path < $1.path }
        var isFirst = true
        
        for folderURL in sortedFolders {
            guard let files = folderGroups[folderURL] else {
                continue
            }
            
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/aa")
            
            var arguments = [
                isFirst ? "archive" : "append",
                "-d", folderURL.path,
                "-o", archiveURL.path
            ]
            
            for file in files {
                arguments.append(contentsOf: ["-include-path", file.lastPathComponent])
            }
            
            process.arguments = arguments
            
            try process.run()
            process.waitUntilExit()
            
            guard process.terminationStatus == 0 else {
                print("Apple Archive command failed for folder:", folderURL.path)
                return nil
            }
            
            isFirst = false
        }
        
        return isFirst ? nil : archiveURL
    }
    
    static func extractAppleArchive(
        at archiveURL: URL,
        to saveLocation: URL
    ) throws -> Bool {
        
        try FileManager.default.createDirectory(at: saveLocation, withIntermediateDirectories: true)
        
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/aa")
        process.arguments = ["extract", "-i", archiveURL.path, "-d", saveLocation.path]
        
        try process.run()
        process.waitUntilExit()
        
        guard process.terminationStatus == 0 else {
            print("Apple Archive extraction failed")
            return false
        }
        
        return true
    }
    
    static func createAppleEncryptedArchive(
        from sourceURLs: [URL],
        at saveLocation: URL,
        password: String
    ) throws -> URL? {
        
        guard !sourceURLs.isEmpty else {
            return nil
        }
        
        guard password.count >= 20 else {
            print("Apple Encrypted Archive password must be at least 20 characters")
            return nil
        }
        
        let fm = FileManager.default
        try fm.createDirectory(at: saveLocation, withIntermediateDirectories: true)
        
        let archiveURL = saveLocation.appendingPathComponent("archive.aea")
        let folderGroups = Dictionary(grouping: sourceURLs) {
            $0.deletingLastPathComponent()
        }
        
        let sortedFolders = folderGroups.keys.sorted { $0.path < $1.path }
        var isFirst = true
        
        for folderURL in sortedFolders {
            guard let files = folderGroups[folderURL] else {
                continue
            }
            
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/aa")
            
            var arguments = [
                isFirst ? "archive" : "append",
                "-d", folderURL.path,
                "-o", archiveURL.path,
                "-password-value", password
            ]
            
            for file in files {
                arguments.append(contentsOf: ["-include-path", file.lastPathComponent])
            }
            
            process.arguments = arguments
            
            try process.run()
            process.waitUntilExit()
            
            guard process.terminationStatus == 0 else {
                print("Apple Encrypted Archive command failed for folder:", folderURL.path)
                return nil
            }
            
            isFirst = false
        }
        
        return isFirst ? nil : archiveURL
    }
    
    static func extractAppleEncryptedArchive(
        at archiveURL: URL,
        to saveLocation: URL,
        password: String
    ) throws -> Bool {
        
        guard password.count >= 20 else {
            print("Apple Encrypted Archive password must be at least 20 characters")
            return false
        }
        
        try FileManager.default.createDirectory(at: saveLocation, withIntermediateDirectories: true)
        
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/aa")
        process.arguments = [
            "extract",
            "-i", archiveURL.path,
            "-d", saveLocation.path,
            "-password-value", password
        ]
        
        try process.run()
        process.waitUntilExit()
        
        guard process.terminationStatus == 0 else {
            print("Apple Encrypted Archive extract failed")
            return false
        }
        
        return true
    }
    
    static func createXarArchive(
        from sourceURLs: [URL],
        at saveLocation: URL
    ) throws -> URL? {
        
        guard !sourceURLs.isEmpty else {
            return nil
        }
        
        let fm = FileManager.default
        try fm.createDirectory(at: saveLocation, withIntermediateDirectories: true)
        
        let archiveURL = saveLocation.appendingPathComponent("archive.xar")
        let folderGroups = Dictionary(grouping: sourceURLs) {
            $0.deletingLastPathComponent()
        }
        
        let sortedFolders = folderGroups.keys.sorted { $0.path < $1.path }
        var isFirst = true
        
        for folderURL in sortedFolders {
            guard let files = folderGroups[folderURL] else {
                continue
            }
            
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/xar")
            process.currentDirectoryURL = folderURL
            process.arguments = ["-cf", archiveURL.path] + files.map(\.lastPathComponent)
            
            try process.run()
            process.waitUntilExit()
            
            guard process.terminationStatus == 0 else {
                print("XAR command failed for folder:", folderURL.path)
                return nil
            }
            
            isFirst = false
        }
        
        return isFirst ? nil : archiveURL
    }
    
    static func extractXarArchive(
        at archiveURL: URL,
        to saveLocation: URL
    ) throws -> Bool {
        
        try FileManager.default.createDirectory(at: saveLocation, withIntermediateDirectories: true)
        
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/xar")
        process.arguments = ["-xf", archiveURL.path, "-C", saveLocation.path]
        
        try process.run()
        process.waitUntilExit()
        
        guard process.terminationStatus == 0 else {
            print("XAR extraction failed")
            return false
        }
        
        return true
    }
    
    static func extractXipArchive(
        at archiveURL: URL,
        to saveLocation: URL
    ) throws -> Bool {
        
        try FileManager.default.createDirectory(at: saveLocation, withIntermediateDirectories: true)
        
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/xip")
        process.currentDirectoryURL = saveLocation
        process.arguments = ["--expand", archiveURL.path]
        
        try process.run()
        process.waitUntilExit()
        
        guard process.terminationStatus == 0 else {
            print("XIP extraction failed")
            return false
        }
        
        return true
    }
}
