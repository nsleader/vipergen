//
//  {{ModuleName}}ViewController.swift
//  Copyright © 2015 IVAN CHIRKOV. All rights reserved.
//

import UIKit

protocol {{ModuleName}}ViewInput: class {
    
    func setupView()
    func updateView()
    
}

protocol {{ModuleName}}ViewOutput: class {
    
    func setupView()
    
}

class {{ModuleName}}ViewController: UIViewController {

    var output: {{ModuleName}}ViewOutput!
    var router: {{ModuleName}}Router!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.setupView()
    }
    
}

extension {{ModuleName}}ViewController: {{ModuleName}}ViewInput {

    func setupView() {

    }
    
    func updateView() {
        
    }
   
}
