//
//  APIUrlImageBuilder.swift
//  FeedReader
//
//  Created by Stan Gajda on 12/08/2021.
//

import Foundation

struct APIUrlImageBuilder: APIUrlImageBuilderProtocol{
    static var imageURL: URL? { URL(string: API_IMAGE_URL) }
}

protocol ImagePathInterface {
    func stringPath() -> String
}

struct OriginalPath: ImagePathInterface{
    func stringPath() -> String{
        API_IMAGE_ORIGINAL_PATH
    }
}

struct W200Path: ImagePathInterface {
    func stringPath() -> String {
        API_IMAGE_W200_PATH
    }
}