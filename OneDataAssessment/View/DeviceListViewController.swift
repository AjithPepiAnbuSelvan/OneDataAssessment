//
//  DeviceListViewController.swift
//  OneDataAssessment
//
//  Created by Ajith  on 01/07/24.
//

import UIKit

/// A view controller responsible for displaying a list of Bluetooth devices and handling user interactions.
class DeviceListViewController: UIViewController {
    
    /// The table view displaying the list of Bluetooth devices.
    lazy var tableView: UITableView = {
        let table = UITableView(frame: view.bounds, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.register(DeviceCell.self, forCellReuseIdentifier: DeviceCell.reuseIdentifier)
        return table
    }()
    
    /// The view model managing data and interactions for Bluetooth devices.
    var deviceViewModel: DeviceViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deviceViewModel = DeviceViewModel()
        
        view.addSubview(tableView)
        
        // Reload table view when devices are updated in the view model
        deviceViewModel.onDevicesUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
        
        // Start scanning for Bluetooth devices
        deviceViewModel.startScanning()
        
        view.backgroundColor = .white
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource Extension

extension DeviceListViewController: UITableViewDelegate, UITableViewDataSource {
    
    /// Returns the number of rows in the table view based on the number of devices in the view model.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceViewModel.devices.count
    }
    
    /// Configures and returns a cell for the specified index path, displaying information about a Bluetooth device.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DeviceCell.reuseIdentifier, for: indexPath) as! DeviceCell
        let device = deviceViewModel.devices[indexPath.row]
        cell.configure(with: device)
        return cell
    }
    
    /// Handles the selection of a table view cell, initiating a connection to the selected Bluetooth device.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDevice = deviceViewModel.devices[indexPath.row]
        deviceViewModel.connect(to: selectedDevice, from: self)
    }
}

