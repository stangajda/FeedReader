//
//  MovieListViewModelSpec.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 08/06/2023.
//

import Foundation
import UIKit
@testable import FeedReader
import Combine
import Nimble
import Quick

class MovieDetailViewModelSpec: QuickSpec, MockableMovieDetailViewModelProtocol {
    lazy var mockRequestUrl: URLRequest = URLRequest(url: MockAPIRequest[MockEmptyPath()]!).get()
    lazy var viewModel: (any MovieDetailViewModelProtocol)? = nil
    
    typealias Mock = MockURLProtocol.MockedResponse
    
    var movieItem: MovieDetailViewModel.MovieDetailItem!
    var anotherMovieItem: MovieDetailViewModel.MovieDetailItem!
    
    override func spec() {
        describe("check movie list service"){

            beforeEach { [self] in
                viewModel = MovieDetailViewModel.instance(MoviesListViewModel.MovieItem.mock)
            }
            
            afterEach { [unowned self] in
                viewModel?.send(action: .onReset)
                MockURLProtocol.mock = nil
                viewModel = nil
                MovieDetailViewModel.deallocateAllInstances()
            }

            context("when send on appear action") {
                beforeEach { [unowned self] in
                    let moviesFromData: MovieDetail = Data.jsonDataToObject(Config.Mock.MovieDetail.movieDetailResponseResult)
                    let anotherMoviesFromData: MovieDetail = Data.jsonDataToObject(Config.Mock.MovieDetail.anotherMovieDetailResponseResult)
                    mockResponse(result: .success(moviesFromData) as Result<MovieDetail, Swift.Error>)
                    movieItem = MovieDetailViewModel.MovieDetailItem(moviesFromData)
                    anotherMovieItem = MovieDetailViewModel.MovieDetailItem(anotherMoviesFromData)
                    viewModel?.send(action: .onAppear)
                }
                
                it("it should get movies from loaded state match mapped object"){ [unowned self] in
                    await expect(self.viewModel?.state).toEventually(equal(.loaded(movieItem)))
                }
                
                it("it should get movies from loaded state match not mapped object"){ [unowned self] in
                    await expect(self.viewModel?.state).toEventuallyNot(equal(.loaded(anotherMovieItem)))
                }
            }
            
            context("when send on reset action") {
                beforeEach { [unowned self] in
                    viewModel?.send(action: .onAppear)
                    viewModel?.send(action: .onReset)
                }
                
                it("it should get start state"){ [unowned self] in
                    await expect(self.viewModel?.state).toEventually(equal(.start(497698)))
                }
            }
            
            let errorCodes: Array<Int> = [300,404,500]
            errorCodes.forEach { errorCode in
                context("when error response with error code \(errorCode)") {
                    beforeEach { [unowned self] in
                        mockResponse(result: .failure(APIError.apiCode(errorCode)))
                        viewModel?.send(action: .onAppear)
                    }
                    
                    it("it should get state failed loaded with error code \(errorCode)"){ [unowned self] in
                        await expect(self.viewModel?.state).toEventually(equal(.failedLoaded(APIError.apiCode(errorCode))))
                    }
                }
            }
            
            context("when error response unknown error") {
                beforeEach { [unowned self] in
                    mockResponse(result: .failure(APIError.unknownResponse))
                    viewModel?.send(action: .onAppear)
                }
                
                it("it should get state failed loaded with unknown error"){ [unowned self] in
                    await expect(self.viewModel?.state).toEventually(equal(.failedLoaded(APIError.unknownResponse)))
                }
            }
            
            context("when 1 instance exist") {
                beforeEach { [unowned self] in
                    mockResponse(result: .failure(APIError.unknownResponse))
                    viewModel?.send(action: .onAppear)
                }
                
                it("it should get MovieDetailViewModel instances count 1"){
                    expect(MovieDetailViewModel.instances.count).to(equal(1))
                }
            }
            
            context("when deaalocate MovieDetailViewModel instances") {
                beforeEach { [unowned self] in
                    mockResponse(result: .failure(APIError.unknownResponse))
                    viewModel?.send(action: .onAppear)
                    MovieDetailViewModel.deallocateAllInstances()
                }
                
                it("it should get MovieDetailViewModel instances count 0"){
                    expect(MovieDetailViewModel.instances.count).to(equal(0))
                }
            }
        }
    }
}
