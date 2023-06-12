import SwiftUI

public struct CharacterLocation: Codable, Equatable {
    public let name: String
}

public enum CharacterStatus: String, CaseIterable, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}

public enum CharacterGender: String, CaseIterable, Codable {
    case male = "Male"
    case female = "Female"
    case genderless = "Genderless"
    case unknown = "unknown"
}

public struct Character: Codable, Identifiable, Equatable {
    public let id: String
    public let name: String
    public let image: URL
    public let status: CharacterStatus
    public let gender: CharacterGender
    public let location: CharacterLocation
    public let episode: [Episode]
    
    public static func == (lhs: Character, rhs: Character) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.image == rhs.image && lhs.status == rhs.status && lhs.gender == rhs.gender && lhs.location == rhs.location && lhs.episode == rhs.episode
    }
}
