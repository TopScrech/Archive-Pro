import ScrechKit
import OSLog

@Observable
final class ArchiveVM {
    func isArchive(_ url: URL) -> Bool {
        archiveType(url) != nil
    }
    
    func archiveType(_ url: URL) -> ArchiveFormat? {
        let ext = url.pathExtension.lowercased()
        let parentExt = url.deletingPathExtension().pathExtension.lowercased()
        
        switch ext {
        case "7z": return .sevenZ
        case "aar": return .appleArchive
        case "aea": return .appleEncryptedArchive
        case "cpio": return .cpio
        case "pkg", "xar": return .xar
        case "rar": return .rar
        case "tar": return .tar
        case "tbz2": return .tarBz2
        case "tgz": return .tarGz
        case "txz": return .tarXz
        case "xip": return .xip
        case "zip": return .zip
        case "bz2" where parentExt == "tar": return .tarBz2
        case "gz" where parentExt == "tar": return .tarGz
        case "xz" where parentExt == "tar": return .tarXz
        default: return nil
        }
    }
    
    func unarchive(
        at archiveURL: URL,
        to saveLocation: URL,
        password: String? = nil
    ) throws -> URL? {
        
        switch archiveType(archiveURL) {
        case .sevenZ: if try Archiver.extract7zArchive(at: archiveURL, to: saveLocation) { return saveLocation }
        case .zip: if try Archiver.extractZipArchive(at: archiveURL, to: saveLocation) { return saveLocation }
        case .rar: if try Archiver.extractRarArchive(at: archiveURL, to: saveLocation) { return saveLocation }
        case .tar: if try Archiver.extractTarArchive(at: archiveURL, to: saveLocation) { return saveLocation }
        case .tarGz: if try Archiver.extractTarGzArchive(at: archiveURL, to: saveLocation) { return saveLocation }
        case .tarBz2: if try Archiver.extractTarBz2Archive(at: archiveURL, to: saveLocation) { return saveLocation }
        case .tarXz: if try Archiver.extractTarXzArchive(at: archiveURL, to: saveLocation) { return saveLocation }
        case .cpio: if try Archiver.extractCpioArchive(at: archiveURL, to: saveLocation) { return saveLocation }
        case .appleArchive: if try Archiver.extractAppleArchive(at: archiveURL, to: saveLocation) { return saveLocation }
        case .appleEncryptedArchive:
            if try Archiver.extractAppleEncryptedArchive(
                at: archiveURL,
                to: saveLocation,
                password: password ?? ""
            ) {
                return saveLocation
            }
        case .xar: if try Archiver.extractXarArchive(at: archiveURL, to: saveLocation) { return saveLocation }
        case .xip: if try Archiver.extractXipArchive(at: archiveURL, to: saveLocation) { return saveLocation }
        default: return nil
        }
        
        return nil
    }
    
    func createArchive(
        from sourceURLs: [URL],
        at saveLocation: URL,
        password: String? = nil
    ) throws -> URL? {
        
        switch ValueStore().archiveFormat {
        case .tar: try Archiver.createTarArchive(from: sourceURLs, at: saveLocation)
        case .zip: try Archiver.createZipArchive(from: sourceURLs, at: saveLocation)
        case .tarGz: try Archiver.createTarGzArchive(from: sourceURLs, at: saveLocation)
        case .tarBz2: try Archiver.createTarBz2Archive(from: sourceURLs, at: saveLocation)
        case .tarXz: try Archiver.createTarXzArchive(from: sourceURLs, at: saveLocation)
        case .cpio: try Archiver.createCpioArchive(from: sourceURLs, at: saveLocation)
        case .rar: try Archiver.createRarArchive(from: sourceURLs, at: saveLocation)
        case .sevenZ: try Archiver.create7zArchive(from: sourceURLs, at: saveLocation)
        case .appleArchive: try Archiver.createAppleArchive(from: sourceURLs, at: saveLocation)
        case .appleEncryptedArchive: try Archiver.createAppleEncryptedArchive(
            from: sourceURLs,
            at: saveLocation,
            password: password ?? ""
        )
        case .xar: try Archiver.createXarArchive(from: sourceURLs, at: saveLocation)
        case .xip: nil
        }
    }
    
    func getSaveLocation() -> URL? {
        switch ValueStore().savingLocation {
        case .tmpDir:
            createTmpDir()
            
        case .downloads:
            URL.downloadsDirectory
        }
    }
    
    private func isDirectory(_ url: URL) -> Bool {
        let fm = FileManager.default
        var isDir: ObjCBool = false
        
        fm.fileExists(
            atPath: url.path,
            isDirectory: &isDir
        )
        
        return isDir.boolValue
    }
    
    func fileSize(_ url: URL) {
        let fm = FileManager.default
        
        let attributes = try? fm.attributesOfItem(atPath: url.path)
        let size = attributes?[.size] as? Int ?? 0
        
        print(formatBytes(size))
        //        return formatBytes(size)
    }
    
    func createTmpDir() -> URL? {
        let fm = FileManager.default
        let name = UUID().uuidString
        
        let tmpDir = fm.temporaryDirectory.appendingPathComponent(name)
        
        do {
            try fm.createDirectory(
                at: tmpDir,
                withIntermediateDirectories: true
            )
            
            return tmpDir
        } catch {
            Logger().error("\(error)")
            return nil
        }
    }
}
