//
//  MovieRowView.swift
//  FeedReader
//
//  Created by Stan Gajda on 12/07/2021.
//

import SwiftUI
import Resolver

struct MovieRowView: View {
    @State var movie: MoviesListViewModel.MovieItem
    @State var cache: ImageCache?
    
    var body: some View {
        HStack{
            ImageView(viewModel: Resolver.resolve(name:.itemList,args:["imageURL": movie.poster_path,"cache": cache as Any]))
                .rowImageSize
            Text(movie.title)
                .font(.title)
        }
        .padding()
        .rowSize
    }
}

#if DEBUG
struct MovieRow_Previews: PreviewProvider {
    static var previews: some View {
        Resolver.setupPreviewMode()
        return Group{
            MovieRowView(movie: MoviesListViewModel.MovieItem.mock)
        }
        .previewLayout(.sizeThatFits)
    }
}
#endif
