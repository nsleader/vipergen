//
//  main.swift
//  vipergen
//
//  Created by IVAN CHIRKOV on 30.12.15.
//  Copyright © 2015 IVAN CHIRKOV. All rights reserved.
//

import Foundation
import AppKit

func printHelp() {
    print(ANSIColors.green + "ViperGen version 0.2\n")
    
    print(ANSIColors.udef + "Usage:\n")
    print(ANSIColors.def + "     $", ANSIColors.green + "vipergen <ModuleName> [<ModuleType>]\n")
    print("         ", ANSIColors.green + "ModuleName", ANSIColors.def + "- module name (`Module` is automatically added to the end)")
    print("         ", ANSIColors.green + "ModuleType", ANSIColors.def + "- module type. Optional. Default `ViewController`")
    print("\n")
    print(ANSIColors.udef + "Example:\n")
    print(ANSIColors.def + "     $", ANSIColors.green + "vipergen Auth\n")
    print(ANSIColors.udef + "Structure of the module:\n")
    print(ANSIColors.def + "AuthModule/")
    print("├── AuthModule.swift")
    print("├── Interactor:")
    print("│   ├── AuthInteractor.swift")
    print("│   ├── AuthInteractorInput.swift")
    print("│   └── AuthInteractorOutput.swift")
    print("├── Presenter")
    print("│   └── AuthPresenter.swift")
    print("├── Router")
    print("│   └── AuthRouter.swift")
    print("└── View")
    print("    ├── AuthViewController.swift")
    print("    └── AuthViewController.xib")
    print(ANSIColors.def + "")
}

func printError(message: String) {
    print(ANSIColors.red + message)
    print(ANSIColors.def + "")
}

var arguments = Process.arguments
arguments.removeFirst()

var commands = [String]()
var options = [String]()
arguments.forEach { (value) in
    if value.hasPrefix("-") {
        options.append(value)
    } else {
        commands.append(value)
    }
}

if commands.count == 0 {
    printHelp()
    exit(0)
}

let needHelp = options.contains { (value) -> Bool in
    return value == "-h" || value == "--help"
}

if needHelp {
    printHelp()
    exit(0)
}

let withOutputHandler = options.contains { (value) -> Bool in
    return value == "--withOutputHandler" || value == "-O"
}

let moduleName = commands[0]
var moduleType: String? = commands.count > 1 ? commands[1] : nil

let manager = NSFileManager.defaultManager()

let homeDirectoryPath = NSHomeDirectory()
let currentDirectoryPath = manager.currentDirectoryPath
let viperDirectoryPath = homeDirectoryPath.stringByAppendingString("/.viper")
let moduleDirectoryName = moduleType == nil ? "ViewControllerModule" : "\(moduleType!)Module"
let moduleDirectoryPath = viperDirectoryPath.stringByAppendingString("/\(moduleDirectoryName)")

if !manager.fileExistsAtPath(viperDirectoryPath) {
    printError("Error: `~/.viper` directory does not exist!")
    exit(0)
}

if !manager.fileExistsAtPath(moduleDirectoryPath) {
    printError("Error: `~/.viper/\(moduleDirectoryName)` directory (template) not exist!")
    exit(0)
}


let copyPath = currentDirectoryPath.stringByAppendingString("/\(moduleName)Module")
if !manager.fileExistsAtPath(copyPath) {
    do {
        try manager.copyItemAtPath(moduleDirectoryPath, toPath: copyPath)
    } catch let error as NSError {
        printError(error.localizedDescription)
        exit(0)
    }
} else {
    printError("Error: the module with `\(moduleName)Module` name already exists in the current directory!")
    exit(0)
}


let enumerator = manager.enumeratorAtURL(NSURL(fileURLWithPath: copyPath, isDirectory: true), includingPropertiesForKeys: nil, options: .SkipsHiddenFiles, errorHandler: { (url, error) -> Bool in
    return true
})

while let element = enumerator?.nextObject() as? NSURL {

    var fileName: AnyObject?
    try element.getResourceValue(&fileName, forKey: NSURLNameKey)
    if let fileName = fileName {
        if fileName.containsString("{{ModuleName}}") {
            do {
                if !withOutputHandler && fileName.containsString("ModuleOutput") {
                    try manager.removeItemAtPath(element.path!)
                    continue
                }
                let newPath = element.path?.stringByReplacingOccurrencesOfString("{{ModuleName}}", withString: moduleName)
                try manager.moveItemAtPath(element.path!, toPath: newPath!)
                
                let content = try! String(contentsOfFile: newPath!, encoding: NSUTF8StringEncoding)
                let newContent = content.stringByReplacingOccurrencesOfString("{{ModuleName}}", withString: moduleName)
                try newContent.writeToFile(newPath!, atomically: false, encoding: NSUTF8StringEncoding)
            } catch let error as NSError {
                printError(error.localizedDescription)
                exit(0)
            }
        }
    }
}

print(ANSIColors.green + "Module '\(moduleName)' created in the current directory.")
print(ANSIColors.def + "")
NSWorkspace.sharedWorkspace().openFile(".", withApplication: "Finder")
