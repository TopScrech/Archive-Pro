import ScrechKit

struct SavingLocationPickerView: View {
    @Binding var savingLocation: SavingLocation
    
    var body: some View {
        Section {
            Picker(selection: $savingLocation) {
                ForEach(SavingLocation.allCases) {
                    Text($0.name)
                        .tag($0)
                }
            } label: {
                Label("Saving location", systemImage: "folder")
            }
            .pickerStyle(.inline)
        }
    }
}

#Preview {
    Form {
        SavingLocationPickerView(savingLocation: .constant(.downloads))
    }
}
