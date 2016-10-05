//
//  Helpers.swift
//  vipergen
//
//  Created by IVAN CHIRKOV on 05.10.16.
//
//
import Foundation

enum Command: String {
    case fetch = "fetch"
}

enum Option: String {
    case help = "--help"
    case shortHelp = "-h"
}

func printHelp() {
    print(ANSIColors.green + "ViperGen version 0.4.0\n")
    
    print(ANSIColors.udef + "Usage:\n")
    print(ANSIColors.def + "     $", ANSIColors.green + "vipergen <ModuleName> [<ModuleType>] [--withOutputHandler]\n")
    print("         ", ANSIColors.green + "ModuleName", ANSIColors.def + "- module name (`Module` is automatically added to the end)")
    print("         ", ANSIColors.green + "ModuleType", ANSIColors.def + "- module type. Optional. Default `ViewController`")
    print("         ", ANSIColors.green + "--withOutputHandler -O", ANSIColors.def + "- add a protocol `ModuleOutput`")
    print("\n")
    print(ANSIColors.udef + "Example:\n")
    print(ANSIColors.def + "     $", ANSIColors.green + "vipergen Auth")
    print(ANSIColors.def + "     $", ANSIColors.green + "vipergen Auth --withOutputHandler")
    print(ANSIColors.def + "     $", ANSIColors.green + "vipergen Auth ViewController\n")
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
