//
//  ACRISNetworkSingleton.swift
//  Services Portal
//
//  Created by David Wilson on 5/4/22.
//

import UIKit

class ACRISNetworkSingleton: NSObject {

    static let sharedSingleton = ACRISNetworkSingleton()
    
    var info: [Dictionary<String,AnyObject>] = []
    var array: [Any] = []
    var rawData : Data? = nil
    
    var infoSession = URLSession.shared
    
    let infoRestUri:String?
    
    private override init() {
        infoRestUri = "https://airport-services-dev.rockportsoft.com/"
    }
    
    func httpsGetRawDataInfoPropertyList( uri:String, successNotif:Notification.Name, failureNotif:Notification.Name) {
        let url = infoRestUri! + uri
        //print(url)
        guard let httpUrl = URL(string: url) else { return }
        var request:URLRequest = URLRequest.init(url: httpUrl)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = infoSession.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if error != nil {
                print(error!.localizedDescription)
                print(httpUrl)
            } else {
                do {
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            self.rawData = data!
                            NotificationCenter.default.post(name: successNotif, object: nil)
                        } else {
                            print(error as Any)
                            print(httpResponse.statusCode)
                            print(httpUrl)
                            NotificationCenter.default.post(name: failureNotif, object: nil)
                        }
                    }
                }
            }
        }
        task.resume()
    }
}
