//
//  Helper.swift
//  FeedReader
//
//  Created by Stan Gajda on 22/06/2021.
//

import Foundation
import Nimble
import UIKit

// MARK: - Result

extension Data {
    static var stubData: Data {
        return Data([0,1,0,1])
    }
}

func beSuccessAndEqual(_ expected: Data) -> Predicate<Result<Data, Error>>  {
    beSuccess{
        value in
        expect(value).to(equal(expected))
    }
}

func beSuccessAndEqual<T:Equatable>(_ expected: T) -> Predicate<Result<T, Error>>  {
    beSuccess{
        value in
        expect(value).to(equal(expected))
    }
}

func beSuccessAndNotEqual<T:Equatable>(_ expected: T) -> Predicate<Result<T, Error>>  {
    beSuccess{
        value in
        expect(value).toNot(equal(expected))
    }
}

func beFailureAndMatchError(_ expected: APIError) -> Predicate<Result<Data, Error>>  {
    beFailure{
        error in
        expect(error.localizedDescription).to(equal(expected.localizedDescription))
    }
}

func beFailureAndMatchError<T:Equatable>(_ expected: APIError) -> Predicate<Result<T, Error>>  {
    beFailure{
        error in
        expect(error.localizedDescription).to(equal(expected.localizedDescription))
    }
}

func beFailureAndNotMatchError(_ expected: APIError) -> Predicate<Result<Data, Error>>  {
    beFailure{
        error in
        expect(error.localizedDescription).toNot(equal(expected.localizedDescription))
    }
}

func beLoadedStateMoviesCount(_ expectedCount: Int) -> Predicate<LoadableEnums<Array<MoviesListViewModel.MovieItem>, Int>.State> {
    beLoadedState{
        movies in
        expect(movies.count).to(equal(expectedCount))
    }
}

func beLoadedState<Loaded, Start>(
    test: ((Loaded) -> Void)? = nil
) -> Predicate<LoadableEnums<Loaded, Start>.State> {
    return Predicate.define { expression in
        var rawMessage = "be <loaded State value>"
        if test != nil {
            rawMessage += " that satisfies block"
        }
        let message = ExpectationMessage.expectedActualValueTo(rawMessage)

        guard case let .loaded(value)? = try expression.evaluate() else {
            return PredicateResult(status: .doesNotMatch, message: message)
        }

        var matches = true
        if let test = test {
            let assertions = gatherFailingExpectations {
                test(value)
            }
            let messages = assertions.map { $0.message }
            if !messages.isEmpty {
                matches = false
            }
        }

        return PredicateResult(bool: matches, message: message)
    }
}

func convertImageToData(_ named:String) -> Data {
    let image = UIImage(named: named)
    guard let imageData = image?.pngData() else {
        fatalError("Error: Can not convert image to data")
    }
    return imageData
}
