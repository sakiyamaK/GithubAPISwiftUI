//
//  GithubSearchRepositoryRequest.swift
//  GithubAPISwiftUI
//
//  Created by sakiyamaK on 2021/04/15.
//

import Foundation

protocol APIRequestProtocol {
  associatedtype Response: Decodable
  var path: String { get }
  var queryItems: [URLQueryItem]? { get }
}

struct SearchGithubRepositoryRequest: APIRequestProtocol {
  typealias Response = SearchGithubRepositoryResponse

  var path: String { return "/search/repositories" }
  var queryItems: [URLQueryItem]? {
    [
      .init(name: "q", value: query),
      .init(name: "order", value: "desc")
    ]
  }

  private let query: String

  init(query: String) {
    self.query = query
  }
}
