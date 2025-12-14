//
//  UserDetailView.swift
//  day60challenge
//
//  Created by Ihor Sukhachov on 14.12.2025.
//

import SwiftUI

struct UserDetailView: View {
    let user: User
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Group {
                    Text(user.name)
                        .font(.largeTitle)
                        .bold()

                    Text(user.isActive ? "🟢 Active" : "⚪️ Offline")
                        .foregroundStyle(user.isActive ? .green : .gray)

                    Text("Age: \(user.age)")
                    Text("Company: \(user.company)")
                    Text("Email: \(user.email)")
                    Text("Address: \(user.address)")
                }

                Divider()

                Text("About")
                    .font(.headline)

                Text(user.about)

                Divider()

                Text("Friends")
                    .font(.headline)

                ForEach(user.friends) { friend in
                    Text(friend.name)
                }
            }
            .padding()
        }
        .navigationTitle(user.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    UserDetailView(user: User(id: "", isActive: false, name: "", age: 10, company: "", email: "", address: "", about: "", registered: "", tags: [""], friends: []))
}
