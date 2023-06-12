import Foundation
import SwiftUI

struct TopBarSearch: View {
    @Binding var searchText: String
    @Binding var isFilterVisible: Bool
    
    var body: some View {
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
    }
}
