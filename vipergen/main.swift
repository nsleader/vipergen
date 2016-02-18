//
//  main.swift
//  vipergen
//
//  Created by IVAN CHIRKOV on 30.12.15.
//  Copyright © 2015 IVAN CHIRKOV. All rights reserved.
//

import Foundation

func printHelp() {
    print("ViperGen version 0.1\n")
    print("Creating the module: vipergen <moduleName> [<moduleType>]")
    print("     moduleName - The module name (the word `Module` is automatically added to the end)")
    print("     moduleType - The module type. Optional. Default `ViewController`")
    print("     Example: vipergen CreateOrder\n")
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
    print("Error!\n`~/.viper` directory does not exist.")
    exit(0)
}

if !manager.fileExistsAtPath(moduleDirectoryPath) {
    print("Error!\n`~/.viper/\(moduleDirectoryName)` directory not exist.")
    exit(0)
}


let copyPath = currentDirectoryPath.stringByAppendingString("/\(moduleName)Module")
if !manager.fileExistsAtPath(copyPath) {
    try! manager.copyItemAtPath(moduleDirectoryPath, toPath: copyPath)
} else {
    print("Error!\nThe module with `\(moduleName)Module` name already exists in the current directory.")
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

print("Module '\(moduleName)' created in the current directory.")
