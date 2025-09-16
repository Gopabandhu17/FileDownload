// TODO: - check if the file is already downloaded, if not then only download - to save memory and time -
// TODO: - show progress bar for download percentage in place of text - ✅
// TODO: - check for background mode download support -
// TODO: - if download already completed, on luanch show the file status downloaded and on click of perticular file open it up
// TODO: - pause, cancel, restart a specific line item

import SwiftUI
import FileDownloadManager

struct FileListView: View {
    
    @StateObject private var viewModel: FileListViewModel = FileListViewModel()
    @State private var progress: String = "0"
    
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
    
    var body: some View {
        ScrollView {
            ZStack {
                VStack {
                    ForEach(viewModel.files) { file in
                        HStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(file.name)
                                        .font(.body)
                                        .foregroundStyle(Color.white)
                                    
                                    fileImageView(file.type)
                                        .font(.body)
                                        .foregroundStyle(Color.gray)
                                }
                                
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
                            
                            Spacer()
                            
                            Button {
                                viewModel.download(file)
                            } label: {
                                Image(systemName: "arrow.down.circle.fill")
                                    .font(.title)
                            }
                            .tint(.white)
                        }
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.mint.opacity(0.75))
                        }
                    }
                    
                    Button {
                        viewModel.downloadMultipleFiles()
                    } label: {
                        Text("Download Multiple Files")
                    }
                }
                
                if progress != "0" && progress != "100" {
                    ProgressView(progress: progress)
                }
            }
            .padding()
        }
    }
}

#Preview {
    FileListView()
}
