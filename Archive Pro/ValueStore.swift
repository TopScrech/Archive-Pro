import SwiftUI
import Combine

final class ValueStore: ObservableObject {
    @AppStorage("save_loc") var savingLocation: SavingLocation = .downloads
    @AppStorage("archive_format") var archiveFormat: ArchiveFormat = .zip
}
