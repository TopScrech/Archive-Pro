import SwiftUI

struct Sidebar: View {
    @Environment(NavModel.self) private var nav
    
    var body: some View {
        @Bindable var nav = nav
        
        List(selection: $nav.selectedCategory) {
            ForEach(NavDestination.allCases) {
                SidebarLink($0)
            }
        }
        .scrollIndicators(.never)
    }
}

#Preview {
    Sidebar()
        .environment(NavModel())
}
