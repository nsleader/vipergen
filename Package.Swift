import PackageDescription

let package = Package(
	name: "vipergen",
	dependencies: [
        .Package(url: "https://github.com/groue/GRMustache.swift.git", majorVersion: 2, minor: 0),
        .Package(url: "https://github.com/behrang/YamlSwift.git", majorVersion: 3)
    ]
)
