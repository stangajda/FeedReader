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
    @Environment(\.imageCache) var cache: FDRImageCacheInterface
    
    var body: some View {
        HStack{
            FDRImageView(viewModel: Resolver.resolve(name:.itemList,args:["imageURL": movie.poster_path,"imageSizePath": FDRW200Path() as FDRImagePathInterface,"cache": cache as Any]))
                .withRowListImageSize()
            VStack(alignment:.leading){
                Text(movie.title)
                    .withRowTitleSize()
                FDRStarsVotedView(rating: movie.vote_average, voteCount: movie.vote_count)
                    .withRowStarsVotedSize()
            }
        }
        .withRowListStyles()
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
