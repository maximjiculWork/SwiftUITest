import SwiftUI

struct ContentView: View {
    @State private var searchText: String = ""
    @State private var selectedStatus: CharacterStatus = .alive
    @State private var selectedGender: CharacterGender = .male
    @State private var isFilterVisible: Bool = false
    
    @StateObject var viewModel = CharacterViewModel()
    
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
                HStack(alignment: .center) {
                    TextField("Search", text: $searchText)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        isFilterVisible.toggle()
                    }) {
                        Image(systemName: isFilterVisible ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle").resizable()
                            .frame(width: 25, height: 25)
                    }
                }
                .padding([.leading, .bottom, .trailing])
                
                if isFilterVisible {
                    VStack(alignment: .leading) {
                        Text("Status")
                        Picker("Status", selection: $selectedStatus) {
                            ForEach(CharacterStatus.allCases, id: \.self) { status in
                                Text(status.rawValue.capitalized)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    .padding([.leading, .bottom, .trailing])
                    
                    VStack(alignment: .leading) {
                        Text("Gender")
                        Picker("Gender", selection: $selectedGender) {
                            ForEach(CharacterGender.allCases, id: \.self) { gender in
                                Text(gender.rawValue.capitalized)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    .padding([.leading, .bottom, .trailing])
                }
                
                if filteredCharacters.isEmpty {
                    Spacer()
                    Text("No characters found")
                        .foregroundColor(.gray)
                        .padding(.vertical)
                    Spacer()
                } else {
                    List(filteredCharacters) { character in
                        NavigationLink(destination: DetailView(character: character)) {
                            HStack {
                                AsyncImage(url: character.image) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: 50, height: 50)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(character.name)
                                    
                                    VStack(alignment: .leading) {
                                        Text("Status: \(character.status.rawValue.capitalized)")
                                            .font(.caption)
                                        Text("Gender: \(character.gender.rawValue.capitalized)")
                                            .font(.caption)
                                        Text("Location: \(character.location.name.capitalized)")
                                            .font(.caption)
                                    }
                                }
                                .onAppear {
                                    if character.id == viewModel.characters.last?.id && viewModel.nextPage != nil {
                                        viewModel.fetchCharacters()
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationBarTitle("Characters")
        }
        .onAppear {
            viewModel.fetchCharacters()
        }
    }
}
