import SwiftUI

enum SavingLocation: String, Identifiable, CaseIterable {
    case tmpDir, downloads
    
    var name: LocalizedStringKey {
        switch self {
        case .tmpDir: "Temporary Directory"
        case .downloads: "Downloads"
        }
    }
    
    var id: String {
        self.rawValue
    }
}
