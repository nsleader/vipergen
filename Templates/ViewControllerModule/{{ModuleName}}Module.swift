//
//  {{ModuleName}}Module.swift
//
//  Created by {{CONFIG.DEVELOPER_NAME}} on {{DATE.dd}}.{{DATE.MM}}.{{DATE.yy}}.
//  Copyright © {{DATE.yyyy}} {{CONFIG.COMPANY_NAME}}. All rights reserved.

import UIKit

/** 
 #### Конфигуратор модуля `{{ModuleName}}`.

 Использование:
 ```
 window.rootViewController = {{ModuleName}}Module().view
 //or
 navigationController.pushViewController({{ModuleName}}Module().view, animated: true)
 ```
 */
class {{ModuleName}}Module: NSObject {
    
    private var viewController: {{ModuleName}}ViewController?
    {{#withOutputHandler}}private var outputHandler: {{ModuleName}}ModuleOutput{{/withOutputHandler}}
    
    /**
     Вью модуля. Если вью не создан (не используется storyboard/xib), создает и конфигурирует модуль.
    
     - returns: Вью модуля.
     */
    var view: UIViewController {
        guard let view = viewController else {
            viewController = {{ModuleName}}ViewController(nibName: "{{ModuleName}}ViewController", bundle: nil)
            configureModule(self.viewController!)
            return self.viewController!
        }
        return view
    }
    {{#withOutputHandler}}
    init(outputHandler: {{ModuleName}}ModuleOutput) {
        self.outputHandler = outputHandler
    }
    {{/withOutputHandler}}
    /**
     Устанавливает зависимости модуля.
     
     - parameter view: Вью модуля.
     */
    private func configureModule(view: {{ModuleName}}ViewController) {
        {{#withOutputHandler}}let presenter = {{ModuleName}}Presenter(outputHandler: outputHandler){{/withOutputHandler}}{{^withOutputHandler}}let presenter = {{ModuleName}}Presenter(){{/withOutputHandler}}
        let router = {{ModuleName}}Router()
        let interactor = {{ModuleName}}Interactor()
        router.view = view
        view.output = presenter
        view.router = router
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.output = presenter
        
    }
    
}