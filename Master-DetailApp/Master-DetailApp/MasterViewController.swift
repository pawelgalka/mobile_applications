//
//  MasterViewController.swift
//  Master-DetailApp
//
//  Created by Paweł Gałka on 02.06.2020.
//  Copyright © 2020 Paweł Gałka. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    @IBOutlet weak var addCity: UIButton!
    
    @IBAction func touch(_ sender: UIButton) {
        print("touched")
        
    }
    var detailViewController: DetailViewController? = nil
    var objects = [Any]()
    var apiConnector: ApiConnector = ApiConnector()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem

        fillInitialCities()
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    func fillInitialCities() -> Void {
        print("FILLING")
        let cities = ["Warsaw", "Berlin", "Prague"]
        cities.forEach{cityName in
            print(cityName)
            self.apiConnector.queryLocation(city: cityName, completion: { array in
                if (array.count == 0){
                    return
                }
                self.fillCityWeatherState(array)
            })}
    }
    
    func fillCityWeatherState(_ array: ([Location])) {
        let foundCityWeather = array[0]
        var cellData = CellData()
        cellData.name = foundCityWeather.title
        var prepared = foundCityWeather.latt_long?.components(separatedBy: ",")
        cellData.latt = prepared![0]
        cellData.long = prepared![1]
        self.apiConnector.queryWeather(woeid: foundCityWeather.woeid!, completion: { weather in
            cellData.forecasts = weather
            cellData.temp = String(format:"%.1f",weather[0].the_temp!) + " °C"
            self.apiConnector.queryImage(icon: weather[0].weather_state_abbr){imageData in
                cellData.image = UIImage(data: imageData)
                self.objects.insert(cellData, at: 0)
                let indexPath = IndexPath(row: 0, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            }
        })
    }

    func fetchNewCity(cityName: String){
        self.apiConnector.queryLocation(city: cityName, completion: { array in
            if (array.count == 0){
                return
            }
            self.fillCityWeatherState(array)
        })
        
    }
    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row] as! CellData
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.cityData = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let object = objects[indexPath.row] as! CellData
        let cityName = cell.contentView.viewWithTag(1) as? UILabel
        let temp = cell.contentView.viewWithTag(2) as? UILabel
        let image = cell.contentView.viewWithTag(3) as? UIImageView
        cityName?.text = object.name
        temp?.text = object.temp
        image?.image = object.image
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

}

struct CellData {
    var name : String?
    var temp : String?
    var latt : String?
    var long : String?
    var image : UIImage?
    var forecasts : [ForecastItem]?
    init (name: String? = nil,
          temp: String? = nil,
          latt: String? = nil,
          long: String? = nil,
          image: UIImage? = nil,
          forecasts: [ForecastItem]? = nil){
        self.name = name
        self.temp = temp
        self.image = image
        self.forecasts = forecasts
        self.long = long
        self.latt = latt
    }
}

