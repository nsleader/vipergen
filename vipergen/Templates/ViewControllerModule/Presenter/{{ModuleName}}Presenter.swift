//
//  {{ModuleName}}Presenter.swift
//  Copyright © 2015 IVAN CHIRKOV. All rights reserved.
//

import Foundation

class {{ModuleName}}Presenter: {{ModuleName}}ViewOutput, {{ModuleName}}InteractorOutput {
    
    weak var view: {{ModuleName}}ViewInput!
    var router: {{ModuleName}}RouterInput!
    var interactor: {{ModuleName}}InteractorInput!
    
}