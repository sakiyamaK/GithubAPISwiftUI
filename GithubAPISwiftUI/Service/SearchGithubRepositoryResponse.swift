//
//  SearchGithubRepositoryResponse.swift
//  GithubAPISwiftUI
//
//  Created by sakiyamaK on 2021/04/15.
//

import Foundation

struct SearchGithubRepositoryResponse: Decodable {
  let items: [GithubRepository]
}
