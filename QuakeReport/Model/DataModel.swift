//
//  DataReport.swift
//  QuakeReport
//
//  Created by Trung on 11/14/18.
//  Copyright © 2018 Trung. All rights reserved.
//

import Foundation

class QuakeInfo {

    var dateString: String
    var timeString: String
    var distanceString: String
    var locationName: String
    var mag: Double
    
    var url: String
    var detail: String
    
    //
    var felt: Double?
    var cdi: Double?
    var mmi: Double?
    var alert: String?
    
    var eventTime: String?
    var latitude: String?
    var longitude: String?
    var depth: String?
    
    var hasDetails = false
    
    
    init( mag: Double,  place: String, timeInterval: TimeInterval, url: String, detail: String) {
        self.mag = mag
        self.url = url
        self.detail = detail
        
        // tach thanh pho va vi tri trong string place
        if place.contains(" of ") {
            let placeDetails = place.components(separatedBy: " of ") // tach string thanh hai phan truoc of va sau of
            self.distanceString = (placeDetails.first ?? "") + " OF"
            self.locationName = placeDetails.last ?? ""
        } else {
            self.distanceString = "NEAR THE"
            self.locationName = place
        }
        
        let dateFormater = DateFormatter()
        dateFormater.timeStyle = .short
        self.timeString = dateFormater.string(from: Date(timeIntervalSince1970: timeInterval * 1/1000))
        dateFormater.timeStyle = .none
        dateFormater.dateStyle = .medium
//        dateFormater.locale = Locale(identifier: "en_US")
        self.dateString = dateFormater.string(from: Date(timeIntervalSince1970: timeInterval * 1/1000))
    }
    
    
    // what happened?
    convenience init?(dict: JSON) {
        guard let mag = dict["mag"] as? Double else {return nil}
        guard let place = dict["place"] as? String else {return nil}
        guard let timeInterval = dict["time"] as? TimeInterval else {return nil}
        guard let url = dict["url"] as? String else {return nil}
        guard let detail = dict["detail"] as? String else {return nil}
        self.init(mag: mag, place: place, timeInterval: timeInterval, url: url, detail: detail)
        
    }
    
    func loadDataDetail(completeHandler: @escaping (QuakeInfo) -> Void) {

        DataServices.share.makeDataTaskRequest(urlString: detail) { (dictDetail) in
            guard let dictProperties = dictDetail["properties"] as? JSON else {return}
            let felt = dictProperties["felt"] as? Double 
            
            let cdi = dictProperties["cdi"] as? Double
            let mmi = dictProperties["mmi"] as? Double
            let alert = dictProperties["alert"] as? String
            self.felt = felt
            self.cdi = cdi
            self.mmi = mmi
            self.alert = alert
            
            guard let dictProducts = dictProperties["products"] as? JSON else {return}
            guard let arrayOrigin = dictProducts["origin"] as? [JSON] else {return}
            guard let dictPropertiesOfOrigin = arrayOrigin[0]["properties"] as? JSON else {return}
            
            
            if let eventTime = dictPropertiesOfOrigin["eventtime"] as? String  {
                var convertEventTime = eventTime
                convertEventTime = convertEventTime.replacingOccurrences(of: "T", with: "  ")
                convertEventTime = convertEventTime.components(separatedBy: ".").first!
                self.eventTime = convertEventTime + " (UTC)"
            }
            
            if let depth = dictPropertiesOfOrigin["depth"] as? String  {
                self.depth = depth + " Km"
            }
            
            // Doi toa do
            guard let latitude = dictPropertiesOfOrigin["latitude"] as? String else {return}
            guard let longitude = dictPropertiesOfOrigin["longitude"] as? String  else {return}
            
            func convertCoordinate(latitude: String, longitude: String) {
                if let latitudeDouble = Double(latitude) {
                    self.latitude = String(format:"%.3f°%@", abs(latitudeDouble), latitudeDouble >= 0 ? "N" : "S")
                }
                if let longitudeDouble = Double(longitude) {
                    self.longitude = String(format:"%.3f°%@", abs(longitudeDouble), longitudeDouble >= 0 ? "E" : "W")
                }
            }
            convertCoordinate(latitude: latitude, longitude: longitude)
           
            completeHandler(self)
        }

    }
}





