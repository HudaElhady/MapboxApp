//
//  ViewController.swift
//  MapboxApp
//
//  Created by huda elhady on 11/13/18.
//  Copyright © 2018 huda.elhady. All rights reserved.
//

import UIKit
import CoreLocation
import Mapbox
import SwiftSpinner

class MapViewController: UIViewController,CLLocationManagerDelegate,MGLMapViewDelegate {
      //MARK: - Outlets
      @IBOutlet weak var mapView: MGLMapView!
      @IBOutlet weak var styleSegmentedControl: UISegmentedControl!
      //MARK: - Properties
      let locationManager = CLLocationManager()
      var currentLocation : CLLocationCoordinate2D!
      var locationName = ""
      lazy var geocoder = CLGeocoder()
      var viewModel : MapViewModel!
      var isMainView = true
      
      //MARK: - View Life cycle
      override func viewDidLoad() {
            super.viewDidLoad()
            setConfiguration()
            viewModel = MapViewModel()
      }
      
      func setConfiguration() {
            if isMainView {
                  addOptionsBtn()
                  setupLocationAcess()
            }
            addMarker()
      }
      
      @IBAction func mapStyleSegmentedControlHandler(_ sender: UISegmentedControl) {
            switch sender.selectedSegmentIndex {
            case 0:
                  mapView.styleURL = MGLStyle.streetsStyleURL
            case 1:
                  mapView.styleURL = MGLStyle.satelliteStyleURL
            case 2:
                  mapView.styleURL = MGLStyle.lightStyleURL
            default:
                  mapView.styleURL = MGLStyle.streetsStyleURL
            }
      }
      
      func saveLocationResponse() {
            SwiftSpinner.hide()
      }
      
      func setupLocationAcess() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            //cairo location
            currentLocation = CLLocationCoordinate2D(latitude: 30.06263, longitude: 31.24967)
      }
      func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let lastLocation: CLLocation = locations[locations.count - 1]
            currentLocation.latitude = lastLocation.coordinate.latitude
            currentLocation.longitude = lastLocation.coordinate.longitude
            addMarker()
            locationManager.stopUpdatingLocation()
      }
      
      
      func addMarker() {
            // Set the map’s center coordinate and zoom level.
            mapView.setCenter(CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude: currentLocation.longitude), zoomLevel: 12, animated: false)
            view.addSubview(mapView)
            mapView.styleURL = MGLStyle.streetsStyleURL
            // Set the delegate property of our map view to `self` after instantiating it.
            mapView.delegate = self
            
            geocoder.reverseGeocodeLocation(CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)) { (placemarks, error) in
                  // Process Response
                  self.processGeocodeLocationResponse(withPlacemarks: placemarks, error: error)
            }
      }
      
      func processGeocodeLocationResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
            // Update View
            if let error = error {
                  print("Unable to Reverse Geocode Location (\(error))")
                  //                  locationLabel.text = "Unable to Find Address for Location"
                  
            } else {
                  if let placemarks = placemarks, let placemark = placemarks.first {
                        let hello = MGLPointAnnotation()
                        hello.coordinate = CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude:  currentLocation.longitude)
                        hello.title = "Hello"
                        hello.subtitle = placemark.name
                        locationName = placemark.name!
                        mapView.addAnnotation(hello)
                  }
            }
      }
      
      // Allow callout view to appear when an annotation is tapped.
      func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
            return true
      }
      func addOptionsBtn()
      {
            let optionBtn = UIBarButtonItem(image: UIImage(named: "options"), style: .plain, target: self, action: #selector(displayOptions))
            //            closeBtn.tintColor = UIColor.white
            navigationItem.rightBarButtonItem = optionBtn
      }
      @objc func displayOptions() {
            let alertController = UIAlertController(title: "Options", message: "", preferredStyle: .actionSheet)
            
            let saveAction = UIAlertAction(title: "Save Location to Favorites", style: .default) { (action) in
                  SwiftSpinner.show("Saving Location")
                  self.viewModel.saveLocation(lat: self.currentLocation.latitude, long: self.currentLocation.longitude, locationName: self.locationName, saveLocationCompletion: {[weak self] in
                        self?.saveLocationResponse()
                  })
            }
            alertController.addAction(saveAction)
            let favaoritesAction = UIAlertAction(title: "Show Favaorite Locations", style: .default) { (action) in
                  self.performSegue(withIdentifier: "FavoriteSegue", sender: self)
            }
            alertController.addAction(favaoritesAction)
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil )
            alertController.addAction(cancelButton)
            //            alertController.view.tintColor =
            self.present(alertController, animated: true, completion: nil)
      }
}


