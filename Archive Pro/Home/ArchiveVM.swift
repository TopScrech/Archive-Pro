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
        case "7z", "ar", "arj", "cab", "chm", "cramfs", "deb", "dmg", "fat", "hfs", "img", "iso", "lzh", "msi", "ntfs", "qcow", "qcow2", "rpm", "squashfs", "udf", "vdi", "vhd", "vhdx", "vmdk", "wim", "z", "zst": return .sevenZ
        case "apk", "appx", "cbz", "docx", "ear", "epub", "ipa", "jar", "odp", "ods", "odt", "pptx", "vsix", "war", "whl", "xlsx": return .zip
        case "aar": return archiveTypeForAar(url)
        case "aea": return .appleEncryptedArchive
        case "cpio": return .cpio
        case "pkg", "xar": return .xar
        case "rar": return .rar
        case "tar": return .tar
        case "taz": return .tarGz
        case "tbz": return .tarBz2
        case "tbz2": return .tarBz2
        case "tgz": return .tarGz
        case "tlz", "tlzma": return .tarLzma
        case "txz": return .tarXz
        case "xip": return .xip
        case "zip": return .zip
        case "lzma" where parentExt == "tar": return .tarLzma
        case "bz2" where parentExt == "tar": return .tarBz2
        case "gz" where parentExt == "tar": return .tarGz
        case "xz" where parentExt == "tar": return .tarXz
        case "bz2", "gz", "lzma", "xz": return .sevenZ
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
        case .tarLzma: if try Archiver.extractTarLzmaArchive(at: archiveURL, to: saveLocation) { return saveLocation }
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
        case .gzip: try Archiver.createGzipArchive(from: sourceURLs, at: saveLocation)
        case .tarGz: try Archiver.createTarGzArchive(from: sourceURLs, at: saveLocation)
        case .tarBz2: try Archiver.createTarBz2Archive(from: sourceURLs, at: saveLocation)
        case .tarXz: try Archiver.createTarXzArchive(from: sourceURLs, at: saveLocation)
        case .tarLzma: try Archiver.createTarLzmaArchive(from: sourceURLs, at: saveLocation)
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

    private func archiveTypeForAar(_ url: URL) -> ArchiveFormat {
        looksLikeZipContainer(url) ? .zip : .appleArchive
    }

    private func looksLikeZipContainer(_ url: URL) -> Bool {
        guard let magic = fileMagic(for: url) else {
            return false
        }

        return magic == [0x50, 0x4B, 0x03, 0x04]
            || magic == [0x50, 0x4B, 0x05, 0x06]
            || magic == [0x50, 0x4B, 0x07, 0x08]
    }

    private func fileMagic(for url: URL) -> [UInt8]? {
        guard let fileHandle = try? FileHandle(forReadingFrom: url) else {
            return nil
        }

        defer {
            try? fileHandle.close()
        }

        guard
            let data = try? fileHandle.read(upToCount: 4),
            data.count == 4
        else {
            return nil
        }

        return [UInt8](data)
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
