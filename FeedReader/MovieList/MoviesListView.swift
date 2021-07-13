//
//  MoviesListView.swift
//  FeedReader
//
//  Created by Stan Gajda on 11/07/2021.
//

import SwiftUI

struct MoviesListView: View {
    @ObservedObject var service: MoviesService = MoviesService()
    
    var body: some View {
        if let movies = service.movies{
            listMovies(movies.items)
            Text(movies.errorMessage)
                .foregroundColor(Color.red)
        } else {
            loadingSpinner()
                .onAppear{
                    service.loadMovies()
                }
        }
    }
    
    var listMovies = {(_ movies: [Movie]) -> AnyView in
        NavigationView {
            List(movies){ movie in
                NavigationLink(destination: MovieDetailView(movie: movie)){
                    MovieRowView(movie: movie)
                }
            }
        }.eraseToAnyView()
    }
    
    var loadingSpinner = { () -> AnyView in
        VStack{
            Text("Loading...")
            Spinner(isAnimating: .constant(true), style: .large)
        }.eraseToAnyView()
    }
}



struct MoviesList_Previews: PreviewProvider {
    static var previews: some View {
        MoviesListView()
    }
}
