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
    @Environment(\.imageCache) var cache: ImageCacheInterface
    
    var body: some View {
        HStack{
            ImageView(viewModel: Resolver.resolve(name:.itemList,args:["imageURL": movie.poster_path,"imageSizePath": W200Path() as ImagePathInterface,"cache": cache as Any]))
                .withSmallImageSize()
            VStack(alignment:.leading){
                Text(movie.title)
                    .withRowTitleStyle()
                StarsVotedView(rating: movie.vote_average, voteCount: movie.vote_count)
                    .withRowStarsVotedSize()
            }
        }
        .withRowStyle()
    }
}

#if DEBUG
struct MovieRow_Previews: PreviewProvider {
    static var previews: some View {
        Resolver.setupPreviewMode()
        return Group{
            MovieRowView(movie: MoviesListViewModel.MovieItem.mock).preferredColorScheme(.dark)
            MovieRowView(movie: MoviesListViewModel.MovieItem.mock)
        }
        .previewLayout(.sizeThatFits)
    }
}
#endif