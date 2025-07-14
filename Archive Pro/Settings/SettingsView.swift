import SwiftUI

struct SettingsView: View {
    @State private var vm = SettingsVM()
    
    var body: some View {
        Form {
            Section("Debug") {
                Button {
                    vm.openTmpDir()
                } label: {
                    Label("Open the temporary directory", systemImage: "folder.badge.gearshape")
                }
                
                Button {
                    vm.clearTmpDir()
                } label: {
                    Label("Clear the temporary directory", systemImage: "trash")
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
