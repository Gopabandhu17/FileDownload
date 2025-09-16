import Foundation

enum FileType {
    case mp3, mp4, pdf
    
    var extensionName: String {
        switch self {
        case .mp3:
            "mp3"
        case .mp4:
            "mp4"
        case .pdf:
            "pdf"
        }
    }
}
