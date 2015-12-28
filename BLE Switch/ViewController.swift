//
//  ViewController.swift
//  BLE Switch
//
//  Created by Tauseef Latif on 2015-10-27.
//  Copyright © 2015 Tauseef Latif. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    // Bluetooth service device information
    let BLUE_HOME_SERVICE = "DFB0"
    let WRITE_CHARACTERISTIC = "DFB1"
    
    var centralManager: CBCentralManager!
    var connectPeripheral: CBPeripheral!
    
    var writeCharacteristic: CBCharacteristic!
    
    @IBOutlet weak var uiSwitch: UIView!
    
    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func uiSwitchValueChanged(sender: UISwitch) {
        
        if(sender.on){
            print("switch is ON")
            writeBLEData("<RELAY0>1;")
        }
        else {
            print("Switch is OFF")
            writeBLEData("<RELAY0>0;")
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
        
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "scanForBLEDevice", userInfo: nil, repeats: false)
        
        activityIndicator.startAnimating()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Close BLE Connection if any exists
    }
    
    func scanForBLEDevice(){
        centralManager.scanForPeripheralsWithServices([CBUUID(string: BLUE_HOME_SERVICE)], options: nil)
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        
        if (peripheral.name != nil){
            print("Found Peripheral name = \(peripheral.name!)")
        }
        else{
            print("Found Peripheral with unknown name")
        }
        
        // Save reference to the peripheral
        connectPeripheral = peripheral
        
        centralManager.stopScan()
        
        centralManager.connectPeripheral(connectPeripheral, options: nil)
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        
        print("Service count = \(peripheral.services!.count)")
        
        for service in peripheral.services!{
            print("Service = \(service)")
            
            let aService = service as CBService
            
            if service.UUID == CBUUID(string: BLUE_HOME_SERVICE){
                //Discover characteristics for our service
                peripheral.discoverCharacteristics(nil, forService: aService)
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        
        for characteristic in service.characteristics! {
            let aCharacteristic = characteristic as CBCharacteristic
            
            if aCharacteristic.UUID == CBUUID(string: WRITE_CHARACTERISTIC){
                print("We found our write Characteristics")
                writeCharacteristic = aCharacteristic
            }
        }
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        print("Connectrd to Device!")
        
        hideActivityIndicator()
        
        connectPeripheral.delegate = self
        
        connectPeripheral.discoverServices(nil)
    }
    
    func writeBLEData(string: String){
        let data = string.dataUsingEncoding(NSUTF8StringEncoding)
        connectPeripheral.writeValue(data!, forCharacteristic: writeCharacteristic, type: CBCharacteristicWriteType.WithResponse)
    }
    
    func hideActivityIndicator() {
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