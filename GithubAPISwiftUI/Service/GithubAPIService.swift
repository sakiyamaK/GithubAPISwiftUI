//
//  GithubAPIService.swift
//  GithubAPISwiftUI
//
//  Created by sakiyamaK on 2021/04/15.
//

import Foundation
import Combine

enum GithubAPIServiceError: Error {
  case invalidURL
  case responseError
  case parseError(Error)
}

protocol APIServiceProtocol {
  func request<Request>(with request: Request) -> AnyPublisher<Request.Response, GithubAPIServiceError> where Request:  APIRequestProtocol
}

final class GithubAPIService: APIServiceProtocol {

  private let baseURLString: String
  init(baseURLString: String = "https://api.github.com") {
    self.baseURLString = baseURLString
  }

  func request<Request>(with request: Request) -> AnyPublisher<Request.Response, GithubAPIServiceError> where Request: APIRequestProtocol {

    guard let pathURL = URL(string: request.path, relativeTo: URL(string: baseURLString)) else {
      return Fail(error: GithubAPIServiceError.invalidURL).eraseToAnyPublisher()
    }

    var urlComponents = URLComponents(url: pathURL, resolvingAgainstBaseURL: true)!
    urlComponents.queryItems = request.queryItems
    var request = URLRequest(url: urlComponents.url!)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    let decorder = JSONDecoder()
    decorder.keyDecodingStrategy = .convertFromSnakeCase
    return URLSession.shared.dataTaskPublisher(for: request)
      .map { data, urlResponse in data }
      .mapError { _ in GithubAPIServiceError.responseError }
      .decode(type: Request.Response.self, decoder: decorder)
      .mapError(GithubAPIServiceError.parseError)
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }
}
