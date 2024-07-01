//
//  BluetoothManager.swift
//  OneDataAssessment
//
//  Created by Ajith  on 01/07/24.
//

import CoreBluetooth

/// Manages Bluetooth central operations such as scanning for peripherals and managing connections.
class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    /// The CBCentralManager instance responsible for managing Bluetooth central role operations.
    var centralManager: CBCentralManager!
    
    /// List of discovered CBPeripheral objects during scanning.
    var discoveredPeripherals: [CBPeripheral] = []
    
    /// Closure type for handling device discovery events.
    var onDeviceDiscovered: ((CBPeripheral) -> Void)?
    
    /// Closure type for handling successful connection events.
    var onConnected: ((CBPeripheral) -> Void)?
    
    /// Closure type for handling disconnection events.
    var onDisconnected: ((CBPeripheral) -> Void)?
    
    /// Closure type for handling data received events.
    var onDataReceived: ((Data) -> Void)?
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    // MARK: - CBCentralManagerDelegate Methods
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        let stateMessages: [CBManagerState: String] = [
            .poweredOn: "Bluetooth is powered on.",
            .poweredOff: "Bluetooth is powered off.",
            .resetting: "Bluetooth is resetting.",
            .unauthorized: "Bluetooth is unauthorized.",
            .unsupported: "Bluetooth is unsupported.",
            .unknown: "Bluetooth state is unknown."
        ]
        
        if let message = stateMessages[central.state] {
            print(message)
        } else {
            print("Unknown Bluetooth state.")
        }
        
        if central.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    /// Initiates a connection to the specified peripheral.
    ///
    /// - Parameter peripheral: The peripheral to connect to.
    func connect(to peripheral: CBPeripheral) {
        guard centralManager.state == .poweredOn else {
            print("Cannot connect: Bluetooth is not powered on.")
            return
        }
        centralManager.connect(peripheral, options: nil)
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        discoveredPeripherals.append(peripheral)
        onDeviceDiscovered?(peripheral)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        onConnected?(peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect to peripheral: \(peripheral). Error: \(error?.localizedDescription ?? "Unknown error")")
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        onDisconnected?(peripheral)
    }

    // MARK: - CBPeripheralDelegate Methods
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.properties.contains(.read) {
                    peripheral.readValue(for: characteristic)
                }
                if characteristic.properties.contains(.notify) {
                    peripheral.setNotifyValue(true, for: characteristic)
                }
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let value = characteristic.value {
            onDataReceived?(value)
        }
    }
}
