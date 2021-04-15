//
//  HomeViewModel.swift
//  GithubAPISwiftUI
//
//  Created by sakiyamaK on 2021/04/15.
//

import Foundation
import Combine
import UIKit

final class HomeViewModel: ObservableObject {
  enum Inputs {
    case onCommit(text: String)
    case tappedCardView(urlString: String)
  }

  @Published private(set) var cardViewInputs: [CardView.Input] = []
  @Published var inputText: String = ""
  @Published var isShowError = false
  @Published var isLoading = false
  @Published var isShowSheet = false
  @Published var urlStr: String = ""

  init(apiService: APIServiceProtocol) {
    self.apiService = apiService
    bind()
  }

  func apply(inputs: Inputs) {
    switch inputs {
    case .onCommit(let inputText):
      onCommitSubject.send(inputText)
    case .tappedCardView(let urlStr):
      self.urlStr = urlStr
      isShowSheet = true
    }
  }

  // MARK: - Private
  private let apiService: APIServiceProtocol
  private let onCommitSubject = PassthroughSubject<String, Never>()
  private let responseSubject = PassthroughSubject<SearchGithubRepositoryResponse, Never>()
  private let errorSubject = PassthroughSubject<GithubAPIServiceError, Never>()
  private var cancellables: [AnyCancellable] = []

  private func bind() {
    let responseSubscriber = onCommitSubject
      .flatMap { [apiService] (query) in
        apiService.request(with: SearchGithubRepositoryRequest(query: query))
          .catch { [weak self] error -> Empty<SearchGithubRepositoryResponse, Never> in
            self?.errorSubject.send(error)
            return .init()
          }
      }
      .map{ $0.items }
      .sink(receiveValue: { [weak self] (repositories) in
        guard let self = self else { return }
        self.cardViewInputs = self.convertInput(repositories: repositories)
        self.inputText = ""
        self.isLoading = false
      })

    let loadingStartSubscriber = onCommitSubject
      .map { _ in true }
      .assign(to: \.isLoading, on: self)

    let errorSubscriber = errorSubject
      .sink(receiveValue: { [weak self] (error) in
        guard let self = self else { return }
        self.isShowError = true
        self.isLoading = false
      })

    cancellables += [
      responseSubscriber,
      loadingStartSubscriber,
      errorSubscriber
    ]
  }

  private func convertInput(repositories: [GithubRepository]) -> [CardView.Input] {
    repositories.compactMap { (repo) -> CardView.Input? in
      do {
        guard let url = URL(string: repo.owner.avatarUrl) else {
          return nil
        }
        let data = try Data(contentsOf: url)
        guard let image = UIImage(data: data) else {
          return nil
        }
        return CardView.Input(iconImage: image,
                              title: repo.name,
                              language: repo.language,
                              star: repo.stargazersCount,
                              description: repo.description,
                              url: repo.htmlUrl)

      } catch {
        return nil
      }
    }
  }
}
