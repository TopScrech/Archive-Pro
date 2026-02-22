import ScrechKit

struct SettingsView: View {
    @State private var vm = SettingsVM()
    @EnvironmentObject private var store: ValueStore
    
    var body: some View {
        Form {
            SavingLocationPickerView(savingLocation: $store.savingLocation)
            ArchiveFormatPickerView(archiveFormat: $store.archiveFormat)
            
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
