// TODO: - check if the file is already downloaded, if not then only download - to save memory and time - ✅
// TODO: - show progress bar for download percentage in place of text - ✅
// TODO: - check for background mode download support -
// TODO: - if download already completed, on luanch show the file status downloaded and on click of perticular file open it up
// TODO: - pause, cancel, restart a specific line item

// File path sample - file:///Users/dashgopabandhu/Library/Developer/CoreSimulator/Devices/6118F3E3-4B8B-422C-A460-44A655EB3273/data/Containers/Data/Application/DD8B2820-6193-4BB7-B9DA-EE9576E03A3A/Documents/Dummy%20PDF.pdf

import SwiftUI
import FileDownloadManager

struct FileListView: View {
    
    @StateObject private var viewModel: FileListViewModel = FileListViewModel()
    
    var body: some View {
        ScrollView {
            ZStack {
                VStack {
                    ForEach(viewModel.files) { file in
                        HStack {
                            VStack(alignment: .leading) {
                                filenameView(file)
                                progressBarView(file)
                            }
                            Spacer()
                            downloadButtonView(file)
                        }
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.mint.opacity(0.75))
                        }
                    }
                    multipleDownloadButtonView()
                }
            }
            .padding()
        }
    }
}

extension FileListView {
    @ViewBuilder
    private func fileImageView(_ type: FileType) -> some View {
        switch type {
        case .mp3:
            Image(systemName: "headphones.circle.fill")
        case .mp4:
            Image(systemName: "video.circle.fill")
        case .pdf:
            Image(systemName: "book.circle.fill")
        }
    }
    
    @ViewBuilder
    private func filenameView(_ file: File) -> some View {
        HStack {
            Text(file.name)
                .font(.body)
                .foregroundStyle(Color.white)
            
            fileImageView(file.type)
                .font(.body)
                .foregroundStyle(Color.gray)
        }
    }
    
    @ViewBuilder
    private func progressBarView(_ file: File) -> some View {
        if !file.downloadPercentageString.isEmpty {
            if let percentage = Double(file.downloadPercentageString) {
                HStack(alignment: .top) {
                    ProgressBarView(progress: percentage)
                    Text("\(file.downloadPercentageString)%")
                        .font(.subheadline)
                    Spacer(minLength: 100)
                }
            }
        }
    }
    
    @ViewBuilder
    private func downloadButtonView(_ file: File) -> some View {
        Button {
            viewModel.download(file)
        } label: {
            Image(systemName: "arrow.down.circle.fill")
                .font(.title)
        }
        .disabled(file.doesExist || Int(file.downloadPercentageString) ?? 0 > 0)
        .tint(.white)
    }
    
    @ViewBuilder
    private func multipleDownloadButtonView() -> some View {
        Button {
            viewModel.downloadMultipleFiles()
        } label: {
            Text("Download Multiple Files")
        }
    }
}

#Preview {
    FileListView()
}
