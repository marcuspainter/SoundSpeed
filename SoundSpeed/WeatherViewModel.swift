//
//  WeatherViewModel.swift
//  SoundWeather
//
//  Created by Marcus Painter on 10/12/2023.
//

import Foundation
import WeatherKit
import CoreLocation

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var temperature: Measurement = Measurement(value: 0.0, unit: UnitTemperature.celsius)
    @Published var pressure: Measurement = Measurement(value: 0.0, unit: UnitPressure.kilopascals)
    @Published var humidity: Double = 0.0
    
    var temperatureSI: Double {
        self.temperature.converted(to: .celsius).value
    }
    var pressureSI: Double {
        self.pressure.converted(to: .kilopascals).value
    }
    var humiditySI: Double {
        self.humidity
    }
    
    @Published var symbolName: String = "house"
    
    @Published var temperatureText: Double = 0.0
    
    var temperatureUnit: UnitTemperature = .celsius
    var pressureUnit: UnitPressure = .kilopascals
    
    private let weatherService =  WeatherService()
    
    func getWeather(location: CLLocation) {
        Task {
            do {
                let result = try await weatherService.weather(for: location)
                
                // Uses MainActor instead of DispatchQueue.main.async()
                self.symbolName = result.currentWeather.symbolName
                
                self.temperature = result.currentWeather.temperature
                self.pressure = result.currentWeather.pressure
                self.humidity = result.currentWeather.humidity * 100 // Percent
               
                print(result.currentWeather.temperature.unit)
                 
            } catch {
                print("Error: ", error)
            }
        }
    }
    
}
