//
//  ConnectionManager.swift
//  SkyLine2D
//
//  Created by Chris Dawson on 15/09/2017.
//  Copyright © 2017 University of York. All rights reserved.
//

import Foundation

class ConnectionManager {
    var connected: Bool
    var port: String
    var socketFileDescriptor: Int32
    // The message to be sent to the skyline pc
    var command: UnsafeMutablePointer<Int8> = UnsafeMutablePointer.allocate(capacity: 1)
    // A buffer which stores and communications from the skyline pc
    // A buffer of 85 bytes (since a CChar is 1 byte long) should be enough to store any communications
    // coming from the skyline pc. This size will need to be updated if the messages become longer
    var receiveBuf: UnsafeMutablePointer<CChar> = UnsafeMutablePointer.allocate(capacity: 85)
    
    init() {
        connected = false
        port = .init()        
        socketFileDescriptor = 0
    }
    
    // Opens a socket and connects to a given address
    
    // This had to be done in a bit of an unusual way for Swift since all the functions
    // for socket programming are C functions
    // A very useful guide to demystify some of these functions can be found here :
    // https://beej.us/guide/bgnet/html/single/bgnet.html
    // If this link doesn't work search for "Beej's guide to network programming"
    func connectTo(address: String, port: String) {
        var hints = addrinfo();
        var serverInfo: UnsafeMutablePointer<addrinfo>?;
        
        hints.ai_family = AF_INET
        hints.ai_socktype = SOCK_STREAM
        
        let status = getaddrinfo(address, port, &hints, &serverInfo)
        
        if(status >= 0) {
            // Open the socket
            socketFileDescriptor = socket((serverInfo?.pointee.ai_family)!, (serverInfo?.pointee.ai_socktype)!, (serverInfo?.pointee.ai_protocol)!)
            
            if(socketFileDescriptor >= 0) {
                // Connect to the skyline pc
                let connectionSuccess = connect(socketFileDescriptor, serverInfo?.pointee.ai_addr, (serverInfo?.pointee.ai_addrlen)!)
                
                if(connectionSuccess < 0) {
                    print("error: unable to connect")
                } else {
                    connected = true
                    print("connected")
                }
            } else {
                print("error: unable to create socket")
            }
        } else {
            print("error: getaddrinfo failed")
        }
        
        freeaddrinfo(serverInfo)
        
    }
    
    // Sends a message to the skyline pc
    // In the current version the message sent is a number which indicates which
    // buttons has been pressed
    func sendMessage(message: Int8) {
        if(connected) {
            var bytesSent: Int
            command.pointee = message
            
            // Send the data
            bytesSent = send(socketFileDescriptor, command, MemoryLayout<Int8>.size, 0)
            
            if(bytesSent < 0) {
                print("error: unable to send command")
            } else {
                // Sent successfully
                print(bytesSent)
            }
        } else {
            print("error: Not connected")
        }
    }
    
    // Receives a message from the skyline pc and returns a String represenatation of that message
    // Will return a String containing nothing if there was an error with reading
    func receiveMessage() -> String {
        if(connected) {
            // Reset the contents of the receive buffer
            receiveBuf.initialize(repeating: 0,count: 85)
            
            // Receive the message
            let bytesReceived = recv(socketFileDescriptor, receiveBuf, (MemoryLayout<CChar>.size) * 85, 0)
            
            if(bytesReceived < 0) {
                print("error reading")
            } else {
                // Message read successfully
                print(bytesReceived)
                return String(cString: receiveBuf)
            }
            return ""
        } else {
            print("error: Not connected")
            return ""
        }
    }
    
    // Close the connection between the phone and the skyline pc
    func closeConnection() {
        if(connected) {
            close(socketFileDescriptor)
            print("Connection closed")
        }
    }
}
