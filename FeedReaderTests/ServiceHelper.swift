//
//  ServiceHelper.swift
//  FeedReader
//
//  Created by Stan Gajda on 03/07/2021.
//

import Foundation
import Combine

extension Publisher {
    
    func sinkToResult(_ result: @escaping (Result<Output, Failure>) -> Void) -> AnyCancellable {
        return sink(receiveCompletion: { completion in
            switch completion {
            case let .failure(error):
                result(.failure(error))
            default: break
            }
        }, receiveValue: { value in
            result(.success(value))
        })
    }
    
}

extension URLResponse{
    func mapError(_ data:Data) throws -> Data{
        if let httpResponse = self as? HTTPURLResponse, HTTPCodes.success ~= httpResponse.statusCode {
            return data
        }
        
        if let response = self as? HTTPURLResponse, let url = self.url{
            let error:NSError = NSError(domain: url.absoluteString, code: response.statusCode, userInfo: nil)
            throw error
        }
        
        throw NSError(domain: "localDomain", code: 444, userInfo: nil)
    }
}
