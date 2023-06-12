import SwiftUI

struct DataContainer: Codable {
    let characters: CharacterList
}

struct ResponseData: Codable {
    let data: DataContainer
}
