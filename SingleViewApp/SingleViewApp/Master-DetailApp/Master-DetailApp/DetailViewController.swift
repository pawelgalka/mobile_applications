//
//  DetailViewController.swift
//  Master-DetailApp
//
//  Created by Paweł Gałka on 02.06.2020.
//  Copyright © 2020 Paweł Gałka. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var MainStack: UIStackView!
    
    @IBAction func Prev(_ sender: UIButton) {
        self.id -= 1
        loadWeather(self.id)
    }
    
    @IBAction func Next(_ sender: UIButton) {
        self.id += 1
        loadWeather(self.id)
        
    }
    
    @IBOutlet weak var PrevButton: UIButton!
    @IBOutlet weak var NextButton: UIButton!
    
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var Cityname: UILabel!
    @IBOutlet weak var CurrentDay: UILabel!
    @IBOutlet weak var Cond: UILabel!
    
    @IBOutlet weak var MinTemp: UILabel!
    @IBOutlet weak var MaxTemp: UILabel!
    @IBOutlet weak var WindSpeed: UILabel!
    @IBOutlet weak var WindDir: UILabel!
    @IBOutlet weak var RainForecast: UILabel!
    @IBOutlet weak var AirPressure: UILabel!
    
    let imageEndpointURL = "https://www.metaweather.com/static/img/weather/png/64/IMAGE.png"
    let apiPattern = "https://www.metaweather.com/api/location/"
    var cityData : CellData?{
        didSet{
            loadWeather(0)
        }
    }
    
    var id = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.cityData != nil {
            loadWeather(0)
        }
        
    }
    
    
    func loadWeather(_ id: Int) -> Void{
        let forecast = self.cityData!.forecasts![id]
        
        DispatchQueue.main.async {
            self.Cityname.text = self.cityData?.name
            self.Cond.text = forecast.weather_state_name
            self.CurrentDay.text = forecast.applicable_date
            self.MinTemp.text = String(format:"%.1f",forecast.min_temp!) + " °C"
            self.MaxTemp.text = String(format:"%.1f",forecast.max_temp!) + " °C"
            self.WindSpeed.text = String(format:"%.1f",forecast.wind_speed!) + " km/h"
            self.WindDir.text = String(forecast.wind_direction_compass!)
            self.RainForecast.text = String(forecast.predictability!) + " %"
            self.AirPressure.text = String(forecast.air_pressure!) + " hPa"
            self.PrevButton.isEnabled = id != 0;
            self.NextButton.isEnabled = id != 5;
        }
        self.loadImage(forecast.weather_state_abbr)
        
    }
    
    func loadImage(_ icon: String?) {
        DispatchQueue.main.async {
            guard let unwWeatherStateAbbr = icon else { return }
            let imageString =  self.imageEndpointURL.replacingOccurrences(of: "IMAGE", with: unwWeatherStateAbbr)
            let imageUrl = URL(string: imageString)
            
            guard let unwImageUrl = imageUrl else { return }
            let data = try? Data(contentsOf: unwImageUrl)
            
            if let imageData = data {
                self.Image.image = UIImage(data: imageData)
            }
            
        }
        
    }


}

