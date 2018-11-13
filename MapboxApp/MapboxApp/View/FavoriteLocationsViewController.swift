//
//  FavoriteLocationsViewController.swift
//  MapboxApp
//
//  Created by huda elhady on 11/13/18.
//  Copyright © 2018 huda.elhady. All rights reserved.
//

import UIKit
import CoreData
import SwiftSpinner
import CoreLocation


class FavoriteLocationsViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {
      @IBOutlet weak var tableView: UITableView!
      var locations : [NSManagedObject] = []
      var viewModel : FavoriteLocationsViewModel!
      override func viewDidLoad() {
            super.viewDidLoad()
            viewModel = FavoriteLocationsViewModel()
            getLocations()
      }
      
      
      func getLocations() {
            SwiftSpinner.show("Saving Location")
        viewModel.getLocations(completion: {[weak self] in
            self?.getLocationResponse()
            }, errorHandler: {[weak self] in
                self?.getLocationErrorHandler()
        })
      }
    
    func getLocationResponse() {
        SwiftSpinner.hide()
        tableView.reloadData()
    }
    func getLocationErrorHandler() {
        SwiftSpinner.hide()
        showAlert(title: "", message: NSLocalizedString("general-error", comment: "") , vc: self, closure: nil)
    }
    
      func tableView(_ tableView: UITableView,
                     numberOfRowsInSection section: Int) -> Int {
            return viewModel.locations.count
      }
      
      func tableView(_ tableView: UITableView,
                     cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let location = viewModel.locations[indexPath.row]
            let cell =
                  tableView.dequeueReusableCell(withIdentifier: "LocationCell",
                                                for: indexPath) as! LocationTableViewCell
            cell.setData(location: location)
            return cell
      }
      
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
      }
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            openMap(index : indexPath.row)
      }
      func openMap(index : Int) {
            let vc =  storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
            vc.isMainView = false
            let location = viewModel.locations[index]
            let lat = location.value(forKeyPath: "latitude") as? Double
            let long = location.value(forKeyPath: "longitude") as? Double
            vc.currentLocation = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
            self.navigationController?.pushViewController(vc, animated: true)
      }
}

