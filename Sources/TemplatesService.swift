//
//  TemplateFetchService.swift
//  vipergen
//
//  Created by IVAN CHIRKOV on 05.10.16.
//
//

import Foundation

enum TemplatesError: Error {
    case configFileNotFound
    case configFileNotReadable
    case configInvalidFormat
    case templatesNotFetched
}

extension TemplatesError {
    
    var message: String {
        switch self {
        case .configFileNotFound:
            return "\(TemplatesService.configFileName) file not found!"
        case .configFileNotReadable:
            return "Cannot read the contents of the configuration file!"
        case .configInvalidFormat:
            return "The configuration file has incorrect format!"
        case .templatesNotFetched:
            return "Templates not fetched! Create vipergen.json file in root directory of project and run `vipergen fetch`"
        }
    }
    
}

public class TemplatesService {
    
    typealias JSON = [String: Any]
    
    static let configFileName = ".vipergen.json"
    static let templatesDir = "./.templates"
    
    private let fileManager = FileManager.default
    
    public func fetchTemplates() throws {
        let pathToConfigFile = "./\(TemplatesService.configFileName)"
        guard fileManager.fileExists(atPath: pathToConfigFile) else {
            throw TemplatesError.configFileNotFound
        }
        
        guard let data = fileManager.contents(atPath: pathToConfigFile) else {
            throw TemplatesError.configFileNotReadable
        }
        
        guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [JSON], let templates = json else {
            throw TemplatesError.configInvalidFormat
        }
        
        if fileManager.fileExists(atPath: TemplatesService.templatesDir) {
            try? fileManager.removeItem(atPath: TemplatesService.templatesDir)
        }
        
        for template in templates {
            guard let git = template["git"] as? String, let name = template["name"] as? String else {
                throw TemplatesError.configInvalidFormat
            }
            let branchOrTag: String!
            if let tag = template["tag"] as? String {
                branchOrTag = tag
            } else if let branch = template["branch"] as? String {
                branchOrTag = branch
            } else {
               throw TemplatesError.configInvalidFormat
            }
            
            _ = shell("git", "clone", "--branch", branchOrTag, git, "\(TemplatesService.templatesDir)/\(name)")
        }
    }
    
    public func templates() throws -> [String] {
        guard fileManager.fileExists(atPath: TemplatesService.templatesDir) else {
            throw TemplatesError.templatesNotFetched
        }
        guard let folders = try? fileManager.contentsOfDirectory(atPath: TemplatesService.templatesDir) else {
            throw TemplatesError.templatesNotFetched
        }
        
        return folders
    }
    
}
