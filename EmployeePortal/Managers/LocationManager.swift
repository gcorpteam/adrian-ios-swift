//
//  LocationManager.swift
//  ArdhiRevamp
//
//  Created by Thahir Maheen on 4/26/18.
//  Copyright © 2018 S4M. All rights reserved.
//

import UIKit
import CoreLocation

enum LocationSignal: String {
    case noSignal
    case low
    case medium
    case high
    static let signals = [noSignal, low, medium, high]
}

extension CLLocation {
    var signal: LocationSignal {
        if horizontalAccuracy < 0 {
            return .noSignal
        } else if horizontalAccuracy > 150 {
            return LocationSignal.low
        } else if horizontalAccuracy > 50 {
            return LocationSignal.medium
        } else {
            return LocationSignal.high
        }
    }
    
    var isLowSignal: Bool {
        return signal == .noSignal || signal == .low
    }
}

class LocationManager: NSObject {
    
    static var shared = LocationManager()
        
    fileprivate let locationManager = CLLocationManager()
    
    // never clear this current location, as we are using it to pass it in the header of each request
    fileprivate(set) var currentLocation: CLLocation?
    
    typealias LocationCallBack = (_ location: CLLocation?, _ error: NSError?) -> Void
    fileprivate(set) var completionHandler: LocationCallBack?
    
    typealias HeaderCallBack = (_ heading: CLHeading?, _ error: NSError?) -> Void
    fileprivate(set) var headerHandler: HeaderCallBack?
    
    typealias AuthorizationCallBack = (_ status: CLAuthorizationStatus) -> Void
    fileprivate(set) var authorizationHandler: AuthorizationCallBack?
    
    // set this to true for getting location updates continuously
    var isContinuous = false
    
    var isLocationServicesEnabled: Bool {
        let status = CLLocationManager.authorizationStatus()
        return CLLocationManager.locationServicesEnabled() && (status == .authorizedAlways || status == .authorizedWhenInUse)
    }
    
    override init() {
        super.init()
        startLocationManager()
    }
    
    func requestWhenInUseAuthorization(_ completionHandler: AuthorizationCallBack? = nil) {
        
        // hook completion handler
        authorizationHandler = completionHandler
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestAlwaysAuthorization(_ completionHandler: AuthorizationCallBack? = nil) {
        
        // hook completion handler
        authorizationHandler = completionHandler
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    func showLocationSettings(_ completionHandler: AuthorizationCallBack? = nil) {
        
        // hook completion handler
        authorizationHandler = completionHandler
        
        if let stringUrlSettings = UIApplication.openSettingsURLString.removingPercentEncoding, let urlSettings = URL(string: stringUrlSettings) {
            UIApplication.shared.open(urlSettings)
        }
    }
    
    func fetchCurrentLocation(isContinuous: Bool = false, _ completionHandler: @escaping LocationCallBack) {
        
        // if location services are disabled send back nil
        if !isLocationServicesEnabled {
            //Toast.showError(with: &&"location_detect_error")
            completionHandler(nil, nil)
            return
        }
        
        self.isContinuous = isContinuous
        
        // update and send back location
        self.completionHandler = completionHandler
        
        startLocationManager()
        
        // XXX only to work on simulator
          //      completionHandler(nil, nil)
    }
    
    func fetchHeader(_ completionHandler: @escaping HeaderCallBack) {
        // if location services are disabled send back nil
        if !isLocationServicesEnabled {
            completionHandler(nil, nil)
            return
        }
        headerHandler = completionHandler
        
        startLocationHeader()
    
    }
    
    func lookUp(currentLocation: CLLocation, completionHandler: @escaping (CLPlacemark?)
        -> Void ) {
        
        let geocoder = CLGeocoder()
        
        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(currentLocation,
                                        completionHandler: { (placemarks, error) in
                                            if error == nil {
                                                let firstLocation = placemarks?[0]
                                                completionHandler(firstLocation)
                                            }
                                            else {
                                                // An error occurred during geocoding.
                                                completionHandler(nil)
                                            }
        })
    }
    
    fileprivate func startLocationManager() {
        print("called")
        // start updating location
        guard isLocationServicesEnabled else { return }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.stopUpdatingLocation()
        
        if isContinuous {
            locationManager.requestLocation()
            sleep(3)
//            sleep(3) { [weak self] in
               locationManager.startUpdatingLocation()
//            }
        }
        else {
            locationManager.requestLocation()
        }
    }
    
    func stopLocationManager() {
        print("stopped")
        isContinuous = false
        // clear any pending completion handler
        completionHandler = nil
        
        // stop updating
        locationManager.stopUpdatingLocation()
    }
    
    fileprivate func startLocationHeader() {
        
        // start updating location
        guard isLocationServicesEnabled else { return }
        
        locationManager.delegate = self
        locationManager.startUpdatingHeading()
    }
    
    func stopLocationHeader() {
        
        // clear any pending completion handler
        headerHandler = nil
        
        // stop updating
        locationManager.stopUpdatingHeading()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        // fire completion handler if any
        authorizationHandler?(status)
        
        // make sure completion handler is called just once
        authorizationHandler = nil
        
        status == .denied ? stopLocationManager() : startLocationManager()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        headerHandler?(newHeading, nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        currentLocation = locations.last
        completionHandler?(currentLocation, nil)
        
        // stop location manager if we dont want continuous updates
        if !isContinuous {
            stopLocationManager()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        // failed, send back error and the previously saved user location
        completionHandler?(currentLocation, error as NSError?)
        
        // make sure completion handler is called just once
        completionHandler = nil
    }
}
