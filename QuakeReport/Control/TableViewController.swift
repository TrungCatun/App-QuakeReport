//
//  TableViewController.swift
//  QuakeReport
//
//  Created by Trung on 11/14/18.
//  Copyright © 2018 Trung. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
 
    var quakeInfos: [QuakeInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
      
        DataServices.share.getDataQuake { quakeInfos in
           self.quakeInfos = quakeInfos
           self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quakeInfos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell

        cell.magLabel.text = String(describing: quakeInfos[indexPath.row].mag)
        cell.distanceLable.text = quakeInfos[indexPath.row].distanceString
        cell.locationLable.text = quakeInfos[indexPath.row].locationName
        cell.dateLable.text = quakeInfos[indexPath.row].dateString
        cell.timeLable.text = quakeInfos[indexPath.row].timeString
        
        return cell
    }
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let toWebControler = segue.destination as? WebViewController {
            if let index = tableView.indexPathForSelectedRow {
                toWebControler.urlOfRow = quakeInfos[index.row].url
                
//                DataServices.share.urlStringDetail = quakeInfos[index.row].detail

            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        var arrayData : [String] = []
        DataServices.share.selectedQuake = quakeInfos[indexPath.row]
//        print(quakeInfos[indexPath.row])
        
        
    }

}
