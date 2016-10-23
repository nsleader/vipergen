//
//  TemplateFetchService.swift
//  vipergen
//
//  Created by IVAN CHIRKOV on 05.10.16.
//
//

import Foundation
import Mustache
import Yaml

enum TemplatesError: Error {
    case configFileNotFound
    case configFileNotReadable
    case configInvalidFormat
    case configFileNotCreated
    case configFileAlreadyExits
    case templatesNotFetched
    case moduleAlreadyExits
    case moduleFolderIsEmpty
}

extension TemplatesError {
    
    var message: String {
        switch self {
        case .configFileNotFound:
            return "Config file (\(TemplatesService.configFileName)) not found!\nTo create config file run `vipergen init` in root directory of project"
        case .configFileNotReadable:
            return "Cannot read the contents of the configuration file (\(TemplatesService.configFileName))!"
        case .configInvalidFormat:
            return "The configuration file (\(TemplatesService.configFileName)) has incorrect format!"
        case .configFileAlreadyExits:
            return "The configuration file already exits!"
        case .configFileNotCreated:
            return "Config file (\(TemplatesService.configFileName)) not created! Unknown error"
        case .templatesNotFetched:
            return "Templates not fetched!\nCreate \(TemplatesService.configFileName) file in root directory of project and run `vipergen fetch`\nTo create config file run `vipergen init` in root directory of project"
        case .moduleAlreadyExits:
            return "Module already exits"
        case .moduleFolderIsEmpty:
            return "Module folder is empty!"
        }
    }
    
}

public class TemplatesService {
    
    typealias JSON = [String: Any]
    
    static let configFileName = "vipergen.yml"
    static let configFilePath = "./\(TemplatesService.configFileName)"
    static let templatesDir = "./Templates"
    static let generatedDir = "./GeneratedModules"
    
    private let fileManager = FileManager.default
    
    public func createConfigFile() throws {
        if fileManager.fileExists(atPath: TemplatesService.configFilePath) {
            throw TemplatesError.configFileAlreadyExits
        }
        
        let configString = "\n" +
            "company_name: 65apps\n" +
            "developer_name: IVAN CHIRKOV\n\n" +
            "templates:\n" +
            "  -\n" +
            "    name: ViewController\n" +
            "    git: https://github.com/nsleader/ViewControllerModule.git\n" +
            "    # tag: 0.1.0\n" +
            "    branch: master"
        
        if let data = configString.data(using: .utf8) {
            fileManager.createFile(atPath: TemplatesService.configFilePath, contents: data, attributes: nil)
        } else {
            throw TemplatesError.configFileNotCreated
        }
    }
    
    public func fetchTemplates() throws {
        guard fileManager.fileExists(atPath: TemplatesService.configFilePath) else {
            throw TemplatesError.configFileNotFound
        }
        
        let conf = try config()
        
        guard let templates = conf["templates"].array else {
            throw TemplatesError.configInvalidFormat
        }
        
        if fileManager.fileExists(atPath: TemplatesService.templatesDir) {
            try? fileManager.removeItem(atPath: TemplatesService.templatesDir)
        }
        
        for template in templates {
            guard let git = template["git"].string, let name = template["name"].string else {
                throw TemplatesError.configInvalidFormat
            }
            let branchOrTag: String!
            if let tag = template["tag"].string {
                branchOrTag = tag
            } else if let branch = template["branch"].string {
                branchOrTag = branch
            } else {
                throw TemplatesError.configInvalidFormat
            }
            
            _ = shell("git", "clone", "--branch", branchOrTag, git, "\(TemplatesService.templatesDir)/\(name)")
        }
    }
    
