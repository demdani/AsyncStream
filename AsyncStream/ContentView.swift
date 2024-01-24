//
//  ContentView.swift
//  AsyncStream
//
//  Created by Demjén Dániel on 13/01/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showProgress = false
    @State private var downloadAmount = 0.0
    @State private var downloadFileName = ""
    @State private var downloadFinished = false
    
    private let files = ["Car.jpg", "Winter.png", "Garden.jpg", "Dog.jpg", "Cat.png"]
    
    private let totalAmount = 5.0
    
    var body: some View {
        VStack {
            ZStack {
                Button("Start downloading") {
                    withAnimation {
                        downloadAmount = 0.0
                        downloadFinished = false
                        downloadFileName = ""
                        showProgress = true
                    }
                }
                
                if showProgress {
                    VStack {
                        ProgressView(value: downloadAmount,
                                     label: { Text("Downloading...") },
                                     currentValueLabel: { Text(downloadFileName) })
                        
//                        ProgressView("Downloading…",
//                                     value: downloadAmount,
//                                     total: totalAmount)
                        
                        if downloadFinished {
                            Button("Done") {
                                withAnimation {
                                    showProgress = false
                                }
                            }
                            .padding(.top)
                        }
                    }
                    .frame(width: 200, height: 200)
                    .background(.white)
                    .cornerRadius(25)
                    .shadow(color: .black.opacity(0.2), radius: 5)
                    .transition(.scale)
                    .onAppear {
                        Task {
                            await startDownloading()
                        }
                    }
                }
            }
        }
    }
    
    private func startDownloading() async {
        let stream = download()
        
        for await fileName in stream {
            downloadAmount += 0.2
            downloadFileName = fileName
            
            if downloadAmount == 1 {
                downloadFileName = "Download completed"
                downloadFinished = true
            }
        }
        
//        Timer.scheduledTimer(withTimeInterval: 0.5,
//                             repeats: true) { timer in
//            
//            downloadAmount += 1
//
//            if downloadAmount == 5 {
//                downloadFinished = true
//                timer.invalidate()
//            }
//        }
    }
    
    private func download() -> AsyncStream<String> {
        let stream = AsyncStream(String.self) { continuation in
            Task {
                for file in files {
                    await performDownload()
                    continuation.yield(file)
                }
                
                continuation.finish()
            }
        }
        
        return stream
    }
    
    private func performDownload() async {
        let downloadTime = Double.random(in: 0.5 ... 1.0)
        try? await Task.sleep(for: .seconds(downloadTime))
    }
}

#Preview {
    ContentView()
}
