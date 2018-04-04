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
    let topMenuItems: [String] = ["Run", "Measurements", "Settings", "Manual"]
    let settingsMenuItems: [String] = ["Speeds", "Acceleration", "Deceleration", "Timeouts"]
    var inTopMenu = true
    var inSettingsMenu = false
    var positionInList = 0
    
    @IBOutlet weak var text1: UITextField!
    @IBOutlet weak var text2: UITextField!
    @IBOutlet weak var text3: UITextField!
    @IBOutlet weak var text4: UITextField!
    
    var textBoxes = [UITextField]()
    
    @IBOutlet weak var arrow: UIImageView!
    
    @IBAction func enterButton(_ sender: UIButton) {
        print("Enter")
        
        if(positionInList == 2 && inTopMenu) {
            for index in 0...textBoxes.count-1 {
                textBoxes[index].text = settingsMenuItems[index]
            }
            setArrowPosition(position: 0)
            inTopMenu = false
            inSettingsMenu = true
        }
    }
    
    @IBAction func upButton(_ sender: UIButton) {
        print("Up")
        arrow.center.y -= 40
        positionInList -= 1
        if(positionInList < 0) {
            setArrowPosition(position: 3)
        }
    }
    
    @IBAction func downButton(_ sender: UIButton) {
        print("Down")
        arrow.center.y += 40
        positionInList += 1
        if(positionInList > 3) {
            setArrowPosition(position: 0)
        }
    }
    
    @IBAction func leftButton(_ sender: UIButton) {
        print("Left")
        if(inSettingsMenu) {
            for index in 0...textBoxes.count-1 {
                textBoxes[index].text = topMenuItems[index]
            }
            setArrowPosition(position: 0)
            inSettingsMenu = false
            inTopMenu = true
        }
    }
    
    @IBAction func rightButton(_ sender: UIButton) {
        print("Right")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textBoxes = [text1, text2, text3, text4]
        
        for text in textBoxes {
            text.isUserInteractionEnabled = false;
        }
        
        for index in 0...textBoxes.count-1 {
            textBoxes[index].text = topMenuItems[index]
        }

        //connectionManager.connectTo(address: "192.168.137.1", port: "7000")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setArrowPosition(position: Int) {
        // Current y pos for option 1 is 78, and we move 40 between points
        if(position >= 0 && position <= 3) {
            switch position {
            case 0:
                arrow.center.y = 78 + 11
            default :
                arrow.center.y = (78 + 11) + CGFloat(position) * 40
            }
            positionInList = position
        }
    }
}



