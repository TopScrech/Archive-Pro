import SwiftUI

struct NavDetail: View {
    @Environment(NavModel.self) private var nav
    
    var body: some View {
        Group {
            switch nav.selectedCategory {
            case .home:
                HomeView()
                
            case .settings:
                SettingsView()
                
            case .about:
                AboutView()
                
            default:
                Text("Choose a tab from the sidebar")
            }
        }
        .navigationSubtitle(nav.selectedCategory?.name ?? "")
        .formStyle(.grouped)
        .buttonStyle(.plain)
        .scrollIndicators(.never)
    }
}

#Preview {
    NavDetail()
        .environment(NavModel())
}
