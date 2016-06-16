//
//  ANSIColors.swift
//  vipergen
//
//  Created by IVAN CHIRKOV on 15.06.16.
//  Copyright © 2016 IVAN CHIRKOV. All rights reserved.
//

import Foundation

enum ANSIColors: String {
    case black = "\u{001B}[0;30m"
    case red = "\u{001B}[0;31m"
    case green = "\u{001B}[0;32m"
    case yellow = "\u{001B}[0;33m"
    case blue = "\u{001B}[0;34m"
    case magenta = "\u{001B}[0;35m"
    case cyan = "\u{001B}[0;36m"
    case white = "\u{001B}[0;37m"
    case def = "\u{001B}[0;39m"
    case udef = "\u{001B}[4;39m"
    
    func name() -> String {
        switch self {
        case black: return "Black"
        case red: return "Red"
        case green: return "Green"
        case yellow: return "Yellow"
        case blue: return "Blue"
        case magenta: return "Magenta"
        case cyan: return "Cyan"
        case white: return "White"
        case def: return "Default"
        case .udef: return "Underline default"
        }
    }
    
    static func all() -> [ANSIColors] {
        return [.black, .red, .green, .yellow, .blue, .magenta, .cyan, .white]
    }
}

func + (let left: ANSIColors, let right: String) -> String {
    return left.rawValue + right
}