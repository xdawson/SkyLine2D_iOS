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
    var command: UnsafeMutablePointer<Int8> = UnsafeMutablePointer.allocate(capacity: 1)
    
    init() {
        connected = false
        port = .init()        
        socketFileDescriptor = 0
    }
    
    // Opens a socket and connects to a given address
    
    // This had to be done in a bit of an unusual way for Swift since all the functions
    // for socket programming are C functions
    func connectTo(address: String, port: String) {
        var hints = addrinfo();
        var serverInfo: UnsafeMutablePointer<addrinfo>?;
        
        hints.ai_family = AF_INET
        hints.ai_socktype = SOCK_STREAM
        
        let status = getaddrinfo(address, port, &hints, &serverInfo)
        
        if(status >= 0) {
            socketFileDescriptor = socket((serverInfo?.pointee.ai_family)!, (serverInfo?.pointee.ai_socktype)!, (serverInfo?.pointee.ai_protocol)!)
            
            if(socketFileDescriptor >= 0) {
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
    
    func sendMessage(message: Int8) {
        if(connected) {
            var bytesSent: Int
            command.pointee = message
            
            bytesSent = send(socketFileDescriptor, command, MemoryLayout<Int8>.size, 0)
            
            if(bytesSent < 0) {
                print("error: unable to send command")
            }
        } else {
            print("error: Not connected")
        }
    }
}
