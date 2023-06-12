import Foundation
import SwiftUI

struct CharactersListView: View {
    var characters: [Character]
    @StateObject var viewModel: CharacterViewModel
    @EnvironmentObject var coordinator: Coordinator<AppRouter>
    
    var body: some View {
        List(characters) { character in
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
                .onTapGesture {
                    coordinator.show(.detailView(character: character))
                }
        }
        .listStyle(PlainListStyle())
    }
}


