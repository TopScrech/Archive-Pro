import SwiftUI

enum NavDestination: String, Identifiable, CaseIterable, Codable {
    case home, settings, about
    
    var id: String {
        rawValue
    }
    
    var name: LocalizedStringKey {
        switch self {
        case .home:     "Home"
        case .settings: "Settings"
        case .about:    "About"
        }
    }
    
    var icon: String {
        switch self {
        case .home:     "house"
        case .settings: "gear"
        case .about:    "info.circle"
        }
    }
}
