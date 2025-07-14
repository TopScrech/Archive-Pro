import SwiftUI
import Combine

final class ValueStore: ObservableObject {
    @AppStorage("save_loc") var savingLocation: SavingLocation = .tmpDir
}
