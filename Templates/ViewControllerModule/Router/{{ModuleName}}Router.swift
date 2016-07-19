//
//  {{ModuleName}}Router.swift
//

import UIKit

class {{ModuleName}}Router {
    
    weak var view: UIViewController!
    
    func presentMessage(title title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        view.presentViewController(alert, animated: true, completion: nil)
    }
    
}