    public func templates() throws -> [String] {
        
        guard fileManager.fileExists(atPath: TemplatesService.configFilePath) else {
            throw TemplatesError.configFileNotFound
        }
        
        guard fileManager.fileExists(atPath: TemplatesService.templatesDir) else {
            throw TemplatesError.templatesNotFetched
        }
        
        let url = URL(fileURLWithPath: TemplatesService.templatesDir, isDirectory: true)
        guard let urls = try? fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: [.nameKey, .isDirectoryKey], options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants]), urls.count > 0 else {
            throw TemplatesError.templatesNotFetched
        }
        var folders: [String] = []
        for url in urls {
            let values = try url.resourceValues(forKeys: [.nameKey, .isDirectoryKey])
            if let isDirectory = values.isDirectory, isDirectory, let name = values.name {
                folders.append(name)
            }
        }
        return folders
    }
    
    func templatePathByNumber(_ number: Int) throws -> String {
        let templateName = try templates()[number]
        return TemplatesService.templatesDir + "/" + templateName
    }
    
    public func createModule(name: String, templateNumber: Int, withOutputHandler: Bool) throws -> String {
        if !fileManager.fileExists(atPath: TemplatesService.generatedDir) {
            try fileManager.createDirectory(atPath: TemplatesService.generatedDir, withIntermediateDirectories: false, attributes: nil)
        }
        
        let templatePath = try templatePathByNumber(templateNumber)
        let newModulePath = TemplatesService.generatedDir + "/" + name + "Module"
        do {
            try fileManager.copyItem(atPath: templatePath, toPath: newModulePath)
        } catch let e as NSError {
            if e.code == 516 {
                throw TemplatesError.moduleAlreadyExits
            } else {
                throw e
            }
        }
        
        let newModuleURL = URL(fileURLWithPath: newModulePath, isDirectory: true)
        
        guard let enumerator = fileManager.enumerator(at: newModuleURL, includingPropertiesForKeys: [.nameKey], options: [.skipsHiddenFiles], errorHandler: nil) else {
            throw TemplatesError.moduleFolderIsEmpty
        }
        
        let data = try dataForModule(name: name, withOutputHandler: withOutputHandler)
        
        while let url = enumerator.nextObject() as? URL {
            let values = try url.resourceValues(forKeys: [.nameKey])
            guard let fileName = values.name, fileName.contains("{{ModuleName}}") else {
                continue
            }
            if fileName.contains("ModuleOutput") && !withOutputHandler {
                try fileManager.removeItem(at: url)
                continue
            }
            
            let newFilePath = url.path.replacingOccurrences(of: "{{ModuleName}}", with: name)
            try fileManager.moveItem(atPath: url.path, toPath: newFilePath)
        
            let template = try Template(path: newFilePath)
            
            let result = try template.render(data)
            try result.write(toFile: newFilePath, atomically: false, encoding: .utf8)
        }
        return newModulePath
    }
    
    func dataForModule(name: String, withOutputHandler: Bool) throws -> [String: Any?] {
        let conf = try config()
        
        let now = Date()
        let components = Calendar.current.dateComponents([.day, .month, .year], from: now)
        
        let data: [String: Any?] = [
            "DATE" : [
                "dd"    : components.day! < 10 ? "0\(components.day!)" : String(components.day!),
                "MM"    : components.month! < 10 ? "0\(components.month!)" : String(components.month!),
                "yy"    : components.year! - 2000,
                "yyyy"  : components.year!
            ],
            "CONFIG" : [
                "DEVELOPER_NAME"    : conf["developer_name"].string ?? "Developer Name",
                "COMPANY_NAME"      : conf["company_name"].string ?? "Company Name"
            ],
            "ModuleName" : name,
            "withOutputHandler" : withOutputHandler
        ]
        return data
    }
    
    func config() throws -> Yaml {
        guard let configData = fileManager.contents(atPath: TemplatesService.configFilePath) else {
            throw TemplatesError.configFileNotReadable
        }
        
        guard let configContent = String(data: configData, encoding: .utf8) else {
            throw TemplatesError.configInvalidFormat
        }
        return try Yaml.load(configContent)
    }
    
}
