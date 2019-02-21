//
//  ViewController.swift
//  SampleRTCSlideBar
//
//  Created by Fumiya Tanaka on 2019/02/21.
//  Copyright © 2019 Fumiya Tanaka. All rights reserved.
//

import UIKit
import SocketIO

class SocketViewController: UIViewController {

    @IBOutlet var label: UILabel!
    @IBOutlet var slider: UISlider!
    
    let manager = SocketManager.init(socketURL: URL(string: "http://localhost:8080")!)
    var defaultNameSpaceSocket: SocketIOClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaultNameSpaceSocket = manager.defaultSocket
        
        defaultNameSpaceSocket.on(clientEvent: SocketClientEvent.connect) { [weak self] (obj, emitter) in
            print("connect")
            let id = UUID.init().uuidString
            self?.defaultNameSpaceSocket.emit("join", [id])
        }
        
        defaultNameSpaceSocket.on("sliderValue") { (obj, emitter) in
            print("sliderValue detected")
            print(obj)
            
            let value = obj[0] as! Float
            self.slider.setValue(value, animated: true)
            self.label.text = String(value)
            
            
        }
        
        defaultNameSpaceSocket.on(clientEvent: .statusChange) { data, ack in
            print(data)
            print(ack)
        }
        
        defaultNameSpaceSocket.connect()
        
    }
    
    @IBAction func sliderValueChaged(slider: UISlider) {
        defaultNameSpaceSocket.emit("sliderValue", with: [slider.value])
    }
}

