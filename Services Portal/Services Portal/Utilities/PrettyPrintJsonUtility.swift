//
//  PrettyPrintJsonSingleton.swift
//  Services Portal
//
//  Created by David Wilson on 3/30/22.
//

import UIKit

class PrettyPrintJsonUtility: NSObject {

    static let sharedSingleton = PrettyPrintJsonUtility()
    
    func indentScope(i: Int, s: String) -> String {
        var os: String = s
        for _ in 0..<i {
            os.append("  ")
        }
        return os
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
