import ScrechKit

struct AboutSupportedFormatsTableView: View {
    let title: LocalizedStringResource
    let formats: [SupportedFormatEntry]
    
    var body: some View {
        Section {
            Grid(alignment: .leading, horizontalSpacing: 8, verticalSpacing: 8) {
                GridRow {
                    Text("format")
                        .caption(.semibold)
                        .frame(width: 88, alignment: .leading)
                    
                    Text("zip")
                        .frame(width: 36, alignment: .center)
                    
                    Text("unzip")
                        .frame(width: 48, alignment: .center)
                    
                    Text("details")
                }
                .caption(.semibold)
                .secondary()
                
                ForEach(formats) {
                    AboutSupportedFormatRowView(format: $0)
                }
            }
            .padding(.vertical, 4)
        } header: {
            Text(title)
        }
    }
}

#Preview {
    Form {
        AboutSupportedFormatsTableView(title: "ZIP-based formats", formats: SupportedFormatEntry.zipBased)
    }
}
