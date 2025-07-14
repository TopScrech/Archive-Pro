import SwiftUI

enum ArchiveFormat: String, Identifiable, CaseIterable {
    case zip, tar,
         tarGz, tarBz2
    
    var id: String {
        self.rawValue
    }
}
