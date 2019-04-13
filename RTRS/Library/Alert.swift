//
//  Alert.swift
//  RTRS
//
//  Created by Vlada Calic on 4/14/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import UIKit

extension UIViewController: TargetedExtensionCompatible {}

private extension TargetedExtension where Base: UIViewController {
    func messageBox(title:String, text:String, withSettings: Bool = false) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
        
        if withSettings {
            let title = NSLocalizedString("Settings", comment:"")
            let action = UIAlertAction(title: title, style: .default, handler: { (action) in
                let url = URL(string: UIApplication.openSettingsURLString)!
                UIApplication.shared.open(url, options: [:], completionHandler: { (val) in})
            })
            alert.addAction(action)
        }
        base.present(alert, animated: true) {}
    }
    
    func messageBox(title:String, text:String, completion:@escaping ()->Void) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
        base.present(alert, animated: true, completion: completion)
    }
    
    func messageBox(title:String, text:String, handler:@escaping ((UIAlertAction))->Void) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:handler))
        base.present(alert, animated: true, completion: nil)
    }
    
    
    func confirm(title:String, text:String, destructiveOK: Bool = false, completion:@escaping (_ selected: Bool) -> Void ) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        
        
        let ok = UIAlertAction(title: NSLocalizedString("OK", comment: ""),
                               style: destructiveOK ? .destructive : .default) { (action) in
                                completion(true)
        }
        alert.addAction(ok)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                      style: destructiveOK ? .default : .destructive,
                                      handler: { (action) in
                                        completion(false)
        }))
        base.present(alert, animated: true, completion: nil)
    }
    
    func confirm(title:String,
                 text:String,
                 destructiveOK: Bool = false,
                 afterPresent:@escaping ()->Void,
                 completion:@escaping (_ selected: Bool) -> Void ) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        
        
        let ok = UIAlertAction(title: NSLocalizedString("OK", comment: ""),
                               style: destructiveOK ? .destructive : .default) { (action) in
                                completion(true)
        }
        alert.addAction(ok)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                      style: destructiveOK ? .destructive : .default,
                                      handler: { (action) in
                                        completion(false)
        }))
        base.present(alert, animated: true, completion: afterPresent)
    }
}
