//
//  BlutoothManeger.swift
//  CLE
//
//  Created by 神宮一敬 on 2024/12/13.
//
import CoreBluetooth
import UIKit

class PeripheralManager: NSObject, CBPeripheralManagerDelegate {
    var peripheralManager : CBPeripheralManager!
    var transferCharacteristic: CBMutableCharacteristic?
    
    override init() {
           super.init()
           peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    func startAdvertising() {
        let transferServiceUUID = CBUUID(string: "1234")
        print("advertisingを始めました")
        
        transferCharacteristic = CBMutableCharacteristic(
            type: transferServiceUUID,
            properties: [.read, .notify],
            value: nil,
            permissions: [.readable]
        )
        
        let transferService = CBMutableService(type: transferServiceUUID, primary: true)
        transferService.characteristics = [transferCharacteristic!]
        
        peripheralManager.add(transferService)
        
        peripheralManager.startAdvertising([
            CBAdvertisementDataServiceDataKey: [transferServiceUUID]
        ])
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
            if peripheral.state == .poweredOn {
                print("Peripheral is powered on")
            } else {
                print("Bluetooth is not available")
            }
        }
}


class CentralManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager!
    var discoveredPeripheral: CBPeripheral?
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func startScanning() {
        print("scannningを始めました")
        centralManager.scanForPeripherals(withServices: [CBUUID(string: "1234")], options: nil)
    }
    
    // Delegateメソッド
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("Central is powered on")
            startScanning()
        } else {
            print("Bluetooth is not available")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        print("Discovered \(peripheral.name ?? "unknown device")")
        discoveredPeripheral = peripheral
        centralManager.connect(peripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "unknown device")")
        peripheral.delegate = self
        peripheral.discoverServices([CBUUID(string: "1234")])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                peripheral.discoverCharacteristics([CBUUID(string: "1234")], for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.properties.contains(.read) {
                    peripheral.readValue(for: characteristic)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let value = characteristic.value {
                    print("Received: \(String(data: value, encoding: .utf8) ?? "nil")")
        }
    }
    
}



