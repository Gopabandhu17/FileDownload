import SwiftUI
import FileDownloadManager

// PDF - https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf
// MP4 - https://www.w3schools.com/html/mov_bbb.mp4
// MP3 - https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3

// MP4 to download - sample videos
// video 1 - https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4
// video 2 - https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4
// video 3 - https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4

final class FileListViewModel: ObservableObject {
    var operations: [DownloadOperation] = []
    let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let queue = OperationQueue()
    
    @Published var files: [File] = [
        File(
            name: "Dummy PDF",
            urlString: "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",
            type: .pdf,
            downloadPercentageString: ""
        ),
        File(
            name: "Hungry Rabbit",
            urlString: "https://www.w3schools.com/html/mov_bbb.mp4",
            type: .mp4,
            downloadPercentageString: ""
        ),
        File(
            name: "Sound Helix",
            urlString: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
            type: .mp3,
            downloadPercentageString: ""
        ),
        File(
            name: "Big Buck Bunny",
            urlString: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
            type: .mp4,
            downloadPercentageString: ""
        ),
        File(
            name: "Sintel",
            urlString: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4",
            type: .mp4,
            downloadPercentageString: ""
        ),
        File(
            name: "Elephants Dream",
            urlString: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
            type: .mp4,
            downloadPercentageString: ""
        )
    ]
    
    func downloadMultipleFiles() {
        
        // This tell the queue how many files can download at once
        queue.maxConcurrentOperationCount = 2
        
        for file in files {
            let options = DownloadOptions(
                destinationURL: documents,
                filename: "\(file.name).\(file.type.extensionName)",
                overwrite: true,
                headers: [:],
                timeout: 120
            )
            
            let downloader = FileDownloadManager()
            let operation = DownloadOperation(
                url: URL(string: file.urlString)!,
                options: options,
                downloader: downloader,
                progress: { progress in
                    let progressString = String(format: "%.0f", progress * 100)
                    DispatchQueue.main.async {
                        if let index = self.files.firstIndex(where: { $0.id == file.id }) {
                            var updated = self.files
                            updated[index].downloadPercentageString = progressString
                            self.files = updated
                        }
                    }
                },
                completion: { result in
                    switch result {
                    case .success(let fileURL):
                        print("Downloaded to path: \(fileURL.path())")
                    case .failure(let error):
                        print("Download failed with error: \(error.localizedDescription)")
                    }
                },
                maxRetries: 2)
            
            self.operations.append(operation)
            self.queue.addOperation(operation)
        }
    }
    
    func download(_ file: File) {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let options = DownloadOptions(
            destinationURL: documents,
            filename: "\(file.name).\(file.type.extensionName)",
            overwrite: false,
            headers: [:],
            timeout: 60
        )
        
        let downloader = FileDownloadManager()
        
        downloader.download(from: URL(string: file.urlString)!, options: options) { progress in
            print(String(format: "Progress: %.0f", progress * 100))
        } onCompletion: { result in
            switch result {
            case .success(let fileURL):
                print("Saved to: \(fileURL)")
            case .failure(let error):
                print("Download failed with error: \(error.localizedDescription)")
            }
        }
    }
}

