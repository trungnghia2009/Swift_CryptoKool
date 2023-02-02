//
//  ImageRepository.swift
//  CryptoKool
//
//  Created by trungnghia on 02/02/2023.
//

import UIKit
import Combine

enum ImageErrorType: Error {
    case badStatusCode(code: Int)
    case imageError(error: Error)
    case loadingFromCacheError
}

protocol ImageRepositoryProtocol: AnyObject {
    func getImage(imageUrl: URL) -> AnyPublisher<UIImage?, ImageErrorType>
    func downloadImage(imageUrl: URL) -> AnyPublisher<UIImage?, ImageErrorType>
    func loadImageFromCache(imageUrl: URL) -> AnyPublisher<UIImage?, ImageErrorType>
}

final public class ImageRepository: ImageRepositoryProtocol {
    
    private let cache = URLCache.shared
    
    /// Determine whether or not we should get the image from a network call or the cache
    /// - Parameter imageUrl: Image url
    /// - Returns: AnyPublisher<UIImage?, ImageErrorType>
    func getImage(imageUrl: URL) -> AnyPublisher<UIImage?, ImageErrorType> {
        let request = URLRequest(url: imageUrl)
        
        if self.cache.cachedResponse(for: request) != nil {
            return self.loadImageFromCache(imageUrl: imageUrl)
        } else{
            return self.downloadImage(imageUrl: imageUrl)
        }
    }
    
    /// Deliver a UIImage that must be initialized from the data we received from the dataTask
    /// - Parameter imageUrl: Image url
    /// - Returns: AnyPublisher<UIImage?, ImageErrorType>
    func downloadImage(imageUrl: URL) -> AnyPublisher<UIImage?, ImageErrorType> {
        let request = URLRequest(url: imageUrl)
        
        return URLSession.shared
            .dataTaskPublisher(for: imageUrl)
            .tryMap { [weak self] data, response -> UIImage? in
                guard let httpResponse = response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    throw ImageErrorType.badStatusCode(code: (response as? HTTPURLResponse)?.statusCode ?? 400)
                }
                
                // Store cacheData and correspond it to a url request
                let cacheData = CachedURLResponse(response: response, data: data)
                self?.cache.storeCachedResponse(cacheData, for: request)
                
                //print("Loading from network....")
                
                return UIImage(data: data)
            }.mapError { error in
                if let error = error as? ImageErrorType {
                    return error
                } else {
                    return ImageErrorType.imageError(error: error)
                }
            }.eraseToAnyPublisher()
    }
    
    /// Returns a cached url response that corresponds with the specified URL request
    /// - Parameter imageUrl: Image url
    /// - Returns: AnyPublisher<UIImage?, ImageErrorType>
    func loadImageFromCache(imageUrl: URL) -> AnyPublisher<UIImage?, ImageErrorType> {
        let request = URLRequest(url: imageUrl)
        
        return Future<UIImage?, ImageErrorType> { [weak self] promise in
            DispatchQueue.global(qos: .userInitiated).async {
                if let data = self?.cache.cachedResponse(for: request)?.data {
                    //print("Loading from cache....")
                    promise(.success(UIImage(data: data)))
                } else {
                    promise(.failure(ImageErrorType.loadingFromCacheError))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    
}
