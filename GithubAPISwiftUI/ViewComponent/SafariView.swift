//
//  SafariView.swift
//  GithubAPISwiftUI
//
//  Created by sakiyamaK on 2021/04/15.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
  typealias UIViewControllerType = SFSafariViewController
  var urlStr: String

  func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
      SFSafariViewController(url: URL(string: urlStr)!)
  }

  func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {}
}

struct SafariView_Previews: PreviewProvider {
    static var previews: some View {
        SafariView(urlStr: "https://github.com/sakiyamaK")
    }
}
