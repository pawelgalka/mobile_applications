//
//  MapViewController.swift
//  Master-DetailApp
//
//  Created by Paweł Gałka on 09.06.2020.
//  Copyright © 2020 Paweł Gałka. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var latt : String?
    var long : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showOnMap(latt: self.latt, long: self.long)
    }
    
    func showOnMap(latt: String?, long: String?){
        print("Debug \(Double(latt!))\(Double(long!))")
        DispatchQueue.main.async {
            let coordinates = CLLocationCoordinate2D(latitude: Double(latt!)!, longitude: Double(long!)!)
            self.mapView.setCenter(coordinates, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            self.mapView.addAnnotation(annotation)
        }
    }
}
