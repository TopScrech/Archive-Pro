import SwiftUI

struct SidebarLink: View {
    private let tab: NavDestination
    
    init(_ tab: NavDestination) {
        self.tab = tab
    }
    
    var body: some View {
        NavigationLink(value: tab) {
            Label(tab.name, systemImage: tab.icon)
        }
    }
}

//#Preview {
//    SidebarLink()
//}
