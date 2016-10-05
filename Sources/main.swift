//
//  Helpers.swift
//  vipergen
//
//  Created by IVAN CHIRKOV on 05.10.16.
//
//

import Darwin.C
import Mustache


//
// Parse arguments
//
var arguments = CommandLine.arguments
arguments.removeFirst()

let commands = arguments.filter { !$0.hasPrefix("-") }
let options = arguments.filter { $0.hasPrefix("-") }

//
// Help option
//
let needHelp = options.contains {
    return $0 == Option.help.rawValue || $0 == Option.shortHelp.rawValue
}
if needHelp {
    printHelp()
    exit(0)
}

//
// Fetch templates
//
let templatesService = TemplatesService()
if commands.index(of: Command.fetch.rawValue) == 0 {
    print("Fetching templates")
    do {
        try templatesService.fetchTemplates()
    } catch let e as TemplatesError {
        printError(e.message)
    }
    exit(0)
}


print(ANSIColors.green + "ViperGen version 0.4.0\n")

//
// Module name
//
print(ANSIColors.blue + "Type module name: ", terminator: ANSIColors.def + "")

guard let moduleName = readLine()?.capitalized, moduleName.characters.count > 0 else {
    printError("\nWrong module name! See `vipergen --help`")
    exit(0)
}

//
// Available modules
//
var templates: [String] = []
do {
    templates.append(contentsOf: try templatesService.templates())
} catch let e as TemplatesError {
    printError(e.message)
    exit(0)
}
print(ANSIColors.blue + "\nAvailable templates:", terminator: ANSIColors.def + "\n")
printListOfTemplates(templates)
print(ANSIColors.blue + "\nType number of template: ", terminator: ANSIColors.def + "")

guard let input = readLine(), let templateNumber = Int(input), templateNumber < templates.count else {
    printError("Incorrect template number!")
    exit(0)
}

//
// Has module output handler
//

print(ANSIColors.blue + "\nAdd module output handler (\(moduleName)ModuleOutput.swift)?  (y/n): ", terminator: ANSIColors.def + "")
var hasOutputHandler = false
if let outputHandlerCommand = readLine(), (outputHandlerCommand.lowercased() == "y" || outputHandlerCommand.lowercased() == "yes") {
    hasOutputHandler = true
}


