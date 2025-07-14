import ScrechKit
import UniformTypeIdentifiers

struct HomeView: View {
    @State private var vm = HomeViewVM()
    
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
        .onDrop(of: [.fileURL], isTargeted: $isTargeted) { providers in
            vm.handleDrop(providers)
            
            return true
        }
    }
}

#Preview {
    HomeView()
}
