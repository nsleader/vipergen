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

if Process.arguments.count < 2 {
    printHelp()
    exit(0)
}

switch Process.arguments[1] {
    case "-h", "--help":
        printHelp()
        exit(0)
    default: break
}

let moduleName = Process.arguments[1]
let moduleType: String? = Process.arguments.count > 2 ? Process.arguments[2] : nil

let manager = NSFileManager.defaultManager()

let homeDirectoryPath = NSHomeDirectory()
let currentDirectoryPath = manager.currentDirectoryPath
let viperDirectoryPath = homeDirectoryPath.stringByAppendingString("/.viper")
let moduleDirectoryName = moduleType == nil ? "ViewControllerModule" : "\(moduleType!)Module"
let moduleDirectoryPath = viperDirectoryPath.stringByAppendingString("/\(moduleDirectoryName)")

if !manager.fileExistsAtPath(viperDirectoryPath) {
    print(ANSIColors.red + "Error: `~/.viper` directory does not exist!")
    print(ANSIColors.def + "")
    exit(0)
}

if !manager.fileExistsAtPath(moduleDirectoryPath) {
    print(ANSIColors.red + "Error: `~/.viper/\(moduleDirectoryName)` directory not exist!")
    print(ANSIColors.def + "")
    exit(0)
}


let copyPath = currentDirectoryPath.stringByAppendingString("/\(moduleName)Module")
if !manager.fileExistsAtPath(copyPath) {
    try! manager.copyItemAtPath(moduleDirectoryPath, toPath: copyPath)
} else {
    print(ANSIColors.red + "Error: the module with `\(moduleName)Module` name already exists in the current directory!")
    print(ANSIColors.def + "")
    exit(0)
}


let enumerator = manager.enumeratorAtURL(NSURL(fileURLWithPath: copyPath, isDirectory: true), includingPropertiesForKeys: nil, options: .SkipsHiddenFiles, errorHandler: { (url, error) -> Bool in
    return true
})

while let element = enumerator?.nextObject() as? NSURL {

    var fileName: AnyObject?
    try! element.getResourceValue(&fileName, forKey: NSURLNameKey)
    if let fileName = fileName {
        if fileName.containsString("{{ModuleName}}") {
            let newPath = element.path?.stringByReplacingOccurrencesOfString("{{ModuleName}}", withString: moduleName)
            try! manager.moveItemAtPath(element.path!, toPath: newPath!)
            
            let content = try! String(contentsOfFile: newPath!, encoding: NSUTF8StringEncoding)
            let newContent = content.stringByReplacingOccurrencesOfString("{{ModuleName}}", withString: moduleName)
            try! newContent.writeToFile(newPath!, atomically: false, encoding: NSUTF8StringEncoding)
        }
    }
}

print(ANSIColors.green + "Module '\(moduleName)' created in the current directory.")
print(ANSIColors.def + "")
NSWorkspace.sharedWorkspace().openFile(".", withApplication: "Finder")
