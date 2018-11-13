//
//  ShowAllLocationsViewController.swift
//  MapboxApp
//
//  Created by huda elhady on 11/13/18.
//  Copyright © 2018 huda.elhady. All rights reserved.
//

import UIKit
import Mapbox
import CoreData

class ShowAllLocationsViewController :UIViewController,MGLMapViewDelegate {
      //MARK: - Outlets
      @IBOutlet weak var mapView: MGLMapView!
      @IBOutlet weak var styleSegmentedControl: UISegmentedControl!
      
      //MARK: - Properties
      var locations : [NSManagedObject] = []
      
      //MARK: - View Life cycle
      override func viewDidLoad() {
            super.viewDidLoad()
            setConfiguration()
      }
      
      func setConfiguration() {
            mapView.zoomLevel = 15
            mapView.styleURL = MGLStyle.streetsStyleURL
            mapView.delegate = self
           showAllAnnotation()
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
      func showAllAnnotation()  {
            var annotations = [MGLPointAnnotation]()
            for locationObj in locations {
                  let lat = locationObj.value(forKeyPath: "latitude") as? Double
                  let long = locationObj.value(forKeyPath: "longitude") as? Double
                  let name = locationObj.value(forKeyPath: "name") as? String
                  let currentLocation = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
                  annotations.append(addAnnotation(name: name ?? "", location: currentLocation))
            }
            mapView.addAnnotations(annotations)
      }
      
      func addAnnotation(name: String,location:CLLocationCoordinate2D)->MGLPointAnnotation {
            let newAnnotation = MGLPointAnnotation()
            newAnnotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude:location.longitude)
            newAnnotation.title = "Hello"
            newAnnotation.subtitle = name
            return newAnnotation            
      }
      
      // Allow callout view to appear when an annotation is tapped.
      func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
            return true
      }
}



