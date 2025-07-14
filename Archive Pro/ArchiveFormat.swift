import SwiftUI

enum ArchiveFormat: String, Identifiable, CaseIterable {
    case zip, tar
    
    var id: String {
        self.rawValue
    }
}
