//
//  LocationTableViewCell.swift
//  MapboxApp
//
//  Created by huda elhady on 11/13/18.
//  Copyright © 2018 huda.elhady. All rights reserved.
//

import UIKit
import CoreData

class LocationTableViewCell: UITableViewCell {
      
      @IBOutlet weak var containerView: UIView!
      
      @IBOutlet weak var locationLabel: UILabel!
      override func awakeFromNib() {
            super.awakeFromNib()
            setStyle()
      }
      func setData(location : NSManagedObject)
      {
            locationLabel.text = location.value(forKeyPath: "name") as? String
      }
      func setStyle() {
            containerView.layer.cornerRadius = 15
            containerView.layer.borderWidth = 1.5
            containerView.layer.borderColor = purpleColor.cgColor
      }
      
}

