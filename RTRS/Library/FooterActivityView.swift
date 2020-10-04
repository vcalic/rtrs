//
//  FooterActivityView.swift
//  Byrccom
//
//  Created by Vlada Calic on 12/26/18.
//  Copyright © 2018 Byrccom. All rights reserved.
//

import UIKit
// import RxSwift
// import RxCocoa

final class FooterActivityView: UIView {
  var activity: UIActivityIndicatorView {
    return indicatorView
  }

  fileprivate lazy var indicatorView: UIActivityIndicatorView = {
    let indicatorView = UIActivityIndicatorView(style: .gray)
    indicatorView.hidesWhenStopped = true
    return indicatorView
  }()

  private lazy var footerView: UIView = {
    let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
    footerView.embedCentered(view: indicatorView)
    return footerView
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    embedCentered(view: indicatorView)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    embedCentered(view: indicatorView)
  }
}

/*
 extension Reactive where Base: FooterActivityView {

     internal var isAnimating: Binder<Bool> {
         return Binder(self.base) { footerView, active in
             if active {
                 footerView.indicatorView.startAnimating()
             } else {
                 footerView.indicatorView.stopAnimating()
             }
         }
     }
 }
 */

extension UIDevice {
  static var isIpad: Bool {
    return UIDevice.current.userInterfaceIdiom == .pad
  }
}
