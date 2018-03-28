//
//  ViewController.swift
//  SkyLine2D
//
//  Created by Chris Dawson on 19/07/2017.
//  Copyright © 2017 University of York. All rights reserved.
//

import UIKit
import CoreFoundation

class ViewController: UIViewController {
    let connectionManager = ConnectionManager()
    
    @IBAction func StopMotor(_ sender: UIButton) {
        connectionManager.sendMessage(message: 0)
    }
    @IBAction func DriveForward(_ sender: UIButton) {
        connectionManager.sendMessage(message: 1)
    }
    @IBAction func DriveBackward(_ sender: UIButton) {
        connectionManager.sendMessage(message: 2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectionManager.connectTo(address: "169.254.0.1", port: "7000")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



