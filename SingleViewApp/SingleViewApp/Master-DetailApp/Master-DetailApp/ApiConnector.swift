//
//  ApiConnector.swift
//  Master-DetailApp
//
//  Created by Paweł Gałka on 02.06.2020.
//  Copyright © 2020 Paweł Gałka. All rights reserved.
//

import Foundation

class ApiConnector {
    let locationQueryEndpoint = "https://www.metaweather.com/api/location/search/?query="
    let weatherQueryEndpoint = "https://www.metaweather.com/api/location/"
    let imageQueryEndpoint = "https://www.metaweather.com/static/img/weather/png/64/IMAGE.png"

    func queryLocation(city: String, completion: @escaping ([Location]) -> ()){
        let urlString = "\(locationQueryEndpoint)\(city)"
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url){(data, response, error) in
            guard let data = data, error == nil else {
                print("Connection error")
                return
            }
            do{
                let json = try JSONDecoder().decode([Location].self, from: data)
                print("Loaded")
                completion(json)
            } catch let jsonErr{
                print("Error serializing json \(jsonErr)")
            }
        }
        task.resume()
    }

    func queryWeather(woeid: Int, completion: @escaping ([ForecastItem]) -> ()){
        let urlString = "\(weatherQueryEndpoint)\(woeid)"
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url){(data, response, error) in
            guard let data = data, error == nil else {
                print("Connection error")
                return
            }
            do{
                let json = try JSONDecoder().decode(Forecast.self, from: data)
                print("Loaded weather for \(woeid)")
                completion(json.consolidated_weather!)
            } catch let jsonErr{
                print("Error serializing json \(jsonErr)")
            }
        }
        task.resume()
    }
    
    func queryImage(icon: String?, completion: @escaping(Data) ->()){
        DispatchQueue.main.async {
            guard let unwWeatherStateAbbr = icon else { return }
            let imageString =  self.imageQueryEndpoint.replacingOccurrences(of: "IMAGE", with: unwWeatherStateAbbr)
            let imageUrl = URL(string: imageString)
            
            guard let unwImageUrl = imageUrl else { return }
            let data = try? Data(contentsOf: unwImageUrl)
            
            if let imageData = data {
                completion(imageData)
            }
            
        }
    }
}

struct Location : Decodable{
    let title: String
    let location_type : String?
    let woeid : Int?
    let latt_long: String?
}

struct ForecastItem : Decodable{
    let id: Int
    let weather_state_name: String?
    let weather_state_abbr: String?
    let wind_direction_compass: String?
    let created: String?
    let applicable_date: String?
    let min_temp: Double?
    let max_temp: Double?
    let the_temp: Double?
    let wind_speed: Double?
    let wind_direction: Double?
    let air_pressure: Double?
    let humidity: Int?
    let visibility: Double?
    let predictability: Int?
}

struct Forecast : Decodable{
    let consolidated_weather : [ForecastItem]?
}

