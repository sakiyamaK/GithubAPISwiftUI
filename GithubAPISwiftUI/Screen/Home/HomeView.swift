//
//  HomeView.swift
//  GithubAPISwiftUI
//
//  Created by sakiyamaK on 2021/04/15.
//

import SwiftUI

struct HomeView: View {
  @ObservedObject var viewModel: HomeViewModel
  @State var text: String = ""

  var body: some View {
    NavigationView {
      if self.viewModel.isLoading {
        Text("読込中...")
          .font(.headline)
          .foregroundColor(.gray)
          .offset(x: 0, y: -200)
          .navigationBarTitle("", displayMode: .inline)
      } else {
        ScrollView(showsIndicators: false, content: {
          ForEach(viewModel.cardViewInputs) { cardInput in
            Button(action: {
              self.viewModel.apply(inputs:
                                    .tappedCardView(urlString: cardInput.url))
            }, label: {
              CardView(input: cardInput)
            })
          }
        })
        .padding()
        //        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(leading: HStack {
          TextField("検索キーワード", text: $text, onCommit: {
            self.viewModel.apply(inputs: .onCommit(text: self.text))
          })
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .keyboardType(.asciiCapable)
          .frame(width: UIScreen.main.bounds.width - 40)
        })
        .sheet(isPresented: $viewModel.isShowSheet) {
          SafariView(urlStr: self.viewModel.urlStr)
        }
        .alert(isPresented: $viewModel.isShowError) {
          Alert(title: Text("通信時にエラーが発生しました。もう一度やり直してください"))
        }
      }
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView(viewModel: .init(apiService: GithubAPIService()))
  }
}
