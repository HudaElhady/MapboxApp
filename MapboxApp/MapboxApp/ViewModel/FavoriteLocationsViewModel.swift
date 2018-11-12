//
//  FavoriteLocationsViewModel.swift
//  MapboxApp
//
//  Created by huda elhady on 11/13/18.
//  Copyright © 2018 huda.elhady. All rights reserved.
//

import UIKit
import CoreData

class FavoriteLocationsViewModel: NSObject {
      var updateTable: (()->())!
      var handleError : (()->())!
      var locations: [NSManagedObject] = []{
            didSet{
                  if updateTable != nil {
                        self.updateTable()
                  }
            }
      }
      func getLocations(completion: (()->())) {
            guard let appDelegate =
                  UIApplication.shared.delegate as? AppDelegate else {
                        return
            }
            let managedContext =
                  appDelegate.persistentContainer.viewContext
            let fetchRequest =
                  NSFetchRequest<NSManagedObject>(entityName: "Location")
            do {
                  locations = try managedContext.fetch(fetchRequest)
                  completion()
            } catch let error as NSError {
                  print("Could not fetch. \(error), \(error.userInfo)")
            }
      }
}
