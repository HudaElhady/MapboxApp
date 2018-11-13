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

class MapViewController: UIViewController,MGLMapViewDelegate {
      //MARK: - Outlets
      @IBOutlet weak var mapView: MGLMapView!
      @IBOutlet weak var styleSegmentedControl: UISegmentedControl!
      
      //MARK: - Properties
      let locationManager = CLLocationManager()
      var locationName = ""
      lazy var geocoder = CLGeocoder()
      var viewModel : MapViewModel!
      var isMainView = true
      
      //MARK: - View Life cycle
      override func viewDidLoad() {
            super.viewDidLoad()
            setConfiguration()
      }
      
      func setConfiguration() {
            if viewModel.isMainView {
                  addOptionsBtn()
                  startLocationServices()
            }else{
                  addMarker()
            }
      }
      //MARK: - Actions
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
      //MARK: - Option Button
      func addOptionsBtn()
      {
            let optionBtn = UIBarButtonItem(image: UIImage(named: "options"), style: .plain, target: self, action: #selector(displayOptions))
            navigationItem.rightBarButtonItem = optionBtn
      }
      @objc func displayOptions() {
            let alertController = UIAlertController(title: "Options", message: "", preferredStyle: .actionSheet)
            
            let saveAction = UIAlertAction(title: "Save Location to Favorites", style: .default) { (action) in
                 self.saveLocationAction()
            }
            alertController.addAction(saveAction)
            let favaoritesAction = UIAlertAction(title: "Show Favaorite Locations", style: .default) { (action) in
                  self.performSegue(withIdentifier: "FavoriteSegue", sender: self)
            }
            alertController.addAction(favaoritesAction)
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil )
            alertController.addAction(cancelButton)
            alertController.view.tintColor = purpleColor
            self.present(alertController, animated: true, completion: nil)
      }
      
      //MARK: - Save Location Action
      func saveLocationAction() {
            SwiftSpinner.show("Saving Location")
            self.viewModel.saveLocation(lat: self.viewModel.currentLocation.latitude, long: self.viewModel.currentLocation.longitude, locationName: self.locationName, saveLocationCompletion: {[weak self] in
                  self?.saveLocationResponse()
                  }, errorHandler: {[weak self] in
                        self?.saveLocationErrorHandler()
            })
      }
      func saveLocationResponse() {
            SwiftSpinner.hide()
            showAlert(title: "", message: NSLocalizedString("save-success", comment: ""), vc: self, closure: nil)
      }
      func saveLocationErrorHandler() {
            SwiftSpinner.hide()
            showAlert(title: "", message: NSLocalizedString("general-error", comment: ""), vc: self, closure: nil)
      }
}

extension MapViewController:CLLocationManagerDelegate
{
      //MARK: - Start Location Services
      func startLocationServices() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.delegate = self
            let locationAuthorizationStatus = CLLocationManager.authorizationStatus()
            switch locationAuthorizationStatus {
            case .notDetermined:
                  self.locationManager.requestWhenInUseAuthorization()
            case .authorizedWhenInUse, .authorizedAlways:
                  if CLLocationManager.locationServicesEnabled() {
                        self.locationManager.startUpdatingLocation()
                  }
            case .restricted, .denied:
                  showAlertWithLocationAcess()
            }
            
      }
      //MARK: - locationManager Delegate methods
      func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let lastLocation: CLLocation = locations[locations.count - 1]
            viewModel.currentLocation.latitude = lastLocation.coordinate.latitude
            viewModel.currentLocation.longitude = lastLocation.coordinate.longitude
            addMarker()
            locationManager.stopUpdatingLocation()
      }
      
      func locationManager(_ manager: CLLocationManager,
                           didChangeAuthorization status: CLAuthorizationStatus) {
            switch status {
            case .notDetermined:
                  break
            case .authorizedWhenInUse, .authorizedAlways:
                  if CLLocationManager.locationServicesEnabled() {
                        self.locationManager.startUpdatingLocation()
                  }
            case .restricted, .denied:
                  self.showAlertWithLocationAcess()
            }
      }
      
      func showAlertWithLocationAcess() {
            showAlert(title: NSLocalizedString("location-access-title", comment: ""), message: NSLocalizedString("location-access", comment: ""), vc: self, closure: {
                  //add cairo notation
                  self.addMarker()
            })
      }
      
      func addMarker() {
            mapView.setCenter(CLLocationCoordinate2D(latitude: viewModel.currentLocation.latitude, longitude: viewModel.currentLocation.longitude), zoomLevel: 12, animated: false)
            view.addSubview(mapView)
            mapView.styleURL = MGLStyle.streetsStyleURL
            mapView.delegate = self
            
            geocoder.reverseGeocodeLocation(CLLocation(latitude: viewModel.currentLocation.latitude, longitude: viewModel.currentLocation.longitude)) { (placemarks, error) in
                  self.processGeocodeLocationResponse(withPlacemarks: placemarks, error: error)
            }
      }
      
      func processGeocodeLocationResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
            // Update View
            if error == nil {
                  if let placemarks = placemarks, let placemark = placemarks.first {
                       removeExistingAnnotation()
                        addAnnotation(name: placemark.name ?? "", location: CLLocationCoordinate2D(latitude: viewModel.currentLocation.latitude, longitude:  viewModel.currentLocation.longitude))
                  }
            }
      }
      
      func removeExistingAnnotation() {
            if let annotations = mapView.annotations , annotations.count > 0
            {
                  mapView.removeAnnotation(annotations[0])
            }
      }
      
      func addAnnotation(name: String,location:CLLocationCoordinate2D) {
            let newAnnotation = MGLPointAnnotation()
            newAnnotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude:location.longitude)
            newAnnotation.title = "Hello"
            newAnnotation.subtitle = name
            locationName = name
            mapView.addAnnotation(newAnnotation)
      }
      
      // Allow callout view to appear when an annotation is tapped.
      func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
            return true
      }
}


