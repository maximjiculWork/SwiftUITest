import Foundation
import SwiftUI

struct FilterPicker<T: CaseIterable & RawRepresentable & Hashable>: View where T.RawValue: StringProtocol {
    let title: String
    let options: [T]
    @Binding var selectedValue: T
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
            Picker(title, selection: $selectedValue) {
                ForEach(options, id: \.self) { option in
                    Text(option.rawValue.capitalized)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        .padding([.leading, .bottom, .trailing])
    }
}
