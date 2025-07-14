import SwiftUI

enum ArchiveFormat: String, Identifiable, CaseIterable {
    case zip, tar,
         tarGz, tarBz2, tarXz,
         cpio, rar, sevenZ
    
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
        case .cpio: "Cpio"
        case .rar: "Rar"
        case .sevenZ: "7z"
        }
    }
}
