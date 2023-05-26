import Foundation
import SwiftUI
import Combine

struct Character: Codable, Identifiable, Equatable {
    let id: String
    let name: String
    let image: URL
    let status: CharacterStatus
    let gender: CharacterGender
    let location: CharacterLocation
    let episode: [Episode]
    
    static func == (lhs: Character, rhs: Character) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.image == rhs.image && lhs.status == rhs.status && lhs.gender == rhs.gender && lhs.location == rhs.location && lhs.episode == rhs.episode
    }
}

struct CharacterLocation: Codable, Equatable {
    let name: String
}

struct Episode: Codable, Identifiable, Equatable {
    let id: String
    let name: String
    let episode: String
}

enum CharacterStatus: String, CaseIterable, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}

enum CharacterGender: String, CaseIterable, Codable {
    case male = "Male"
    case female = "Female"
    case genderless = "Genderless"
    case unknown = "unknown"
}

struct PageInfo: Codable {
    let next: Int?
}

struct ResponseData: Codable {
    let data: DataContainer
}

struct DataContainer: Codable {
    let characters: CharacterList
}

struct CharacterList: Codable {
    let results: [Character]
    let info: PageInfo
}

protocol Networking {
    func fetchData(from url: URL) -> AnyPublisher<Data, Error>
}

class URLSessionNetworking: Networking {
    func fetchData(from url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .mapError { error -> Error in
                return error
            }
            .eraseToAnyPublisher()
    }
}

class CharacterViewModel: ObservableObject {
    @Published var characters: [Character] = []
    
    private var cancellable: AnyCancellable?
    public var nextPage: Int?
    private let networking: Networking
       
       init(networking: Networking = URLSessionNetworking()) {
           self.networking = networking
       }
    
    func fetchCharacters() {
        let query = """
           query($page: Int){
               characters(page: $page) {
                   results {
                       id
                       name
                       species
                       image
                       status
                       gender
                       location {
                        name
                       }
                       episode {
                        id
                        name
                        episode
                       }
                   }
                   info {
                    next
                   }
               }
           }
           """
        
        guard let url = URL(string: "https://rickandmortyapi.com/graphql") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["query": query, "variables": ["page": nextPage]] as [String : Any])
        
        cancellable = URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                }
            }, receiveValue: { [weak self] data in
                do {
                    let decoder = JSONDecoder()
                    let responseData = try decoder.decode(ResponseData.self, from: data)
                    // Update the next page value
                    self?.nextPage = responseData.data.characters.info.next
                    self?.characters.append(contentsOf: responseData.data.characters.results)

                    print("responseData: \(responseData)")
                } catch {
                    print("Error decoding response: \(error)")
                }
                
            })
        
        
        print("characters array: \(characters)")
        
    }
}
