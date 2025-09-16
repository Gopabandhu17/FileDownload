//
//  FileDownloaderApp.swift
//  FileDownloader
//
//  Created by Gopabandhu Dash on 13/09/25.
//

import SwiftUI
// https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf
@main
struct FileDownloaderApp: App {
    var body: some Scene {
        WindowGroup {
            FileListView()
        }
    }
}
