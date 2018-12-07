//
//  TableViewController.swift
//  QuakeReport
//
//  Created by Trung on 11/14/18.
//  Copyright © 2018 Trung. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UISearchResultsUpdating {
 
    var quakeInfos: [QuakeInfo] = []
    var searchController: UISearchController!
    var filterQuake: [QuakeInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80
        updateUserInterface()
        
        DataServices.share.getDataQuake { quakeInfos in
            self.quakeInfos = quakeInfos
            
            // Search
            self.filterQuake = quakeInfos
            self.searchController = UISearchController(searchResultsController: nil) // khoi tao nut search
//            self.tableView.tableHeaderView = self.searchController?.searchBar  // hien nut search
            self.searchController?.searchResultsUpdater = self // update ket qua
            self.searchController?.dimsBackgroundDuringPresentation = false  // true la toi man hinh khi search
            self.navigationItem.searchController = self.searchController  // khi kéo thì moi hien nut search
            self.definesPresentationContext = true // khi false lam mat thanh navigation o man tiep theo
            
            self.tableView.reloadData()
        }
    }
    
    // internet
    func updateUserInterface() {
        guard let status = Network.reachability?.status else { return }
        switch status {
        case .unreachable:
            view.backgroundColor = .white
        case .wifi:
            view.backgroundColor = .green
        case .wwan:
            view.backgroundColor = .yellow
        }
        print("Reachability Summary")
        print("Status:", status)
        print("HostName:", Network.reachability?.hostname ?? "nil")
        print("Reachable:", Network.reachability?.isReachable ?? "nil")
        print("Wifi:", Network.reachability?.isReachableViaWiFi ?? "nil")
    }
    func statusManager(_ notification: Notification) {
        updateUserInterface()
    }
    
    
    // search
    func updateSearchResults(for searchControler: UISearchController) {
        if let searchText = searchController?.searchBar.text, !searchText.isEmpty {
            filterQuake = quakeInfos.filter { (item: QuakeInfo) -> Bool in
                return (item.locationName.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil)
            }
        } else {
            filterQuake = quakeInfos
        }
        tableView.reloadData()
    }

    
     // MARK:
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterQuake.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell

        cell.magLabel.text = String(describing: filterQuake[indexPath.row].mag)
        cell.distanceLable.text = filterQuake[indexPath.row].distanceString
        cell.locationLable.text = filterQuake[indexPath.row].locationName
        cell.dateLable.text = filterQuake[indexPath.row].dateString
        cell.timeLable.text = filterQuake[indexPath.row].timeString
        
        return cell
    }
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let toWebControler = segue.destination as? WebViewController {
            if let index = tableView.indexPathForSelectedRow {
                toWebControler.urlOfRow = filterQuake[index.row].url
            }
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DataServices.share.selectedQuake = filterQuake[indexPath.row]
    }

}
