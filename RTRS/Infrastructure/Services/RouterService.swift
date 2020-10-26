//
//  RouterService.swift
//  RTRS
//
//  Created by Vlada Calic on 4/14/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import Foundation

struct RouterService {
  private let coordinator: AppCoordinator

  init(coordinator: AppCoordinator) {
    self.coordinator = coordinator
  }

  func route(for url: URL) {
    debugPrint("Clicked on URL: \(url)")
    if url.host == "www.rtrs.tv" || url.host == "lat.rtrs.tv" {
      if let queryDictionary = url.queryDictionary,
         let idString = queryDictionary["id"],
         let id = Int(idString)
      {
        coordinator.openArticle(id: id)
      }
    } else {
      coordinator.openSafari(with: url)
    }
  }
}
