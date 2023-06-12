import SwiftUI

struct ContentView: View {
    @State private var searchText: String = ""
    @State private var selectedStatus: CharacterStatus = .alive
    @State private var selectedGender: CharacterGender = .male
    @State private var isFilterVisible: Bool = false
    
    @StateObject var viewModel = CharacterViewModel()
    @EnvironmentObject var coordinator: Coordinator<AppRouter>
    
    var filteredCharacters: [Character] {
        var filtered = viewModel.characters
        
        if !searchText.isEmpty {
            filtered = filtered.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        
        if isFilterVisible {
            filtered = filtered.filter { $0.status == selectedStatus && $0.gender == selectedGender  }
        }
        
        return filtered
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                TopBarSearch(searchText: $searchText, isFilterVisible: $isFilterVisible)
                
                if isFilterVisible {
                    FilterPicker(title: "Status", options: CharacterStatus.allCases, selectedValue: $selectedStatus)
                    
                    FilterPicker(title: "Gender", options: CharacterGender.allCases, selectedValue: $selectedGender)
                }
                
                if filteredCharacters.isEmpty {
                    NoData(noDataText: "No characters found")
                } else {
                    CharactersListView(characters: filteredCharacters, viewModel: viewModel)
                }
            }
            .navigationBarTitle("Characters")
        }
        .onAppear {
            viewModel.fetchCharacters()
        }
    }
}
