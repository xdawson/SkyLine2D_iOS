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
    // Controls the connection to the skyline pc
    let connectionManager = ConnectionManager()
    
    // The text boxes which display the text for each menu
    @IBOutlet weak var text1: UITextField!
    @IBOutlet weak var text2: UITextField!
    @IBOutlet weak var text3: UITextField!
    @IBOutlet weak var text4: UITextField!
    
    // An array of the text boxes
    var textBoxes = [UITextField]()
    
    // The cursor
    @IBOutlet weak var arrow: UIImageView!
    
    // Connect to the skyline pc
    // The address is the hostname of the pc, this is currently printed by the python program on startup
    @IBAction func connect(_ sender: UIButton) {
        connectionManager.connectTo(address: "biolpc3235", port: "9000")
        setMenuText()
    }
    
    @IBAction func closeConnection(_ sender: UIButton) {
        connectionManager.closeConnection()
    }
    
    // The following button presses send a message to the skyline pc indicating which button was pressed
    // The messages sent are as follows:
    // Up    -   1
    // Down  -   2
    // Left  -   3
    // Right -   4
    // Enter -   5
    @IBAction func enterButton(_ sender: UIButton) {
        print("Enter")
        connectionManager.sendMessage(message: 5)
        setMenuText()
    }
    
    @IBAction func upButton(_ sender: UIButton) {
        print("Up")
        connectionManager.sendMessage(message: 1)
        setMenuText()
    }
    
    @IBAction func downButton(_ sender: UIButton) {
        print("Down")
        connectionManager.sendMessage(message: 2)
        setMenuText()
    }
    
    @IBAction func leftButton(_ sender: UIButton) {
        print("Left")
        connectionManager.sendMessage(message: 3)
        setMenuText()
    }
    
    @IBAction func rightButton(_ sender: UIButton) {
        print("Right")
        connectionManager.sendMessage(message: 4)
        setMenuText()
    }
    
    // The startup of the app
    override func viewDidLoad() {
        super.viewDidLoad()
        textBoxes = [text1, text2, text3, text4]
        
        for text in textBoxes {
            text.isUserInteractionEnabled = false;
        }
    }
    
    // This function is generated automatically when you create an iOS project
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Sets the position of the cursor
    func setArrowPosition(position: Int) {
        // The y position for the arrow to be lined up with the first text box is 89
        // Any subsequent text boxes are positioned 40 lower than the previous one
        if(position >= 1 && position <= 4) {
            arrow.isHidden = false
            arrow.center.y = 89 + (CGFloat(position-1) * 40)
        } else {
            // Hide the arrow if the cursor is outside of the range
            // This will usually happen when the cursor is set to 0 on the skyline pc,
            // this happens when the cursor should not be displayed
            arrow.isHidden = true
        }
    }
    
    func setMenuText() {
        // Receives the message corresponding to the menu text which should be displayed in the
        // text boxes
        let menuText = connectionManager.receiveMessage()
        print(menuText)
        
        // Check to ensure the message contains data
        if(!menuText.isEmpty) {
            // The incoming message is in the form xx|xx|xx|xx where 'xx' represents some text that will be displayed
            // I split this message into 4 pieces using the '|' character as the split point
            let menus = menuText.split(separator: "|")
            // Set the text box text
            text1.text = String(menus[0])
            text2.text = String(menus[1])
            text3.text = String(menus[2])
            text4.text = String(menus[3])
        }
        
        // The message that immediately follows the menu text is the cursor position
        // The cursor position will be between 1 and 4
        let cursorPosition = connectionManager.receiveMessage()
        print(cursorPosition)
        
        if(!cursorPosition.isEmpty) {
            let position = Int(cursorPosition)!
            // Set the phone cursor position to be the same as the skyline pc's cursor position
            setArrowPosition(position: position)
        }
    }
}



