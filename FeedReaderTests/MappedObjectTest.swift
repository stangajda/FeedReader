//
//  MappedObjectTest.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 21/06/2021.
//

import XCTest
import Combine

class MappedObjectTest: ErrorResponseTests {

    func testMapObject() throws {
        
        let dataFromFile = MappedObjectTest.load("MockResponseResult.json")

        let stubSuccesfullResponse: (data: Data, statusCode: Int) = (dataFromFile, 200)
        let expectation = self.expectation(description: "response result")
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: stubSuccesfullResponse.statusCode, httpVersion: "HTTP/1.1", headerFields: ["Content-Type": "application/json"])!
            return (response, stubSuccesfullResponse.data, nil)
        }
        
        cancellable = self.load(url: stubAnyUrl)
            .sink { (completion) in
                switch completion {
                    case .failure( let error ):
                        XCTFail("result should not failure \(error)")
                    case .finished:
                        XCTAssert(true,"result must finish")
                }
        } receiveValue: { value in
            _ = value.items.enumerated().map{(index,item) in
                XCTAssertEqual(item.id, "\(index)-id", "data results does not matched")
                XCTAssertEqual(item.rank, "\(index)-rank", "data results does not matched")
                XCTAssertEqual(item.title, "\(index)-title", "data results does not matched")
                XCTAssertEqual(item.fullTitle, "\(index)-fullTitle", "data results does not matched")
                XCTAssertEqual(item.year, "\(index)-year", "data results does not matched")
                XCTAssertEqual(item.image, "\(index)-image", "data results does not matched")
                XCTAssertEqual(item.crew, "\(index)-crew", "data results does not matched")
                XCTAssertEqual(item.imDbRating, "\(index)-imDbRating", "data results does not matched")
                XCTAssertEqual(item.imDbRatingCount, "\(index)-imDbRatingCount", "data results does not matched")
            }
            
            XCTAssertEqual(value.errorMessage, "errorMessage", "data results does not matched")
            XCTAssertEqual(value.items.count, 3, "number of records does not match")
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func load(url: URL) -> AnyPublisher<Movies, Error>{
        return self.mockManager!.fetchData(url)
    }
    
}
