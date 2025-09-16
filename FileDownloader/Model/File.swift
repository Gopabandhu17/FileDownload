import Foundation

struct File: Identifiable, Equatable {
    let id = UUID()
    var name: String
    let urlString: String
    let type: FileType
    var downloadPercentageString: String
    
    let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    var filePath: URL {
        documents.appending(path: name).appendingPathExtension(type.extensionName)
    }
    var doesExist: Bool {
        FileManager.default.fileExists(atPath: filePath.path)
    }
    
}
