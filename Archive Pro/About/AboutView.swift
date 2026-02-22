import SwiftUI

struct AboutView: View {
    var body: some View {
        Form {
            Section {
                LabeledContent("Supported formats") {
                    Text("\(SupportedFormatEntry.allFormats.count)")
                        .monospacedDigit()
                }
                
                LabeledContent("Can zip") {
                    Text("\(SupportedFormatEntry.allFormats.filter(\.canCreate).count)")
                        .monospacedDigit()
                }
                
                LabeledContent("Can unzip") {
                    Text("\(SupportedFormatEntry.allFormats.filter(\.canExtract).count)")
                        .monospacedDigit()
                }
            }
            
            AboutSupportedFormatsTableView(
                title: "Non-zip-based formats",
                formats: SupportedFormatEntry.nonZipBased
            )
            
            AboutSupportedFormatsTableView(
                title: "ZIP-based formats",
                formats: SupportedFormatEntry.zipBased
            )
        }
    }
}

#Preview {
    AboutView()
}
