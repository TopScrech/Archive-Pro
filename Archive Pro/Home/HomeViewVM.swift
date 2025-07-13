import ScrechKit

@Observable
final class HomeViewVM {
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
