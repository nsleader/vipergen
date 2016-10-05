import PackageDescription

let package = Package(
	name: "vipergen",
	dependencies: [
        .Package(url: "https://github.com/nsleader/Mustache.git", majorVersion: 1, minor: 0),
    ]
)
