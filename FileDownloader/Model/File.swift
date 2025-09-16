import Foundation

struct File: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let urlString: String
    let type: FileType
    var downloadPercentageString: String
}
