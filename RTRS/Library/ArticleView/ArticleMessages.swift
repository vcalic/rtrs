//
//  ArticleMessages.swift
//  RTRS
//
//  Created by Vlada Calic on 4/6/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import Foundation
import WebKit

enum ArticleMessage: String, CaseIterable {
  case nullMessage = "null"
  case documentHeight = "height"
  case debugPrint
  case getURL
  case postURL
}

extension ArticleMessage {
  func urlCall(message: WKScriptMessage, completion: @escaping (String) -> Void) {
    switch self {
    case .nullMessage:
      return
    case .documentHeight:
      return
    case .debugPrint:
      return
    case .getURL, .postURL:
      guard let body = message.body as? [String: Any] else { print("Wrong getURL message.body"); return }
      guard let urlString = body["url"] as? String else { print("Wrong getURL string"); return }
      guard let promiseId = body["promiseId"] as? String else { print("Wrong getURL promisIde"); return }
      guard let url = URL(string: urlString) else { print("Wrong getURL URL"); return }
      var query = ""
      if let params = body["params"] as? String {
        query = params
      }

      if self == .getURL {
        print("Getting data from ArticleMessage")
        NetworkService.fetchData(url: url) { result in
          DispatchQueue.main.async {
            completion(self.process(result: result, promiseId: promiseId))
          }
        }
      } else if self == .postURL {
        NetworkService.postData(url: url, query: query) { result in
          DispatchQueue.main.async {
            completion(self.process(result: result, promiseId: promiseId))
          }
        }
      } else {
        print("Very strange")
      }
    }
  }

  private func process(result: Result<Data, NetworkError>, promiseId: String) -> String {
    print("Result \(result)")
    switch result {
    case .success(let result):
      let base64 = result.base64EncodedString()
      let js = "bridge.resolvePromise('\(promiseId)', '\(base64)', null)"
      return js
    case .failure(let error):
      let errorMsg = error.localizedDescription
      let base64 = errorMsg.data(using: .utf8)?.base64EncodedString() ?? ""
      return "bridge.resolvePromise('\(promiseId)', null, '\(base64)')"
    }
  }
}
