//
//  ContentView.swift
//  day60challenge
//
//  Created by Ihor Sukhachov on 13.12.2025.
//
import SwiftData
import SwiftUI

@Model
final class User: Identifiable, Codable {
    var id: String
    var isActive: Bool
    var name: String
    var age: Int
    var company: String
    var email: String
    var address: String
    var about: String
    var registered: Date
    var tags: [String]
    var friends: [Friend]

    enum CodingKeys: CodingKey {
        case id, isActive, name, age, company, email
        case address, about, registered, tags, friends
    }

    init(
        id: String,
        isActive: Bool,
        name: String,
        age: Int,
        company: String,
        email: String,
        address: String,
        about: String,
        registered: Date,
        tags: [String],
        friends: [Friend]
    ) {
        self.id = id
        self.isActive = isActive
        self.name = name
        self.age = age
        self.company = company
        self.email = email
        self.address = address
        self.about = about
        self.registered = registered
        self.tags = tags
        self.friends = friends
    }

    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.init(
            id: try container.decode(String.self, forKey: .id),
            isActive: try container.decode(Bool.self, forKey: .isActive),
            name: try container.decode(String.self, forKey: .name),
            age: try container.decode(Int.self, forKey: .age),
            company: try container.decode(String.self, forKey: .company),
            email: try container.decode(String.self, forKey: .email),
            address: try container.decode(String.self, forKey: .address),
            about: try container.decode(String.self, forKey: .about),
            registered: try container.decode(Date.self, forKey: .registered),
            tags: try container.decode([String].self, forKey: .tags),
            friends: try container.decode([Friend].self, forKey: .friends)
        )
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(isActive, forKey: .isActive)
        try container.encode(name, forKey: .name)
        try container.encode(age, forKey: .age)
        try container.encode(company, forKey: .company)
        try container.encode(email, forKey: .email)
        try container.encode(address, forKey: .address)
        try container.encode(about, forKey: .about)
        try container.encode(registered, forKey: .registered)
        try container.encode(tags, forKey: .tags)
        try container.encode(friends, forKey: .friends)
    }
}

@Model
final class Friend: Identifiable, Codable {
    var id: String
    var name: String

    enum CodingKeys: CodingKey {
        case id, name
    }

    init(id: String, name: String) {
        self.id = id
        self.name = name
    }

    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        self.init(id: id, name: name)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
    }
}

struct ContentView: View {
    @Query(sort: \User.name) private var users: [User]
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            List(users) { user in
                NavigationLink {
                    UserDetailView(user: user)
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
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let decodedUsers = try decoder.decode([User].self, from: data)
            for user in decodedUsers {
                modelContext.insert(user)
            }
            
        } catch {
            print("Failed to load users:", error)
        }
    }
}

#Preview {
    ContentView()
}
