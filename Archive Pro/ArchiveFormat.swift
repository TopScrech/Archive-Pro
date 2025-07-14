import SwiftUI

enum ArchiveFormat: String, Identifiable, CaseIterable {
    case zip, tar,
         tarGz, tarBz2, tarXz,
         cpio, rar
    
    var id: String {
        self.rawValue
    }
}
