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
    
    func download(for file: File) {
        
        DownloadManager.shared.setMaxConcurrentDownloads(6)
        
        guard let index = index(of: file),
              let url = URL(string: file.urlString) else { return }
        
        switch file.status {
        case .inProgress, .completed:
            return
        default:
            break
        }
        
        update(index: index) { file in
            file.downloadPercentageString = "0%"
            file.status = .inProgress
        }
        
        let options = DownloadOptions(
            destinationURL: documents,
            filename: "\(file.name).\(file.type.extensionName)",
            overwrite: true,
            headers: [:],
            timeout: 60
        )
        
        DownloadManager.shared.startDownload(from: url, options: options) { progress in
            let progressString = String(format: "%.0f", progress * 100)
            self.update(index: index) { file in
                file.downloadPercentageString = progressString
                file.status = .inProgress
            }
        } completion: { [weak self] result in
            guard let self,
                  let innnerIndex = self.index(of: file) else { return }
            switch result {
            case .success(let fileURL):
                self.update(index: innnerIndex) { file in
                    file.downloadPercentageString = "100%"
                    file.status = .completed
                }
            case .failure(let error):
                print("Failed to download file: \(error.localizedDescription)")
            }
        }
    }
    
    func pauseDownload(for file: File) {
        guard let url = URL(string: file.urlString),
              let index = index(of: file) else { return }
        DownloadManager.shared.pauseDownload(for: url)
        update(index: index) { $0.status = .pause }
    }
    
    func resumeDownload(for file: File) {
        guard let url = URL(string: file.urlString),
              let index = index(of: file) else { return }
        DownloadManager.shared.resumeDownload(for: url)
        update(index: index) { $0.status = .inProgress }
    }
    
    private func index(of file: File) -> Int? {
        files.firstIndex { $0.id == file.id }
    }
    
    private func update(index: Int, mutate: (inout File) -> Void) {
        var file = files[index]
        mutate(&file)
        DispatchQueue.main.async {
            self.files[index] = file
        }
    }
    
    func downloadMultipleFiles() {
        
        // This tell the queue how many files can download at once
        queue.maxConcurrentOperationCount = 2
        
        // filter file those are not downloaded yet and add to the queue to download
        let filesToDownload = files.filter { !$0.doesExist }.map { $0 }
        
        for file in filesToDownload {
            let options = DownloadOptions(
                destinationURL: documents,
                filename: "\(file.name).\(file.type.extensionName)",
                overwrite: true,
                headers: [:],
                timeout: 120
            )
            
            let operation = DownloadOperation(
                url: URL(string: file.urlString)!,
                options: options,
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
                
        FileDownloadManager.shared.download(from: URL(string: file.urlString)!, options: options) { progress in
            let progressString = String(format: "%.0f", progress * 100)
            DispatchQueue.main.async {
                if let index = self.files.firstIndex(where: { $0.id == file.id }) {
                    var updated = self.files
                    updated[index].downloadPercentageString = progressString
                    self.files = updated
                }
            }
        } onCompletion: { result in
            switch result {
            case .success(let fileURL):
                print("Saved to: \(fileURL)")
                // TODO: - updating the file name of a file forcefully because somehow after completion of 100% progress download button is not getting disabled, this will be fixed later
                DispatchQueue.main.async {
                    if let index = self.files.firstIndex(where: { $0.id == file.id }) {
                        var updated = self.files
                        updated[index].name = file.name
                        self.files = updated
                    }
                }
            case .failure(let error):
                print("Download failed with error: \(error.localizedDescription)")
            }
        }
    }
}

