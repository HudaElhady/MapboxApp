//
//  GeneralMethods.swift
//  MapboxApp
//
//  Created by Huda El Hady on 11/13/18.
//  Copyright © 2018 huda.elhady. All rights reserved.
//

import UIKit

func showAlert(title:String, message:String, vc:UIViewController, closure:(()->())?)
{
    let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    
    let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
    { (result : UIAlertAction) -> Void in
        closure?()
    }
    alertController.addAction(okAction)
    alertController.view.tintColor = UIColor.blue
    vc.present(alertController, animated: true, completion: nil)
}

