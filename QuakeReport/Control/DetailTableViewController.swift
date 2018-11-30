//
//  DetailTableViewController.swift
//  QuakeReport
//
//  Created by Trung on 11/27/18.
//  Copyright © 2018 Trung. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {
    var  arrayDataDetail: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        DataServices.share.selectedQuake?.loadDataDetail{ [unowned self] quakeInfo in
            
            let placeOfQuake = quakeInfo.distanceString + " " + quakeInfo.locationName
            self.arrayDataDetail.append("Place: " + placeOfQuake)
            
            self.arrayDataDetail.append("Mag: " + String(quakeInfo.mag))
            
            guard let latitude = quakeInfo.latitude else {return}
            self.arrayDataDetail.append("Latitude: " + latitude)
            
            guard let longitude = quakeInfo.longitude else {return}
            self.arrayDataDetail.append("Longitude: " + longitude)
            
            guard let eventTime = quakeInfo.eventTime else {return}
            self.arrayDataDetail.append("Event Time: " + eventTime)
            
            guard let depth = quakeInfo.depth else {return}
            self.arrayDataDetail.append("Depth: " + depth + " KM")
            
            if let felt = quakeInfo.felt {
                self.arrayDataDetail.append("Felt: " + String(felt))
            }
            if let cdi = quakeInfo.cdi {
                self.arrayDataDetail.append("Cdi: " + String(cdi))
            }
            if let mmi = quakeInfo.mmi {
                self.arrayDataDetail.append("Mmi: " + String(mmi))
            }
            if let alert = quakeInfo.alert {
                self.arrayDataDetail.append("Alert: " + alert)
            }
            self.tableView.reloadData()
        }
    }
    

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayDataDetail.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = arrayDataDetail[indexPath.row]
        return cell
    }

}
