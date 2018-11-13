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
      //MARK: - Outlets
      @IBOutlet weak var tableView: UITableView!
      //MARK: - Properties
      var viewModel : FavoriteLocationsViewModel!
       //MARK: - View Life cycle
      override func viewDidLoad() {
            super.viewDidLoad()
            viewModel = FavoriteLocationsViewModel()
            getLocations()
      }
      //MARK: - Get Locations
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
      if viewModel.locations.count > 0 {
            addShowAllBtn()
      }
    }
    func getLocationErrorHandler() {
        SwiftSpinner.hide()
        showAlert(title: "", message: NSLocalizedString("general-error", comment: "") , vc: self, closure: nil)
    }
      //MARK: - Option Button
      func addShowAllBtn()
      {
            let showAllBtn = UIBarButtonItem(title: "Show All", style: .plain, target: self, action: #selector(showAllLocationOnMap))
            navigationItem.rightBarButtonItem = showAllBtn
      }
      @objc func showAllLocationOnMap() {
            let mapVC =  storyboard?.instantiateViewController(withIdentifier: "ShowAllLocationsViewController") as! ShowAllLocationsViewController
            mapVC.locations = viewModel.locations
            self.navigationController?.pushViewController(mapVC, animated: true)
      }
      
      //MARK: - TableView Datasource
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
      //MARK: - TableView Delegate
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
      }
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            openMap(index : indexPath.row)
      }
      func openMap(index : Int) {
            let mapVC =  storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
            mapVC.isMainView = false
            let location = viewModel.locations[index]
            let lat = location.value(forKeyPath: "latitude") as? Double
            let long = location.value(forKeyPath: "longitude") as? Double
            let mapViewModel = MapViewModel(isMainView: false, currentLocation: CLLocationCoordinate2D(latitude: lat!, longitude: long!))
            mapVC.viewModel = mapViewModel
            self.navigationController?.pushViewController(mapVC, animated: true)
      }
}

