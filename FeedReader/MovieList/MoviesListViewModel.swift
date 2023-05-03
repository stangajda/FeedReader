//
//  MoviesListViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 14/07/2021.
//

import Foundation
import Combine
import Resolver

protocol MoviesListViewModelProtocol: ObservableObject, LoadableProtocol {
    var state: MoviesListViewModel.State { get }
    var input: PassthroughSubject<MoviesListViewModel.Action, Never> { get }
    var fetch: AnyPublisher<Array<MoviesListViewModel.MovieItem>, Error> { get }
    var reset: () -> Void { get }
}


final class MoviesListViewModel: MoviesListViewModelProtocol {
    @Published private(set) var state = State.start()
    @Injected private var service: MovieListServiceProtocol
    
    typealias T = Array<MoviesListViewModel.MovieItem>
    typealias U = Any
    
    var input = PassthroughSubject<Action, Never>()
    
    private var cancelable: AnyCancellable?
    
    init() {
        cancelable = self.publishersSystem(state)
                        .assignNoRetain(to: \.state, on: self)
    }
    
    deinit {
        reset()
    }
    
    lazy var reset: () -> Void = { [self] in
        input.send(.onReset)
        cancelable?.cancel()
    }
    
}

extension MoviesListViewModel: LoadableProtocol{
    var fetch: AnyPublisher<Array<MoviesListViewModel.MovieItem>, Error>{
        let url = APIUrlBuilder[TrendingPath()]
        
        guard let url = url else {
            return Fail(error: APIError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return self.service.fetchMovies(URLRequest(url: url).get())
            .map { item in
                item.results.map(MovieItem.init)
            }
            .eraseToAnyPublisher()
    }
}

extension MoviesListViewModel {
    struct MovieItem: Identifiable, Hashable {
        let id: Int
        let title: String
        let poster_path: String
        let vote_average: Double
        let vote_count: Int
        init(_ movie: Movie) {
            id = movie.id
            title = movie.title
            poster_path = movie.poster_path
            vote_average = movie.vote_average.halfDivide()
            vote_count = movie.vote_count
        }
    }
}

class MoviesListViewModelWrapper: MoviesListViewModelProtocol {
    @Published var state: MoviesListViewModel.State
    var input: PassthroughSubject<MoviesListViewModel.Action, Never>
    var fetch: AnyPublisher<Array<MoviesListViewModel.MovieItem>, Error>
    var reset: () -> Void

    private var cancellable: AnyCancellable?
    init<MoviesListViewModel: MoviesListViewModelProtocol>(_ viewModel: MoviesListViewModel) {
        state = viewModel.state
        input = viewModel.input
        fetch = viewModel.fetch
        reset = viewModel.reset
        cancellable = self.publishersSystem(state)
                        .assignNoRetain(to: \.state, on: self)
    }
}

