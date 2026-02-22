import ScrechKit

struct AboutSupportedFormatRowView: View {
    let format: SupportedFormatEntry
    
    var body: some View {
        GridRow {
            Text(format.shortName)
                .monospaced()
                .frame(width: 88, alignment: .leading)
            
            Text(format.canCreate ? "✅" : "")
                .frame(width: 36, alignment: .center)
            
            Text(format.canExtract ? "✅" : "")
                .frame(width: 48, alignment: .center)
            
            Text(format.details)
                .secondary()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    AboutSupportedFormatRowView(
        format: .init("zip", details: "ZIP archive", canCreate: true, canExtract: true)
    )
}
