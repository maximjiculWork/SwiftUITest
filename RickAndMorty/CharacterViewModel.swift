import Foundation
import SwiftUI
import Combine

final class CharacterViewModel: CharacterViewModelProtocol {
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
