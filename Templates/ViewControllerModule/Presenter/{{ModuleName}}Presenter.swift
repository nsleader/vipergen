//
//  {{ModuleName}}Presenter.swift
//  Copyright © 2015 IVAN CHIRKOV. All rights reserved.
//

import Foundation

class {{ModuleName}}Presenter: {{ModuleName}}ViewOutput, {{ModuleName}}InteractorOutput {
    
    weak var view: {{ModuleName}}ViewInput!
    var router: {{ModuleName}}Router!
    var interactor: {{ModuleName}}InteractorInput!
    
    // MARK: - {{ModuleName}}ViewOutput
    
    func setupView() {
        
    }
    
    // MARK: - {{ModuleName}}InteractorOutput
    
    func errorReceived(message: String) {
        router.presentError(message)
    }
    
}