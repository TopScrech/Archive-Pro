import ScrechKit

struct SettingsView: View {
    @State private var vm = SettingsVM()
    @EnvironmentObject private var store: ValueStore
    
    var body: some View {
        Form {
            Section {
                Picker(selection: $store.savingLocation) {
                    ForEach(SavingLocation.allCases) {
                        Text($0.name)
                            .tag($0)
                    }
                } label: {
                    Label("Saving location", systemImage: "folder")
                }
                .pickerStyle(.inline)
            }
            
            Section {
                Picker(selection: $store.archiveFormat) {
                    ForEach(ArchiveFormat.creatableCases) {
                        Text($0.name)
                            .tag($0)
                    }
                } label: {
                    Label("Archive format", systemImage: "archivebox")
                }
                .pickerStyle(.inline)
            }
            
            Section("Debug") {
                Button("Open the temporary directory", systemImage: "folder.badge.gearshape", action: vm.openTmpDir)
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(ValueStore())
}
