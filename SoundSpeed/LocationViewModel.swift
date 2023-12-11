//
//  LocationViewModel.swift
//  SoundWeather
//
//  Created by Marcus Painter on 09/12/2023.
//

import CoreLocation
import Foundation
import SwiftUI

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var location: CLLocation = CLLocation()
    @Published var city: String = "Location"

    private let locationManager: CLLocationManager
    private let geocoder: CLGeocoder

    override init() {
        locationManager = CLLocationManager()
        authorizationStatus = locationManager.authorizationStatus
        location = CLLocation()
        geocoder = CLGeocoder()

        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func start() {
        locationManager.startUpdatingLocation()
    }

    func stop() {
        locationManager.stopUpdatingLocation()
    }

    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    // https://developer.apple.com/forums/thread/721409
    func getLocationCity(location: CLLocation) {
       
        var city = ""
        geocoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
            print(self.location)
            guard error == nil else {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            guard placemarks!.count > 0 else {
                print("Problem with the data received from geocoder")
                return
            }
            
            if let placemark = placemarks?.first?.locality {
                self.city = placemark
            }
            else {
                self.city = ""
            }
        })
     
         return
    }

    // MARK: CLLocationManagerDelegate delegates
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:  // Location services are available.
            // Insert code here of what should happen when Location services are authorized
            authorizationStatus = .authorizedWhenInUse
            locationManager.requestLocation()
            break
            
        case .restricted:  // Location services currently unavailable.
            // Insert code here of what should happen when Location services are NOT authorized
            authorizationStatus = .restricted
            break
            
        case .denied:  // Location services currently unavailable.
            // Insert code here of what should happen when Location services are NOT authorized
            authorizationStatus = .denied
            break
            
        case .notDetermined:        // Authorization not determined yet.
            authorizationStatus = .notDetermined
            manager.requestWhenInUseAuthorization()
            break
            
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.first!
        print("Location",location.coordinate.latitude, location.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Mmanager: \(error)")
    }
}
