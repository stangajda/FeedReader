//
//  MockMovie.swift
//  FeedReader
//
//  Created by Stan Gajda on 12/07/2021.
//

extension Movie{
    static let mock = Movie(id: 497698, title: "mock title", vote_average: 8.2, poster_path: "/qAZ0pzat24kLdO3o8ejmbLxyOac.jpg")
}

extension MovieDetail{
    static let mock = MovieDetail(id: 4971212, title: "mock title detail", overview: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", backdrop_path: "/qAZ0pzat24kLdO3o8ejmbLxyOac.jpg")
}

extension MoviesListViewModel.MovieItem{
    static let mock = MoviesListViewModel.MovieItem(Movie.mock)
}

extension MovieDetailViewModel.MovieDetailItem{
    static let mock = MoviesListViewModel.MovieItem(Movie.mock)
}
