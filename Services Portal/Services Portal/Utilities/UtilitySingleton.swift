//
//  PrettyPrintJsonSingleton.swift
//  Services Portal
//
//  Created by David Wilson on 3/30/22.
//

import UIKit

class UtilitySingleton: NSObject {

    static let sharedSingleton = UtilitySingleton()
    
    func constructUri(baseUri:String, pattern:String, newString:String ) -> String {
        let uri = baseUri
        let replaced = uri.replacingOccurrences(of: pattern, with: newString)
        return replaced
    }
    
    func indentScope(i: Int, s: String) -> String {
        var os: String = s
        for _ in 0..<i {
            os.append("  ")
        }
        return os
    }
    
    func numbericSpellout( value: Int ) -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        formatter.numberStyle = .spellOut
        let formattedString : String = formatter.string(from: NSNumber(value: value))!
        return formattedString
    }
    
    func appendColored( text: String, colorText: String, color: UIColor) -> NSMutableAttributedString {
        let attributsBold = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .bold), NSAttributedString.Key.foregroundColor: color]
        let attributsNormal = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .regular)]
        let normal = NSMutableAttributedString(string: text, attributes:attributsNormal)
        let hightlighted = NSMutableAttributedString(string: colorText, attributes:attributsBold)
        normal.append(hightlighted)
        return normal
    }
    
    func prettyPrintJSON( json: String) -> String {
        var indent = 0
        var output: String = ""
        for (_,ch) in json.enumerated() {
            switch ch {
            case "{":
                output.append(ch)
                output.append("\n")
                indent += 1
                output = indentScope(i: indent, s: output)
            case "}":
                output.append("\n")
                indent -= 1
                output = indentScope(i: indent, s: output)
                output.append(ch)
            case ",":
                output.append(ch)
                output.append("\n")
                output = indentScope(i: indent, s: output)
            case ":":
                output.append(" ")
                output.append(ch)
                output.append(" ")
            default:
                //output = indentScope(i: indent, s: output)
                output.append(ch)
            }
        }
        return output
    }
}
