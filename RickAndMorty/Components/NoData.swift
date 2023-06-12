import Foundation
import SwiftUI

struct NoData: View {
    let noDataText: String
    
    var body: some View {
        Spacer()
        Text(noDataText)
            .foregroundColor(.gray)
            .padding(.vertical)
        Spacer()
    }
}

