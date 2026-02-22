import ScrechKit

struct ArchiveFormatPickerView: View {
    @Binding var archiveFormat: ArchiveFormat
    
    var body: some View {
        Section {
            Picker(selection: $archiveFormat) {
                ForEach(ArchiveFormat.creatableCases) {
                    Text($0.name)
                        .tag($0)
                }
            } label: {
                Label("Archive format", systemImage: "archivebox")
            }
            .pickerStyle(.inline)
        }
    }
}

#Preview {
    Form {
        ArchiveFormatPickerView(archiveFormat: .constant(.zip))
    }
}
