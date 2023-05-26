import XCTest
import Combine
@testable import RickAndMorty

class CharactersViewModelTests: XCTestCase {
    var viewModel: CharacterViewModel!
    var mockNetworking: MockNetworking!
    
    override func setUp() {
        super.setUp()
        mockNetworking = MockNetworking()
        viewModel = CharacterViewModel(networking: mockNetworking)
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworking = nil
        super.tearDown()
    }
    
    func testFetchCharacters() {
        // Given
        let expectation = self.expectation(description: "Characters fetched")
        let mockCharacters: [Character] = [
            Character(id: "1", name: "Rick Sanchez", image: URL(string: "https://example.com/rick.png")!, status: .alive, gender: .male, location: CharacterLocation(name: "Earth"), episode: [
                Episode(id: "1", name: "Pilot", episode: "S01E01"),
                Episode(id: "2", name: "Lawnmower Dog", episode: "S01E02")
            ]),
            Character(id: "2", name: "Morty Smith", image: URL(string: "https://example.com/morty.png")!, status: .alive, gender: .male, location: CharacterLocation(name: "Earth"), episode: [
                Episode(id: "3", name: "Anatomy Park", episode: "S01E03"),
                Episode(id: "4", name: "M. Night Shaym-Aliens!", episode: "S01E04")
            ]),
        ]
        
        let mockResponseData = ResponseData(data: DataContainer(characters: CharacterList(results: mockCharacters, info: PageInfo(next: nil))))
        let mockData = try! JSONEncoder().encode(mockResponseData)
        mockNetworking.mockData = mockData
        
        // When
        viewModel.fetchCharacters()
        
        // Then
        let cancellable = viewModel.$characters
            .dropFirst()
            .sink { characters in
                XCTAssertEqual(characters, mockCharacters)
                expectation.fulfill()
            }
        
        wait(for: [expectation], timeout: 1)
        cancellable.cancel()
    }
}

// Mock networking implementation for testing
class MockNetworking: Networking {
    var mockData: Data?
    
    func fetchData(from url: URL) -> AnyPublisher<Data, Error> {
        guard let mockData = mockData else {
            return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
        }
        return Result.Publisher(mockData)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
