import SwiftUI

enum ArchiveFormat: String, Identifiable, CaseIterable {
    case zip, tar, tarGz, tarBz2, tarXz, tarLzma, cpio, rar, sevenZ, appleArchive, appleEncryptedArchive, xar, xip
    
    var id: String {
        self.rawValue
    }
    
    var name: String {
        switch self {
        case .zip: "Zip"
        case .tar: "Tar"
        case .tarGz: "Tar GZ"
        case .tarBz2: "Tar BZ2"
        case .tarXz: "Tar XZ"
        case .tarLzma: "Tar LZMA"
        case .cpio: "Cpio"
        case .rar: "Rar"
        case .sevenZ: "7z"
        case .appleArchive: "Apple Archive"
        case .appleEncryptedArchive: "Apple Encrypted Archive"
        case .xar: "XAR"
        case .xip: "XIP"
        }
    }
    
    var canCreate: Bool {
        switch self {
        case .xip: false
        default: true
        }
    }
    
    static var creatableCases: [ArchiveFormat] {
        allCases.filter(\.canCreate)
    }
}
