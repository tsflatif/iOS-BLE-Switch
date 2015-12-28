//
//  ViewController.swift
//  BLE Switch
//
//  Created by Tauseef Latif on 2015-12-27.
//  Copyright © 2015 Tauseef Latif. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {

    let BLUE_HOME_SERVICE = "DFB0"
    
    var centralManager: CBCentralManager!
    var connectPeripheral: CBPeripheral!
    
    @IBOutlet weak var uiSwitch: UIView!
    
    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func uiSwitchValueChanged(sender: UISwitch) {
        
        if(sender.on){
            print("switch is ON")
        }
        else {
            print("Switch is OFF")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Attempt to make BLE Connection
        
        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "hasConnected", userInfo: nil, repeats: false)
        
        activityIndicator.startAnimating()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Close BLE Connection if any exists
    }
    
    func hasConnected(){
        activityIndicator.stopAnimating()
        shadowView.hidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Central Manager Delegates
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        print("centralManagerDidUpdateState: Started")
        
        switch (central.state){
        case .PoweredOff:
            print("Power is OFF")
            break
        case .Resetting:
            print("Resetting")
            break
        case .PoweredOn:
            print("Power is ON")
            break
        case .Unauthorized:
            print("Unauthorized")
            break
        case .Unsupported:
            print("Unsupported") 
            break
            
        default:
            print("Unknown")
            break
        }
    }


}

