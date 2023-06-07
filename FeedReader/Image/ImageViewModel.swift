//
//  ImageViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 14/07/2021.
//
import Combine
import UIKit
import SwiftUI

protocol ImageViewModelProtocol: ObservableLoadableProtocol where T == ImageViewModel.ImageItem, U == String {
   
}

//MARK: - ImageViewModel
final class ImageViewModel: ImageViewModelProtocol{
    @Published fileprivate(set) var state = State.start()
    @Injected var service: ImageServiceProtocol
    
    fileprivate(set) var statePublisher: Published<State>.Publisher
    
    typealias State = LoadableEnums<T,U>.State
    typealias T = ImageViewModel.ImageItem
    typealias U = String
    
    var input = PassthroughSubject<Action, Never>()
    fileprivate var cache: ImageCacheProtocol?
    fileprivate var imagePath: String
    fileprivate var imageSizePath: ImagePathProtocol
    
    fileprivate var cancelable: AnyCancellable?
    
    static var instances: [String: ImageViewModel] = [:]

    static func instance(imagePath: String, imageSizePath: ImagePathProtocol, cache: ImageCacheProtocol? = nil) -> ImageViewModel {
        let fullPath: String = imageSizePath.stringPath() + imagePath
        
        if let instance = instances[fullPath] {
            return instance
        } else {
            let instance = ImageViewModel(imagePath: imagePath, imageSizePath: imageSizePath, cache: cache)
            instances[fullPath] = instance
            return instance
        }
    }
    
    fileprivate init(imagePath: String, imageSizePath: ImagePathProtocol, cache: ImageCacheProtocol? = nil){
        statePublisher = _state.projectedValue
        self.imageSizePath = imageSizePath
        self.cache = cache
        self.imagePath = imagePath
        self.setUp()
    }
    
    fileprivate func getURL() -> URL?{
        return APIUrlImageBuilder[self.imageSizePath, imagePath]
    }
    
    fileprivate func setUp(){
        guard let url = getURL() else {
            state = .failedLoaded(APIError.invalidURL)
            return
        }
        
        if let image = cache?[url] {
            state = .loaded(ImageItem(image))
            return
        }
        
        load()
    }
    
    fileprivate func load(){
        cancelable = self.assignNoRetain(self, to: \.state)
    }
    
    deinit {
        reset()
    }
    
    fileprivate lazy var reset: () -> Void = { [weak self] in
        self?.input.send(.onReset)
        self?.cancelable?.cancel()
    }
}

//Mark: - Fetch Publishers
extension ImageViewModel {
    
    func fetch() -> AnyPublisher<ImageItem, Error>{
        guard let url = getURL() else {
            return Fail(error: APIError.invalidURL)
                .eraseToAnyPublisher()
        }
        return self.service.fetchImage(URLRequest(url: url))
            .map { [unowned self] item in
                self.cache?[url] = item
                return ImageItem(item)
            }
            .eraseToAnyPublisher()
    }
}

//MARK: - ImageItem
extension ImageViewModel{
    struct ImageItem{
        let image: Image
        init(_ uiImage: UIImage){
            image = Image(uiImage: uiImage)
        }
    }
}

//MARK: - ImageWrapper
class AnyImageViewModelProtocol: ImageViewModelProtocol{
    @Published var state: ViewModel.State
    var input: PassthroughSubject<ViewModel.Action, Never>
    
    fileprivate(set) var statePublisher: Published<State>.Publisher
    
    typealias ViewModel = ImageViewModel
    
    typealias State = LoadableEnums<T,U>.State
    typealias T = ViewModel.ImageItem
    typealias U = String
    
    fileprivate var viewModel: any ImageViewModelProtocol

    
    fileprivate var cancellable: AnyCancellable?
    init<ViewModel: ImageViewModelProtocol>(_ viewModel: ViewModel){
        state = viewModel.state
        input = viewModel.input
        statePublisher = viewModel.statePublisher
        self.viewModel = viewModel
        cancellable = viewModel.statePublisher.sink { [weak self] newState in
            self?.state = newState
        }
    }
    
    func fetch() -> AnyPublisher<ViewModel.ImageItem, Error> {
        return viewModel.fetch()
    }
    
}

extension ImageViewModelProtocol{
    func eraseToAnyViewModelProtocol() -> AnyImageViewModelProtocol{
        return AnyImageViewModelProtocol(self)
    }
}


