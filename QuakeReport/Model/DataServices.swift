//
//  DataServices.swift
//  QuakeReport
//
//  Created by Trung on 11/21/18.
//  Copyright © 2018 Trung. All rights reserved.
//

import Foundation

typealias JSON = Dictionary<AnyHashable, Any>

class DataServices {
    static var share = DataServices()
    
    var urlString = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/4.5_week.geojson"
    var quakeInfos : [QuakeInfo] = []
    var arrayDataDetail: [Any] = []
    var selectedQuake : QuakeInfo?
    
    // qua trinh request api
    func makeDataTaskRequest(urlString: String, completedBlock: @escaping (JSON) -> Void ) {
        // chuyen url tu string sang urlRequest
        guard let url = URL(string: urlString) else {return}
        let urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let jsonObject =  try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) else {
                return
            }
            guard let json = jsonObject as? JSON else {
                return
            }
//            print(json)
            DispatchQueue.main.async {
                completedBlock(json)
            }
        }
        task.resume()
        
    }
    
    // lay du lieu tu file json da request ve
    func getDataQuake(completeHandler: @escaping ([QuakeInfo]) -> Void) { // gia tri tra ve luu vao completeHandler
        quakeInfos = [] // reset gia tri cua mang sau moi lan load
        makeDataTaskRequest(urlString: urlString) { [unowned self] json in  // lay file json ra su dung sau khi da request api ve
            guard let dictionaryFeatures = json["features"] as? [JSON] else {return}
            for featureJSON in dictionaryFeatures {
                if let propertiesJSON = featureJSON["properties"] as? JSON {
                    if let quakeInfo = QuakeInfo(dict: propertiesJSON) {
                        self.quakeInfos.append(quakeInfo)
                    }
                }
            }
            completeHandler(self.quakeInfos) // luu mang quakeInfos vao completeHandler
        }
    }
    
}
