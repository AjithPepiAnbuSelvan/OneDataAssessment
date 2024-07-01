//
//  DeviceCell.swift
//  OneDataAssessment
//
//  Created by Ajith  on 01/07/24.
//

import UIKit

/// A UITableViewCell subclass used to display information about a Bluetooth device.
class DeviceCell: UITableViewCell {
    
    /// The reusable identifier for the cell.
    static let reuseIdentifier = "DeviceCell"
    
    /// Initializes a table cell with a style and a reuse identifier.
    ///
    /// - Parameters:
    ///   - style: A constant indicating a cell style. See `UITableViewCell.CellStyle` for valid styles.
    ///   - reuseIdentifier: A string used to identify the cell object if it is to be reused for drawing multiple rows of a table view.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Configures the cell to display information about the specified Bluetooth device.
    ///
    /// - Parameter device: The Bluetooth device object containing information to display.
    func configure(with device: BluetoothDevice) {
        textLabel?.text = device.name
    }
}
