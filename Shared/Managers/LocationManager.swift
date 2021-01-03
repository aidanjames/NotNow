//
//  LocationManager.swift
//  NotNow (iOS)
//
//  Created by Aidan Pendlebury on 03/01/2021.
//

import CoreLocation
import Foundation

class LocationManager {
    
    static let shared = LocationManager()
    
    private init() {}
    
    private let locationManager = CLLocationManager()
    
    
}
