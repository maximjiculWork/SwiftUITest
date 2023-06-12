import SwiftUI

public struct Episode: Codable, Identifiable, Equatable {
    public let id: String
    public let name: String
    public let episode: String
}
