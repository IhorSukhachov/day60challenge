//
//  ContentView.swift
//  day60challenge
//
//  Created by Ihor Sukhachov on 13.12.2025.
//

import SwiftUI

struct User: Identifiable, Codable {
    let id: String
    let isActive: Bool
    let name: String
    let age: Int
    let company: String
    let email: String
    let address: String
    let about: String
    let registered: String
    let tags: [String]
    let friends: [Friend]
}

struct Friend: Identifiable, Codable {
    let id: String
    let name: String
}

struct ContentView: View {
    @State private var users: [User] = []
    
    var body: some View {
        NavigationStack {
            List(users) { user in
                NavigationLink {
     //               UserDetailView(user: user)
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(user.name)
                                .font(.headline)

                            Text(user.isActive ? "Active" : "Offline")
                                .font(.caption)
                                .foregroundStyle(user.isActive ? .green : .gray)
                        }
                    }
                }
            }
            .navigationTitle("Users")
            .task {
                if users.isEmpty {
                    await loadUsers()
                }
            }
        }
    }

    func loadUsers() async {
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedUsers = try JSONDecoder().decode([User].self, from: data)
            users = decodedUsers
        } catch {
            print("Failed to load users:", error)
        }
    }
}

#Preview {
    ContentView()
}
