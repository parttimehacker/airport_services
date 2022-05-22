//
//  ServiceCategoriesSingleton.swift
//  Services Portal
//
//  Created by David Wilson on 3/30/22.
//

import UIKit

class ServiceCategoriesSingleton: NSObject {

    static let sharedSingleton = ServiceCategoriesSingleton()
    
    let network = NetworkSingleton.sharedSingleton
    let util = UtilitySingleton.sharedSingleton
    
    enum Search {
        case id, code, name, description
    }

    struct ServiceTypeInfo : Codable {
        var id:             Int?
        var code:           String?
        var name:           String?
        var description:    String?
    }
    
    struct ServiceCategoryInfo : Codable {
        var id:             Int?
        var service_type:   ServiceTypeInfo
        var parent:         Int?
        var code:           String
        var name:           String
        var description:    String
    }
    
    var array:             [ServiceCategoryInfo] = []
    
    override private init() {
        super.init()
    }
    
    func fixNil() {
        for i in 0...array.count-1 {
            if array[i].parent == nil {
                array[i].parent = -1
            }
        }
    }

    func parse() {
        array.removeAll()
        do {
            let decoder = JSONDecoder()
            array = try decoder.decode([ServiceCategoryInfo].self, from: network.rawData!)
            fixNil()
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            print("error: ", error)
        }
    }
    
    func find( key:String, search:Search ) -> Int {
        for (index,item) in array.enumerated() {
            switch search {
            case .code:
                if item.code == key {
                    return index
                }
            case .name:
                if item.name == key {
                    return index
                }
            case .description:
                if item.description == key {
                    return index
                }
            default:
                if item.id == Int(key) {
                    return index
                }
            }
        }
        return -1
    }
    
    func printJSON( index: Int ) -> String {
        let jsonData = try! JSONEncoder().encode(array[index])
        let jsonString = String(data: jsonData, encoding: .utf8)!
        return util.prettyPrintJSON(json: jsonString)
    }
}
