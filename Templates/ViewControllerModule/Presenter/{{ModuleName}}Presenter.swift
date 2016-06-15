//
//  {{ModuleName}}Presenter.swift
//  Copyright © 2015 IVAN CHIRKOV. All rights reserved.
//

import Foundation

extension {{ModuleName}}Presenter: {{ModuleName}}ViewOutput {
    
    func setupView() {
        view.setupView()
    }

}

extension {{ModuleName}}Presenter: {{ModuleName}}InteractorOutput {
    
    func errorReceived(message: String) {
        router.presentError(title: "Error", message: message)
    }

}

class {{ModuleName}}Presenter {
    
    weak var view: {{ModuleName}}ViewInput!
    var router: {{ModuleName}}Router!
    var interactor: {{ModuleName}}InteractorInput!
    
}