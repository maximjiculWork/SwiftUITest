import SwiftUI

protocol CharacterViewModelProtocol: ObservableObject {
    var characters: [Character] { get }
    var nextPage: Int? { get }
    
    func fetchCharacters()
}
