//
//  ContentView.swift
//  day60challenge
//
//  Created by Ihor Sukhachov on 13.12.2025.
//

import SwiftUI

struct User: Codable {
    let id: Int
    let isActive: Bool
    let name: String
    
    let friends: [Friend]
    
    struct Friend: Codable {
        let id: Int
        let name: String
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
