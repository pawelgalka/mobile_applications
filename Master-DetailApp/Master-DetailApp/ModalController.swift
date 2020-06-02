//
//  ModalController.swift
//  Master-DetailApp
//
//  Created by Paweł Gałka on 02.06.2020.
//  Copyright © 2020 Paweł Gałka. All rights reserved.
//

import Foundation
import UIKit

class ModalController: UIViewController{
    
    var searchResults = [Location]()
    
    var apiConnector: ApiConnector = ApiConnector()
    
    var parentController: UIViewController?
    
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func searchAction(_ sender: Any) {
        apiConnector.queryLocation(city: (searchText?.text)!) {array in
            print(array)
            self.searchResults = array
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func backToMaster(_ sender: Any){
        dismiss(animated: false) {}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ModalController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = searchResults[indexPath.row].title
        var prepared = searchResults[indexPath.row].latt_long?.components(separatedBy: ",")
        let lat = String(format:"%.2f",(prepared![0] as NSString).doubleValue)
        let lon = String(format:"%.2f",(prepared![1] as NSString).doubleValue)
        cell.detailTextLabel?.text = "\(lat),\(lon)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(searchResults[indexPath.row].title)
        (presentingViewController?.children[0] as? MasterViewController)?.fetchNewCity(searchResults[indexPath.row].title)
        dismiss(animated: false) {}

        
    }

    
}
