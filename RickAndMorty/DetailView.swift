import Foundation
import SwiftUI

struct DetailView: View {
    let character: Character
    
    var body: some View {
        VStack {
            AsyncImage(url: character.image) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
            } placeholder: {
                ProgressView()
                    .frame(width: 200, height: 200)
            }
            
            Text(character.name)
                .font(.title)
                .padding()
            
            Text("Status: \(character.status.rawValue.capitalized)")
                .font(.subheadline)
            
            Text("Gender: \(character.gender.rawValue.capitalized)")
                .font(.subheadline)
        }
        List(character.episode) {episode in
            VStack(alignment: .leading) {
                Text(episode.episode)
                Text("\u{201C}\(episode.name)\u{201C}")
                    .font(Font.body.bold())
            }
        }.listStyle(PlainListStyle())
    }
}
