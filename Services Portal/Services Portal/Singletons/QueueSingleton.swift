//
//  QueueSingleton.swift
//  Services Portal
//
//  Created by David Wilson on 5/3/22.
//

import UIKit

class QueueSingleton: NSObject {

    static let sharedSingleton = QueueSingleton()
    
    let network = NetworkSingleton.sharedSingleton
    let util = UtilitySingleton.sharedSingleton
    
    enum Search {
        case id, name, display_name
    }
    
    struct TerminalInfo : Codable {
        var airport:            Int?
        var code:               String?
        var name:               String?
        var display_name:       String?
        var international:      Bool?
        var domestic:           Bool?
        var transborder:        Bool?
    }
    
    struct QueueTypeInfo : Codable {
        var code:           String?
        var name:           String?
        var description:    String?
    }
    
    struct QueueStatusInfo : Codable {
        var code:           String?
        var name:           String?
        var description:    String?
    }

    struct OperatingHoursInfo : Codable {
        var title:              String?
        var description:        String?
        var operating_hours:    String?
        var osm_format:         String?
        var schema_format:      String?
    }
    
    struct CheckpointInfo : Codable {
        var airport:            Int?
        var id:                 Int?
        var name:               String?
        var display_name:       String?
        var status:             String?
        var operating_hours:    OperatingHoursInfo?
        var terminal:           TerminalInfo?
    }
    
    struct QueueInfo : Codable {
        var id:                 Int?
        var name:               String?
        var display_name:       String?
        var queue_type:         QueueTypeInfo?
        var queue_status:       QueueStatusInfo?
        var operating_hours:    OperatingHoursInfo?
        var checkpoint:         CheckpointInfo?
    }
    
    var array:             [QueueInfo] = []
    
    // data structures to handle user experience
    
    class Checkpoint {
        var id:                 Int?
        var name:               String?
        var display_name:       String?
        var operating_hours:    String?
        var terminal:           String?
        var queues:             [Int]?
    }
    
    var checkpointQueues: [Checkpoint] = []
    
    override private init() {
        super.init()
    }

    func parse() {
        array.removeAll()
        do {
            let decoder = JSONDecoder()
            array = try decoder.decode([QueueInfo].self, from: network.rawData!)
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
            case .name:
                if item.name == key {
                    return index
                }
            case .display_name:
                if item.display_name == key {
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
    
    func newCheckpoint( queue: QueueInfo, index: Int) {
        let cp = Checkpoint()
        cp.id = queue.checkpoint?.id
        cp.name = queue.checkpoint?.name
        cp.display_name = queue.checkpoint?.display_name
        cp.operating_hours = queue.checkpoint?.operating_hours?.operating_hours
        cp.terminal = queue.checkpoint?.terminal?.display_name
        cp.queues = []
        cp.queues?.append(index)
        checkpointQueues.append(cp)
    }
    
    func analyzeQueues() {
        checkpointQueues.removeAll()
        for (i,q) in array.enumerated() {
            if checkpointQueues.count == 0 {
                newCheckpoint(queue: q, index: i)
            } else {
                var notFound = true
                for (j,c) in checkpointQueues.enumerated() {
                    if q.checkpoint?.id == c.id {
                        notFound = false
                        checkpointQueues[j].queues?.append(i)
                        break
                    }
                }
                if notFound {
                    newCheckpoint(queue: q, index: i)
                }
            }
        }
    }
    
    func printJSON( index: Int ) -> String {
        let jsonData = try! JSONEncoder().encode(array[index])
        let jsonString = String(data: jsonData, encoding: .utf8)!
        return util.prettyPrintJSON(json: jsonString)
    }
    
}
