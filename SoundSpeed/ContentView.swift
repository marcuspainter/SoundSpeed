//
//  ContentView.swift
//  Sound Weather
//
//  Created by Marcus Painter on 09/12/2023.
//

import CoreLocation
import SwiftUI
import WeatherKit

struct ContentView: View {
    @StateObject var locationViewModel = LocationViewModel()
    @StateObject var weatherViewModel = WeatherViewModel()
    @StateObject var speedViewModel = SpeedViewModel()

    var speed: Double = 0.0
    
    var body: some View {
        NavigationStack {
           
                Image(systemName: weatherViewModel.symbolName)
                .symbolRenderingMode(.multicolor)
                .symbolVariant(/*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                .background(.background)
                    .imageScale(.large)
                Text(locationViewModel.city)
                    .font(.title)
         
            VStack {
                HStack {
                    Image(systemName: "thermometer.medium")
                        .imageScale(.large)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.red, .primary, .primary)
                    Text(weatherViewModel.temperature.formatted())
                    Text("\(weatherViewModel.temperature.value)")
                        
                }
                
                HStack {
                    Image(systemName: "barometer")
                        .imageScale(.large)
                        .imageScale(.large)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.red, .primary, .primary)
                      
                    Text(weatherViewModel.pressure.formatted())
                    Text("\(weatherViewModel.pressure.value)")
                }.frame(maxWidth: .infinity)
                
                HStack {
                    Image(systemName: "humidity.fill")
                        .imageScale(.large)
                        .imageScale(.large)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.blue, .primary, .primary)
                   
                    Text(weatherViewModel.humidity.formatted() + "%")
                }.frame(maxWidth: .infinity)
                
            }
            .padding()
            
            VStack {
                
                Text("Speed")
                    .font(.title)
                Text("\(speedViewModel.speed, specifier: "%.1f") m/s")
                    .font(.largeTitle)
                Button("Go") {
                    locationViewModel.getLocationCity(location: locationViewModel.location)
                    weatherViewModel.getWeather(location: locationViewModel.location)
                }
            }
            .frame(maxWidth: .infinity)
            .border(.green)
            .backgroundStyle(Color(.red))
            .navigationTitle("Speed of Sound")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Image(systemName: "gearshape")
                }
            }
        }
       
        .onChange(of: weatherViewModel.temperature) { _ in
            speedViewModel.getSpeed(temperature: weatherViewModel.temperatureSI,
                                    pressure: weatherViewModel.pressureSI,
                                    humidity: weatherViewModel.humiditySI)
        }
        .onAppear() {
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

struct DoubleField: View {
    @Binding var number: Double
    
    @State var text: String
    
    var body: some View {
        TextField(text, text: $text)
            .keyboardType(.decimalPad)
    }
    
}

