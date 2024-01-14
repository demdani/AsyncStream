//
//  ContentView.swift
//  AsyncStream
//
//  Created by Demjén Dániel on 13/01/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showProgress = false
    
    var body: some View {
        VStack {
            ZStack {
                Button("Start downloading") {
                    withAnimation {
                        showProgress.toggle()
                    }
                }
                
                if showProgress {
                    VStack {
                        Button("Dismiss") {
                            withAnimation {
                                showProgress.toggle()
                            }
                        }
                    }
                    .frame(width: 200, height: 200)
                    .background(.white)
                    .cornerRadius(25)
                    .shadow(color: .black.opacity(0.2), radius: 5)
                    .transition(.scale)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
