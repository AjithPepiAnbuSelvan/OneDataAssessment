//
//  BluetoothDevice.swift
//  OneDataAssessment
//
//  Created by Ajith  on 01/07/24.
//

import Foundation
import CoreBluetooth

/// Represents a Bluetooth device identified by its name and optionally associated with a CBPeripheral instance.
struct BluetoothDevice {
    
    /// The name of the Bluetooth device.
    let name: String
    
    /// The CBPeripheral instance associated with the Bluetooth device, if available.
    var peripheral: CBPeripheral?
    
    /// Initializes a BluetoothDevice instance with the given name and optional peripheral.
    ///
    /// - Parameters:
    ///   - name: The name of the Bluetooth device.
    ///   - peripheral: Optional CBPeripheral instance associated with the device.
    init(name: String, peripheral: CBPeripheral? = nil) {
        self.name = name
        self.peripheral = peripheral
    }
}
