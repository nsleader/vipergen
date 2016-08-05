//
//  {{ModuleName}}Router.swift
//
//  Created by {{CONFIG.FIRST_NAME}} CHIRKOV on {{DATE.dd}}.{{DATE.MM}}.{{DATE.yy}}.
//  Copyright © {{DATE.yyyy}} {{CONFIG.COMPANY_NAME}}. All rights reserved.

import UIKit

class {{ModuleName}}Router {
    
    weak var view: UIViewController!
    
    func presentMessage(title title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        view.presentViewController(alert, animated: true, completion: nil)
    }
    
}