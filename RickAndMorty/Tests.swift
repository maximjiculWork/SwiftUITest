//
//  Tests.swift
//  RickAndMorty
//
//  Created by Maxim JICUL on 25.05.2023.
//

import Foundation
import SwiftUI
import Combine


protocol Networking {
    func fetchData(from url: URL) -> AnyPublisher<Data, Error>
}

class URLSessionNetworking: Networking {
    func fetchData(from url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .eraseToAnyPublisher()
    }
}
