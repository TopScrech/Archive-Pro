import ScrechKit
import UniformTypeIdentifiers

struct HomeView: View {
    @State private var archiveVM = ArchiveVM()
    
    @State private var isTargeted = false
    
    var body: some View {
        VStack {
            if isTargeted {
                Text("Targeted")
            } else {
                Text("Drag & Drop any files or folders here")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.blue, in: .rect(cornerRadius: 20))
        .padding(8)
        .onDrop(of: [.fileURL], isTargeted: $isTargeted) { providers in
            archiveVM.handleDrop(providers)
            
            return true
        }
    }
}

#Preview {
    HomeView()
}
