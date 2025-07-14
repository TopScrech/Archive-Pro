import SwiftUI

enum ArchiveFormat: String, Identifiable, CaseIterable {
    case zip, tar,
         tarGz, tarBz2, tarXz,
    cpio
    
    var id: String {
        self.rawValue
    }
}
