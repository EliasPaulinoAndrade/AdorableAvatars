//
//  CommunicableUIViewController.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 28/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

protocol UIViewControllerInputData { }

protocol UIViewControllerAction { }

class UICommunicableViewController: UIViewController {
    var inputData: UIViewControllerInputData?
    var action: UIViewControllerAction?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.orderReceived(action: action, receivedData: inputData)
    }
    
    public func orderReceived(action: UIViewControllerAction?, receivedData: UIViewControllerInputData?) { }
    
    public func sendOrders(destination: UIViewController, action: UIViewControllerAction?, receivedData: UIViewControllerInputData?) { }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        sendOrders(destination: segue.destination, action: self.action, receivedData: self.inputData)
    }
}
