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
    var quakeInfosDetail: QuakeInfo?
    var urlStringDetail = ""
    var selectedQuake : QuakeInfo?
    
    // cho nay chua hieu lam <- "Chua hieu cai con cac" - "Son Hoa Mi"
    // qua trinh request api
    private func makeDataTaskRequest(request: URLRequest, completedBlock: @escaping (JSON) -> Void ) {
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
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
            DispatchQueue.main.async {
                completedBlock(json)
            }
        }
        task.resume()
        
    }
    

    // lay du lieu tu file json da request ve
    func getDataQuake(completeHandler: @escaping ([QuakeInfo]) -> Void) { // gia tri tra ve luu vao completeHandler
        
        // chuyen url tu string sang urlRequest
        guard let url = URL(string: urlString) else {return}
        let urlRequest = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 10)
        
        quakeInfos = [] // reset gia tri cua mang sau moi lan load
        
        makeDataTaskRequest(request: urlRequest) { json in // lay file json ra su dung sau khi da request api ve
            
                if let dictionaryFeatures = json["features"] as? [JSON] {
                    for featureJSON in dictionaryFeatures {
                        if let propertiesJSON = featureJSON["properties"] as? JSON {
                
                            if let quakeInfo = QuakeInfo(dict: propertiesJSON) {
                                self.quakeInfos.append(quakeInfo)
                                print(quakeInfo)
                            }
                        }
                    }
                    completeHandler(self.quakeInfos) // luu mang quakeInfos vao completeHandler
                }
        }
    }
    
    
    func getDataDetail(completeDetail: (QuakeInfo) -> Void) {
        


        guard let urlDetail = URL(string: urlStringDetail) else {return}
        let urlRequestDetail = URLRequest(url: urlDetail, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 1)
        
        makeDataTaskRequest(request: urlRequestDetail) { (jsonDetail) in
            print(self.quakeInfosDetail!.mag)
            guard let dictProperties = jsonDetail["properties"] as? JSON else {return}
            var quakeDetail = self.selectedQuake?.loadDetailData(dictDetail: dictProperties)
                print(quakeDetail)
      
            guard let dictProducts = dictProperties["products"] as? JSON else {return}
            guard let arrayOrigin = dictProducts["origin"] as? JSON else {return}
            guard let propertiesOrigin = arrayOrigin["properties"] as? JSON else {return}
            
           quakeDetail = self.quakeInfosDetail?.loadDetailData(dictDetail: propertiesOrigin)
            print(quakeDetail!)

            
        }

    }
    
}
