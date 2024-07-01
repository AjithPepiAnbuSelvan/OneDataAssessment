//
//  DeviceViewModel.swift
//  OneDataAssessment
//
//  Created by Ajith  on 01/07/24.
//

import UIKit
import CoreBluetooth

/// View model for managing Bluetooth device discovery and connection.
class DeviceViewModel {
    
    // MARK: - Properties
    /// The manager responsible for handling Bluetooth operations.
    var bluetoothManager: BluetoothManager
    
    /// List of discovered Bluetooth devices.
    var devices: [BluetoothDevice] = []
    
    /// Closure to notify when the list of devices has been updated.
    var onDevicesUpdated: (() -> Void)?
    
    
    // MARK: - Initialization
    /// Initializes the view model with a default Bluetooth manager and sets up bindings for events.
    init() {
        self.bluetoothManager = BluetoothManager()
        setupBindings()
    }
    
    /// Sets up bindings for Bluetooth manager events.
    private func setupBindings() {
        bluetoothManager.onDeviceDiscovered = { [weak self] peripheral in
            // Add the device to the list if it's not already present
            if !(self?.devices.contains(where: { $0.name == peripheral.name }) ?? false) {
                let bluetoothDevice = BluetoothDevice(name: peripheral.name ?? "Unknown Device", peripheral: peripheral)
                self?.devices.append(bluetoothDevice)
                self?.onDevicesUpdated?()
            }
        }

        bluetoothManager.onConnected = { peripheral in
            print("Connected to \(peripheral.name ?? "Unknown Device")")
        }

        bluetoothManager.onDisconnected = { peripheral in
            print("Disconnected from \(peripheral.name ?? "Unknown Device")")
        }

        bluetoothManager.onDataReceived = { data in
            print("Data received: \(data)")
        }
    }
    
    /// Starts scanning for nearby Bluetooth peripherals.
    func startScanning() {
        let scanOptions: [String: Any] = [
            CBCentralManagerScanOptionAllowDuplicatesKey: false,
            CBCentralManagerOptionShowPowerAlertKey: true
        ]
        
        bluetoothManager.centralManager.scanForPeripherals(withServices: nil, options: scanOptions)
    }

    /// Connects to the specified Bluetooth device.
    ///
    /// - Parameters:
    ///   - device: The Bluetooth device to connect to.
    ///   - viewController: The view controller from which the connection is initiated, used for presenting alerts.
    func connect(to device: BluetoothDevice, from viewController: UIViewController) {
        guard bluetoothManager.centralManager.state == .poweredOn else {
            showBluetoothNotEnabledAlert(in: viewController)
            return
        }

        guard let peripheral = device.peripheral else {
            print("Peripheral not found for device \(device.name). Cannot connect.")
            return
        }

        bluetoothManager.centralManager.connect(peripheral, options: nil)
    }
    
    /// Presents an alert notifying the user that Bluetooth is not enabled.
    ///
    /// - Parameter viewController: The view controller in which to present the alert.
    private func showBluetoothNotEnabledAlert(in viewController: UIViewController) {
        let alert = UIAlertController(title: "Bluetooth Not Enabled", message: "Bluetooth is not powered on. Please enable Bluetooth in Settings.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}
