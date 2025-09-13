//
//  ContentView.swift
//  FileDownloader
//
//  Created by Gopabandhu Dash on 13/09/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            let options = DownloadOptions(
                destinationURL: documents,
                filename: "DummyFile.pdf",
                overwrite: false,
                headers: [:],
                timeout: 60
            )
            
            let downloader = FileDownloader()
            
            Task {
                do {
                    let url = URL(string: "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf")!
                    let savedURL = try await downloader.download(form: url, options: options) { progress in
                        print(String(format: "Progress: %.0f%%", progress * 100))
                    }
                    print("Saved to: \(savedURL.path())")
                } catch {
                    print("Download failed:", error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
