import Foundation

struct Archiver {
    static func makeExecutable(_ url: URL) throws {
        let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
        
        if (attributes[.posixPermissions] as? Int ?? 0) & 0o111 == 0 {
            try FileManager.default.setAttributes([.posixPermissions: 0o755], ofItemAtPath: url.path)
        }
    }
}
