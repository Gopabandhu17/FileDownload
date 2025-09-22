import Foundation

enum DownloadStatus: Equatable {
    case notStarted, inProgress, pause, cancelled, completed
}

struct File: Identifiable, Equatable {
    let id = UUID()
    var name: String
    let urlString: String
    let type: FileType
    var downloadPercentageString: String
    var status: DownloadStatus = .notStarted
    
    let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    var filePath: URL {
        documents.appending(path: name).appendingPathExtension(type.extensionName)
    }
    var doesExist: Bool {
        FileManager.default.fileExists(atPath: filePath.path)
    }
}
