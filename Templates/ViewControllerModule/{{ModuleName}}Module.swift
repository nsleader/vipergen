//
//  {{ModuleName}}Module.swift
//
//  Copyright © 2015 IVAN CHIRKOV. All rights reserved.
//

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
    
    /**
     Устанавливает зависимости модуля.
     
     - parameter view: Вью модуля.
     */
    private func configureModule(view: {{ModuleName}}ViewController) {
        let presenter = {{ModuleName}}Presenter()
        let router = {{ModuleName}}Router()
        let interactor = {{ModuleName}}Interactor()
        router.view = view
        view.output = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.output = presenter
        
    }
    
}