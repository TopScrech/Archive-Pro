import SwiftUI

struct SettingsView: View {
    @State private var vm = SettingsVM()
    @EnvironmentObject private var store: ValueStore
    
    var body: some View {
        Form {
            Section {
                Picker(selection: $store.savingLocation) {
                    ForEach(SavingLocation.allCases) { loc in
                        Text(loc.name)
                            .tag(loc)
                    }
                } label: {
                    Label("Saving location", systemImage: "folder")
                }
                .pickerStyle(.inline)
            }
            
            Section {
                Picker(selection: $store.archiveFormat) {
                    ForEach(ArchiveFormat.allCases) { format in
                        Text(format.name)
                            .tag(format)
                    }
                } label: {
                    Label("Archive format", systemImage: "archivebox")
                }
                .pickerStyle(.inline)
            }
            
            Section("Debug") {
                Button {
                    vm.openTmpDir()
                } label: {
                    Label("Open the temporary directory", systemImage: "folder.badge.gearshape")
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(ValueStore())
}
