//
//  ModalController.swift
//  Master-DetailApp
//
//  Created by Paweł Gałka on 02.06.2020.
//  Copyright © 2020 Paweł Gałka. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation


class ModalController: UIViewController{
    
    var searchResults = [Location]()
    
    var apiConnector: ApiConnector = ApiConnector()
    
    var parentController: UIViewController?

    var manager:CLLocationManager!

    var geocoder = CLGeocoder()

    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var actualPosition: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func searchAction(_ sender: Any) {
        apiConnector.queryLocation(city: (searchText?.text)!) {array in
            print(array)
            self.searchResults = array
            DispatchQueue.main.async {
                self.actualPosition?.text = "Search results:"
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func fetchCurrentLocation(_ sender: Any) {
        manager.requestLocation()        
    }
    
    @IBAction func backToMaster(_ sender: Any){
        dismiss(animated: false) {}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ModalController: UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate{
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
        (presentingViewController?.children[0] as? MasterViewController)?.fetchNewCity(cityName: searchResults[indexPath.row].title!)
        dismiss(animated: false) {}
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let current = manager.location!.coordinate
        geocoder.reverseGeocodeLocation(manager.location!) { (placemarks, error) in
            self.apiConnector.queryLocation(latt: String(describing: current.latitude), long: String(describing: current.longitude), completion: { locationArray in
                self.searchResults = Array(locationArray[0..<1])
                DispatchQueue.main.async {
                    self.actualPosition?.text = "Your actual position is:"
                    self.tableView.reloadData()
                }
            })
        }
    }
}
