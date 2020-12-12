//
//  WeatherManager.swift
//  Clima
//
//  Created by macbook on 23/11/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherUrl =
        "http://api.openweathermap.org/data/2.5/weather?APPID=250ca9112574e913ebc403ac0bf005b3"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName:String){
        let urlString = "\(weatherUrl)&q=\(cityName)"
        print(urlString)
        
        
    }
    
    //Networking
    func performRequest(urlString: String){
        //1.Create URL
        if let url = URL(string: urlString){
            //2.Create URL Session
            let session = URLSession(configuration: .default)
            //3.give the session a task
            let task = session.dataTask(with: url) { (data, urlResponse, error) in
                
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                
                if let safeData = data{
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(weatherManager: self, weather: weather)
                    }
                }
            }
            //4.start the task
            task.resume()
        }
    }
    
    func parseJson(_ weatherData: Data) -> WeatherModel?{
            let decoder = JSONDecoder()
            do{
                let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
                let id = decodedData.weather[0].id
                let temp = decodedData.main.temp
                let name = decodedData.name
                
                let weather =  WeatherModel(condition: id, name: name, temperature: temp)
                return weather
                
            }catch{
                delegate?.didFailWithError(error: error)
                return nil
            }
        }
    }
