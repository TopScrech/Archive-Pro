import ScrechKit
import UniformTypeIdentifiers

struct HomeView: View {
    @State private var isTargeted = false
    
    var body: some View {
        VStack {
            if isTargeted {
                Text("Targeted")
            } else {
                
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.blue, in: .rect(cornerRadius: 16))
        .padding()
        .onDrop(of: [.fileURL], isTargeted: $isTargeted) { providers -> Bool in
            handleDrop(providers)
            
            return true
        }
    }
    
    func handleDrop(_ providers: [NSItemProvider]) {
        for provider in providers {
            if let name = provider.suggestedName {
                print("Name:", name)
            }
            
            if provider.canLoadObject(ofClass: URL.self) {
                _ = provider.loadObject(ofClass: URL.self) { url, error in
                    if let url {
                        print("Dropped file URL:", url)
                    }
                }
            }
            
            //if provider.hasItemConformingToTypeIdentifier(type) {
            //    provider.loadDataRepresentation(forTypeIdentifier: type) { data, error in
            //
            //    }
            //}
        }
    }
}

#Preview {
    HomeView()
}
