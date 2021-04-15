//
//  Repository.swift
//  GithubAPISwiftUI
//
//  Created by sakiyamaK on 2021/04/15.
//

import Foundation

struct GithubRepository: Decodable, Hashable, Identifiable {
  let id: Int
  let name: String
  let description: String?
  var stargazersCount: Int = 0
  let language: String?
  let htmlUrl: String
  let owner: GithubOwner
}
