//
//  {{ModuleName}}InteractorOutput.swift
//
//  Created by {{CONFIG.DEVELOPER_NAME}} on {{DATE.dd}}.{{DATE.MM}}.{{DATE.yy}}.
//  Copyright © {{DATE.yyyy}} {{CONFIG.COMPANY_NAME}}. All rights reserved.

import Foundation

protocol {{ModuleName}}InteractorOutput: class {
    
    func errorReceived(error: NSError)
    
}