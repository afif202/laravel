//
//  WeatherData.swift
//  Clima
//
//  Created by macbook on 24/11/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name : String
    let main : Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
}

struct Weather:Decodable {
    let description:Double
    let id:Int
}
