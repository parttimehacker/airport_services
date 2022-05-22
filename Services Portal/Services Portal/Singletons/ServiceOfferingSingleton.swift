//
//  ServiceCategorySingleton.swift
//  Services Portal
//
//  Created by David Wilson on 3/30/22.
//

import UIKit

class ServiceOfferingSingleton: NSObject {

    static let sharedSingleton = ServiceOfferingSingleton()
    
    let network = NetworkSingleton.sharedSingleton
    let util = UtilitySingleton.sharedSingleton
    
    enum Search {
        case id, title, description
    }

    struct AirportInfo : Codable {
        var iata_code:  String?
        var icao_code:  String?
        var name:       String?
        var utc_offset: String?
        var timezone:   String?
    }
    
    struct ServiceTypeInfo : Codable {
        var code:           String?
    }
    
    struct ServiceCategoryInfo : Codable {
        var id:             Int?
        var parent:         Int?
        var code:           String?
    }
    
    struct OperationHoursInfo : Codable {
        var operating_hours:    String?
        var osm_format:         String?
        var schema_format:      String?
    }
    
    struct AirportCategoryInfo : Codable {
        var id:                 Int?
        var airport:            AirportInfo?
        var service_type:       ServiceTypeInfo?
        var service_category:   ServiceCategoryInfo?
        var operating_hours:    OperationHoursInfo?
        var title:              String?
        var subtitle:           String?
        var description:        String?
        var is_bookable:        Bool?
        var booking_url:        String?
        var information_url:    String?
        var support_url:        String?
        var image_url:          String?
        var phone:              String?
        var email:              String?
    }
    
    var array:             [AirportCategoryInfo] = []
    var clone:             [AirportCategoryInfo] = []
    
    override private init() {
        super.init()
    }

    func parse() {
        array.removeAll()
        do {
            let decoder = JSONDecoder()
            array = try decoder.decode([AirportCategoryInfo].self, from: network.rawData!)
            // let jsonData = try! JSONEncoder().encode(array)
            // let jsonString = String(data: jsonData, encoding: .utf8)!
            // plist.savePlistFile(filename: "facilities", plist: jsonString)
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
    
    func searchAirports( type_code: String, iata_code: String ) -> Int {
        for i in 0..<array.count {
            if array[i].service_type?.code == type_code {
                if array[i].airport?.iata_code == iata_code {
                    return i
                }
            }
        }
        return -1
    }
    
    func swapClone(restore: Bool) {
        if restore {
            array = clone
        } else {
            clone = array
        }
    }
    
    func find( key:String, search:Search ) -> Int {
        for (index,item) in array.enumerated() {
            switch search {
            case .title:
                if item.title == key {
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
