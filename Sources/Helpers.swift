//
//  Helpers.swift
//  vipergen
//
//  Created by IVAN CHIRKOV on 05.10.16.
//
//
import Foundation
import Mustache

enum Command: String {
    case start = "init"
    case fetch = "fetch"
}

enum Option: String {
    case help = "--help"
    case shortHelp = "-h"
}

func printHelp() {
    print(ANSIColors.green + "ViperGen version 0.4.0\n")
    print(ANSIColors.udef + "Usage:\n")
    print(ANSIColors.green + "vipergen init", ANSIColors.def + "- creates a config file (vipergen.yml). Run this command on root directory of project.\n")
    print(ANSIColors.green + "vipergen fetch", ANSIColors.def + "- receives templates and places them in the \(TemplatesService.templatesDir) folder. Run this command immediately after the setting of the configuration file.\n")
    print(ANSIColors.green + "vipergen", ANSIColors.def + "- create a module and put it in the \(TemplatesService.generatedDir) folder. Run this command on root directory of project.\n")    
    
    print(ANSIColors.udef + "Structure of the module:\n")
    print(ANSIColors.def + "AuthModule/")
    print("├── AuthModule.swift")
    print("├── Interactor:")
    print("│   ├── AuthInteractor.swift")
    print("├── Presenter")
    print("│   └── AuthPresenter.swift")
    print("├── Router")
    print("│   └── AuthRouter.swift")
    print("└── View")
    print("    ├── AuthViewController.swift")
    print("    └── AuthViewController.xib")
    print(ANSIColors.def + "")
}

func printError(_ message: String) {
    print(ANSIColors.red + message)
    print(ANSIColors.def + "")
}

func printListOfTemplates(_ templates: [String]) {
    var idx = 0
    for template in templates {
        print("\(idx): \(template)")
        idx += 1
    }
}

func shell(_ args: String...) -> Int32 {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = args
    task.launch()
    task.waitUntilExit()
    return task.terminationStatus
}
