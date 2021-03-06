//
//  MapViewModel.swift
//  MapboxApp
//
//  Created by huda elhady on 11/13/18.
//  Copyright © 2018 huda.elhady. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class MapViewModel: NSObject {
      //MARK: - Properties
      var currentLocation : CLLocationCoordinate2D!
      var isMainView :Bool!
       var locations: [NSManagedObject] = []
      //MARK: - intializers
      init(isMainView : Bool = true,currentLocation : CLLocationCoordinate2D!) {
            super.init()
            self.isMainView = isMainView
            self.currentLocation = currentLocation
      }
      //MARK: - Save Location
      func saveLocation(lat:Double,long:Double,locationName: String,saveLocationCompletion: (()->()),errorHandler:(()->())) {
            
            guard let appDelegate =
                  UIApplication.shared.delegate as? AppDelegate else {
                        return
            }
            let managedContext =
                  appDelegate.persistentContainer.viewContext
            
            let entity =
                  NSEntityDescription.entity(forEntityName: "Location",
                                             in: managedContext)!
            let location = NSManagedObject(entity: entity,
                                           insertInto: managedContext)
            
            location.setValue(lat, forKeyPath: "latitude")
            location.setValue(long, forKeyPath: "longitude")
            location.setValue(locationName, forKeyPath: "name")
            do {
                  try managedContext.save()
                  locations.append(location)
                  saveLocationCompletion()
            } catch let error as NSError {
                  print("Could not save. \(error), \(error.userInfo)")
                errorHandler()
            }
      }
}

