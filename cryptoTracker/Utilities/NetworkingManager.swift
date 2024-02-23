//
//  NetworkingManager.swift
//  cryptoTracker
//
//  Created by Jason on 2024/2/19.
//

import Foundation
import Combine

class NetworkingManager {
    
    
    // takes url as input, returns a combine publisher that asynchronously fetching data from internet.
    // when the task complete, it publishes either a tuple that contains the fetched data + URLResponse, or an error if the task fails
    static func download(url: URL) -> AnyPublisher<Data, any Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { try handleURLResponse(output: $0, url: url) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // handle url response code, if successful then returns the output data
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkingError.badURLResponse(url: url)
        }
        return output.data
    }
    
    // customize error handling and print out the error
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }

    // customize error handling with provided text
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url): return "[🔥] Bad response form URL. \(url)"
            case .unknown: return "[⚠️] Unknown error occurred."
            }
        }
    }
    
}
