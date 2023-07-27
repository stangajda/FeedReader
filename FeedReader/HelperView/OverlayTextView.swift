//
//  OverlayTextView.swift
//  FeedReader
//
//  Created by Stan Gajda on 28/07/2021.
//

import SwiftUI
import PreviewSnapshots

struct OverlayTextView: View {
    @State var stringArray: Array<String>
    var body: some View {
        HStack {
            ForEach(stringArray, id: \.self) { string in
                Text(string)
                        .font(.caption)
                        .padding(6.0)
                        .foregroundColor(.primary)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10.0)
                                .stroke(lineWidth: 2.0)
                        )
                        .foregroundColor(.orange)
                        .padding(.bottom)
            }
        }
    }
}

#if DEBUG
struct OverlayTextView_Previews: PreviewProvider {
    static var previews: some View {
        snapshots.previews.previewLayout(.sizeThatFits)
    }
    static var snapshots: PreviewSnapshots<Any> {
        return PreviewSnapshots(
            configurations: [
                .init()
            ],
            configure: { _ in
                OverlayTextView(stringArray: ["Action", "Adventure", "Fantasy"])
            }
        )
    }
}
#endif
