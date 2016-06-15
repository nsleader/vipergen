//
//  {{ModuleName}}Router.swift
//  Copyright © 2015 IVAN CHIRKOV. All rights reserved.
//

import UIKit

class {{ModuleName}}Router {
    
    weak var view: UIViewController!
    
    func presentError(title title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        view.presentViewController(alert, animated: true, completion: nil)
    }
    
}