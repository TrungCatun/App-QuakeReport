//
//  DataReport.swift
//  QuakeReport
//
//  Created by Trung on 11/14/18.
//  Copyright © 2018 Trung. All rights reserved.
//

import Foundation

class QuakeInfo {
//    var timeInterval: TimeInterval = 0.0
    var dateString: String
    var timeString: String
    var distanceString: String
    var locationName: String
    var mag: Double
    var url: String
    var detail: String
//    var abcdxx: String
    
    //
    var felt: Double?
    var cdi: Double?
    var mmi: Double?
    var alert: String?
   
    var eventTime: String?
    var latitude: String?
    var longitude: String?
    var depth: String?
    

    
    init( mag: Double,  place: String, timeInterval: TimeInterval, url: String, detail: String) {
        self.mag = mag
        self.url = url
        self.detail = detail
//        self.abcdxx = abcdxx
        
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
        //        dateFormater.locale = Locale(identifier: "vi")
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
    
    
    func loadDetailData(dictDetail: JSON) {
        
        guard let felt = dictDetail["felt"] as? Double else {return }
        guard let cdi = dictDetail["cdi"] as? Double else {return }
        guard let mmi = dictDetail["mmi"] as? Double else {return }
        guard let alert = dictDetail["alert"] as? String else {return }
        
        guard let eventTime = dictDetail["eventtime"] as? String else {return }
        guard let latitude = dictDetail["latitude"] as? String else {return }
        guard let longitude = dictDetail["longitude"] as? String else {return }
        guard let depth = dictDetail["depth"] as? String else {return }
        
        self.felt = felt
        self.cdi = cdi
        self.mmi = mmi
        self.alert = alert
        self.eventTime = eventTime
        self.longitude = longitude
        self.latitude = latitude
        self.depth = depth
        
        }
    
    }
  




